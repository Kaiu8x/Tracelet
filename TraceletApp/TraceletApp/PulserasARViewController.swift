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

class ViewController: UIViewController, ARSCNViewDelegate {
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    var pulsera = SCNNode()
    var visible = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = false
        //necesario para que se muestre la luz especular
        
        // Create a new scene
        do{
            let myURL = NSURL(string: "http://www.martinmolina.com.mx/201911/data/jsonTracelet/images/tracelet1.scn")
            let scene = try! SCNScene(url: myURL! as URL, options:nil)
            self.sceneView.scene = scene
            pulsera = scene.rootNode.childNode(withName: "Brazalete", recursively: true)!
            pulsera.isHidden = true
        
            let pinchGestureRecognizer = UIPinchGestureRecognizer (target: self, action: #selector(escalado))
            let rotationGestureRecognizer = UIRotationGestureRecognizer (target: self, action: #selector(rotacion))
            let tapGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector(ejecucionTap))
            
            sceneView.addGestureRecognizer(pinchGestureRecognizer)
            sceneView.addGestureRecognizer(rotationGestureRecognizer)
            sceneView.addGestureRecognizer(tapGestureRecognizer)
            
        } catch{
            
        }
        
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
