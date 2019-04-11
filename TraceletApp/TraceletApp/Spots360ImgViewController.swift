//
//  Spots360ImgViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 4/10/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class Spots360ImgViewController: UIViewController, ARSCNViewDelegate, ActivityIndicatorPresenter {

    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var sceneView: ARSCNView!
    let tierra = SCNNode()
    var once = true
    var contentUrl = ""
    var isVideo = false
    
    /*
    @IBAction func rotacion(_ sender: UIRotationGestureRecognizer) {
        
        tierra.eulerAngles = SCNVector3(0,sender.rotation,0)
    }
    
    @IBAction func ejecucionTap(_ sender: UITapGestureRecognizer) {
        let escena = sender.view as! SCNView
        let location = sender.location(in: escena)
        let hitResults  = escena.hitTest(location, options: [:])
        if !hitResults.isEmpty{
            let nodoTocado = hitResults[0].node
            nodoTocado.eulerAngles = SCNVector3(0,1,0)
        }
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //showActivityIndicator()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true //necesario para que se muestre la luz especular
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene = SCNScene()
        
        let esfera = SCNSphere(radius: 20.0)
        let materialTierra = SCNMaterial()
        //https://www.solarsystemscope.com/textures
        materialTierra.diffuse.contents = contentUrl
        materialTierra.isDoubleSided = true
        //materialTierra.diffuse.contents = UIImage(named:"earth-sumner.jpg")
        //materialTierra.diffuse.contents = #imageLiteral(resourceName: "Tierra Diffuse")
        //materialTierra.specular.contents = #imageLiteral(resourceName: "Tierra specular")
       // materialTierra.emission.contents =  #imageLiteral(resourceName: "Tierra emmision")
       // materialTierra.normal.contents = #imageLiteral(resourceName: "Tierra normal")
        tierra.geometry = esfera
        tierra.geometry?.materials = [materialTierra]
        //tierra.geometry?.firstMaterial?.specular.contents = UIColor.white
        tierra.position = SCNVector3(x:0, y:0, z:-0.5)
        scene.rootNode.addChildNode(tierra)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer (target: self, action: #selector(escalado))
        
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        // Set the scene to the view
        sceneView.scene = scene
        //self.hideActivityIndicator()
    }
    @objc func escalado(recognizer:UIPinchGestureRecognizer)
    {
        tierra.scale = SCNVector3(recognizer.scale, recognizer.scale, recognizer.scale)
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

