//
//  PulserasARViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 4/10/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
// http://www.martinmolina.com.mx/201911/data/jsonTracelet/images/tracelet1.scn

import UIKit
import SceneKit
import ARKit

class PulserasARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var textoExplicativo: UILabel!
    
    @IBOutlet var botonAgregarQuitar: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    var isShowing = false
    var pulsera = SCNNode()
    var visible = true
    let myURL = NSURL(string: "http://www.martinmolina.com.mx/201911/data/jsonTracelet/images/tracelet1.scn")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = false
        //necesario para que se muestre la luz especular
        
        textoExplicativo.text = "Da click aqui para agregar la pulsera"
        botonAgregarQuitar.setTitle("Agregar", for: .normal)
        
        // Create a new scene
        let scene = SCNScene()
//        pulsera = scene.rootNode.childNode(withName: "Brazalete", recursively: true)!
        //pulsera.isHidden = true
 
        self.sceneView.scene = scene
 
        let pinchGestureRecognizer = UIPinchGestureRecognizer (target: self, action: #selector(escalado))
        let rotationGestureRecognizer = UIRotationGestureRecognizer (target: self, action: #selector(rotacion))
//        let tapGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector(ejecucionTap))
        
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
        sceneView.addGestureRecognizer(rotationGestureRecognizer)
        //sceneView.addGestureRecognizer(tapGestureRecognizer)
            
        
    }
    
    @IBAction func rotacion(_ sender: UIRotationGestureRecognizer) {
        pulsera.eulerAngles = SCNVector3(0,sender.rotation,0)
    }
    
    @IBAction func ejecucionTap(_ sender: UITapGestureRecognizer) {
        /*let escena = sender.view as! SCNView
        let location = sender.location(in: escena)
        let hitResults  = escena.hitTest(location, options: [:])
        if !hitResults.isEmpty{
            let nodoTocado = hitResults[0].node
            nodoTocado.eulerAngles = SCNVector3(0,1,0)
        }*/
        if (pulsera.isHidden){
            pulsera.isHidden = false
        }else{
            pulsera.isHidden = true
        }
    }
    
    @objc func escalado(recognizer:UIPinchGestureRecognizer)
    {
        pulsera.scale = SCNVector3(recognizer.scale, recognizer.scale, recognizer.scale)
    }
    
    //CODIGO PARA LECTURA DE IMAGENES Y APARICION DE MODELOS 3D
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Cambio 1 cambiar a trackin a través de imagen
        let configuration = ARImageTrackingConfiguration()
        
        //Cambio 2, asignar la imagen marcadora
        guard let imagenesMarcador = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("No se encontró la imagen marcadora")
        }
        configuration.trackingImages = imagenesMarcador
        // Run the view's session
        sceneView.session.run(configuration)
    }
    //cambio 3, definir el método que será invocado al identificar una imágen marcador
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARImageAnchor{
            let imagenReferencia = anchor.referenceImage
            agregarModelo(to: node, refImage: imagenReferencia)
        }
    }
    // se agrega el modelo en basea la url de donde se quiere jalar el modelo
    private func agregarModelo(to node:SCNNode, refImage:ARReferenceImage ){
        DispatchQueue.global().async {
            let escenaModelo = try! SCNScene(url: self.myURL! as URL, options:nil)
            //encontrar el nodo principal
            let nodoPrincipal = escenaModelo.rootNode.childNode(withName: "Brazalete", recursively: true)!
            node.addChildNode(nodoPrincipal)
        }
    }
    // FIN DEL CODIGO DE MODELOS 3D POR TRACKEO DE IMAGENES
    
    //Funcion para agregar quitar pulseras
    @IBAction func agregarQuitar(_ sender: UIButton) {
        let scene = try! SCNScene(url: self.myURL! as URL, options:nil)
        
        if(isShowing == false){
            //Crear pulsera
            
            //Cambio a texto, boton y flag
            self.pulsera = scene.rootNode.childNode(withName: "Brazalete", recursively: true)!
            self.pulsera.name = "pulsera"
            pulsera.position = SCNVector3(x: 0, y: 0, z: -0.3)
            //pulsera.scale = SCNVector3(x:2, y:2, z:2)
            // Agregar el nodo a la escena  ?????? TAL VEZ CAMBIAR LINEA 123 POR UN LET VARIABLE = SCENE.....
            scene.rootNode.addChildNode(self.pulsera)
            sceneView.scene = scene
            
            textoExplicativo.text = "Da click aqui para quitar la pulsera"
            botonAgregarQuitar.setTitle("Quitar", for: .normal)
            
            print("entre a crear pulsera")
            
        } else{
            //Borrar pulsera
            //Cambio a texto, boton y flag
            self.pulsera.removeFromParentNode()
            
            textoExplicativo.text = "Da click aqui para agregar la pulsera"
            botonAgregarQuitar.setTitle("Agregar", for: .normal)
            
            print("entre a BORRAR pulsera")
           
        }
        isShowing = !isShowing
        
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
