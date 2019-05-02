//
//  VideoExplicativoARViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 4/9/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class VideoExplicativoARViewController: UIViewController, ARSCNViewDelegate, ActivityIndicatorPresenter {
    
    var activityIndicator = UIActivityIndicatorView()
    var node = SCNNode()
    
    @IBOutlet var sceneView: ARSCNView!
    var onces = true
    
    @IBOutlet weak var playButton: UIButton!
    
    let moviePath = "http://martinmolina.com.mx/201911/data/jsonTracelet/images/Tracelet.mp4"
    var url = URL(string: "")
    var videoNodo = SKVideoNode()
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        // Create a new scene
        let scene =  SCNScene()
        let texto = SCNText(string: "Toca en cualquier parte para mostrar el video", extrusionDepth: 0.2)
        texto.firstMaterial?.diffuse.contents = UIColor.red
        node.geometry = texto
        node.position = SCNVector3(x:0,y:-1.0,z:-2.0)
        node.scale = SCNVector3(0.02, 0.02, 0.02)
        scene.rootNode.addChildNode(node)
        // Set the scene to the view
        sceneView.scene = scene
        registerGestureRecognizer()
        
        url = URL(string: self.moviePath)
        videoNodo = SKVideoNode(url: self.url!)
        playButton.isHidden = true
        
    }
    
    private func registerGestureRecognizer()
    {
        let tapGesto = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        self.sceneView.addGestureRecognizer(tapGesto)
    }
    
    @objc func tapEnPantalla(manejador:UIGestureRecognizer)
    {
        
        
        if(onces){
            showActivityIndicator()
            
                //let child = SpinnerViewController()
                
                // add the spinner view controller
                //addChild(child)
                //child.view.frame = view.frame
                //view.addSubview(child.view)
                //child.didMove(toParent: self)
                
                // wait two seconds to simulate some work happening
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    // then remove the spinner view controller
                    guard let currentFrame = self.sceneView.session.currentFrame else {return}
                    
                    //let path = Bundle.main.path(forResource: "CheeziPuffs", ofType: "mov")
                    //let url = URL(fileURLWithPath: path!)
                    
                    //let moviePath = "https://vimeo.com/328093358"
                    self.node.removeFromParentNode()
                    let moviePath = "http://martinmolina.com.mx/201911/data/jsonTracelet/images/Tracelet.mp4"
                    let url = URL(string: moviePath)
                    let player = AVPlayer(url: url!)
                    player.volume = 0.5
                    print(player.isMuted)
                    
                    // crear un nodo capaz de reporducir un video
                    
                    self.videoNodo.play() //ejecutar play al momento de presentarse
                    
                    //crear una escena sprite kit, los parametros estan en pixeles
                    let spriteKitEscene =  SKScene(size: CGSize(width: 640, height: 480))
                    spriteKitEscene.addChild(self.videoNodo)
                    
                    //colocar el videoNodo en el centro de la escena tipo SpriteKit
                    self.videoNodo.position = CGPoint(x: spriteKitEscene.size.width/2, y: spriteKitEscene.size.height/2)
                    self.videoNodo.size = spriteKitEscene.size
                    
                    //crear una pantalla 4/3, los parametros son metros
                    let pantalla = SCNPlane(width: 1.0, height: 0.75)
                    
                    //pantalla.firstMaterial?.diffuse.contents = UIColor.blue
                    //modificar el material del plano
                    pantalla.firstMaterial?.diffuse.contents = spriteKitEscene
                    //permitir ver el video por ambos lados
                    pantalla.firstMaterial?.isDoubleSided = true
                    
                    let pantallaPlanaNodo = SCNNode(geometry: pantalla)
                    //identificar en donde se ha tocado el currentFrame
                    var traduccion = matrix_identity_float4x4
                    //definir un metro alejado del dispositivo
                    traduccion.columns.3.z = -2.0
                    pantallaPlanaNodo.simdTransform = matrix_multiply(currentFrame.camera.transform, traduccion)
                    
                    //Aqui realizas la rotación de pantalla
                    pantallaPlanaNodo.eulerAngles = SCNVector3(Double.pi, 0, 0)
                    self.sceneView.scene.rootNode.addChildNode(pantallaPlanaNodo)
                    self.hideActivityIndicator()
                    self.playButton.isHidden = false
                    
                    //child.willMove(toParent: nil)
                    //child.view.removeFromSuperview()
                    //child.removeFromParent()
                    self.isPlaying = true
                    self.playButton.titleLabel?.text = "Pause"
                }
            
            onces = false
            
            
            //currentFrame es la imagen actual de la camara
            
        }
        
        
    }
    
    @IBAction func tapPlay(_ sender: Any) {
        if(!onces) {
            if(isPlaying) {
                self.playButton.setTitle("Play", for: .normal)
                self.videoNodo.pause()
            } else {
                self.playButton.setTitle("Pause", for: .normal)
                self.videoNodo.play()
            }
            isPlaying = !isPlaying
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
