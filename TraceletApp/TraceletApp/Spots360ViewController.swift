//
//  Spots360ViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 4/10/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class Spots360ViewController: UIViewController, ARSCNViewDelegate, ActivityIndicatorPresenter {
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet var sceneView: ARSCNView!
    var contentUrl = "http://all360media.com/wp-content/uploads/pano/laphil/media/video-ios.mp4"
    var isVideo = false
    var once = true
    
    var videoNodo = SKVideoNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(contentUrl)
        print(isVideo)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        registerGestureRecognizer()
    }
    
    private func registerGestureRecognizer()
    {
        let tapGesto = UITapGestureRecognizer(target: self, action: #selector(tapEnPantalla))
        self.sceneView.addGestureRecognizer(tapGesto)
    }
    
    @objc func tapEnPantalla(manejador:UIGestureRecognizer)
    {
        if(once) {
            //currentFrame es la imagen actual de la camara
            guard let currentFrame = self.sceneView.session.currentFrame else {return}
            
            //let path = Bundle.main.path(forResource: "CheeziPuffs", ofType: "mov")
            //let url = URL(fileURLWithPath: path!)
            
            //let moviePath = "http://ebookfrenzy.com/ios_book/movie/movie.mov"
            
            let url = URL(string: contentUrl)
            let player = AVPlayer(url: url!)
            player.volume = 0.5
            print(player.isMuted)
            
            // crear un nodo capaz de reporducir un video
            videoNodo = SKVideoNode(url: url!)
            //let videoNodo = SKVideoNode(fileNamed: "CheeziPuffs.mov")
            //let videoNodo = SKVideoNode(avPlayer: player)
            videoNodo.play() //ejecutar play al momento de presentarse
            
            //crear una escena sprite kit, los parametros estan en pixeles
            let spriteKitEscene =  SKScene(size: CGSize(width: 1024, height: 512))
            spriteKitEscene.addChild(videoNodo)
            
            videoNodo.size = spriteKitEscene.size
            
            //colocar el videoNodo en el centro de la escena tipo SpriteKit
            videoNodo.position = CGPoint(x: spriteKitEscene.size.width/2, y: spriteKitEscene.size.height/2)
            
            //crear una pantalla 4/3, los parametros son metros
            let esfera = SCNSphere(radius: 20.0)
            let materialEsfera = SCNMaterial()
            materialEsfera.diffuse.contents = spriteKitEscene
            materialEsfera.isDoubleSided = true
            
            
            //pantalla.firstMaterial?.diffuse.contents = UIColor.blue
            //modificar el material del plano
            esfera.firstMaterial?.diffuse.contents = spriteKitEscene
            //permitir ver el video por ambos lados
            esfera.firstMaterial?.isDoubleSided = true
            
            let pantallaEsfera = SCNNode(geometry: esfera)
            //identificar en donde se ha tocado el currentFrame
            var traduccion = matrix_identity_float4x4
            //definir un metro alejado del dispositivo
            traduccion.columns.3.z = -1.0
            pantallaEsfera.simdTransform = matrix_multiply(currentFrame.camera.transform, traduccion)
            
            pantallaEsfera.eulerAngles = SCNVector3(Double.pi, 0, 0)
            self.sceneView.scene.rootNode.addChildNode(pantallaEsfera)
            once = false
        }
    }
    
    
    @IBAction func swipeExit(_ sender: UISwipeGestureRecognizer) {
        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "tabBar") as! TabBarController
        //self.navigationController?.pushViewController(nextView, animated: true)
        videoNodo.pause()
        self.present(nextView, animated: true, completion: nil)
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
