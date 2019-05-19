//
//  MachineLearningViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 5/17/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//
import UIKit
import SceneKit
import ARKit
import Vision

class MachineLearningViewController: UIViewController, ARSCNViewDelegate {
    
     private var hitTestResult: ARHitTestResult!
     private var traceletModel = Tracelet50()
     private var visionRequests = [VNRequest]()
     //1. cargar el modelo de la red
     //2. registrar el gesto de tap
     //3. instanciar el modelo y enviar la imagen
     //4. Presentar los datos resultados del modelo
    
     @IBOutlet weak var sceneView: ARSCNView!
    
     @IBAction func tapEjecutado(_ sender: UITapGestureRecognizer) {
     //obtener la vista donde se va a trabajar
     let vista = sender.view as! ARSCNView
     //ubicar el toque en el centro de la vista
     let ubicacionToque = self.sceneView.center
     //obtener la imagen actual
     guard let currentFrame = vista.session.currentFrame else {return}
     //obtener los nodos que fueron tocados por el rayo
     let hitTestResults = vista.hitTest(ubicacionToque, types: .featurePoint)
     
     if (hitTestResults.isEmpty){
     //no se toco nada
     return}
     guard var hitTestResult = hitTestResults.first else{
     return
     }
     //obtener la imagen capturada en formato de buffer de pixeles
     let imagenPixeles = currentFrame.capturedImage
     self.hitTestResult = hitTestResult
     performVisionRequest(pixelBuffer: imagenPixeles)
     }
     
     private func performVisionRequest(pixelBuffer: CVPixelBuffer){
        //inicializar el modelo de ML al modelo usado, en este caso tracelet
        let visionModel = try! VNCoreMLModel(for: traceletModel.model)
        let request = VNCoreMLRequest(model: visionModel) { request, error in
            
        if error != nil {
            //hubo un error
            return }
        guard let observations = request.results else {
            //no hubo resultados por parte del modelo
            return
        }
         //obtener el mejor resultado
        let observation = observations.first as! VNClassificationObservation
         
        print("Nombre \(observation.identifier) confianza \(observation.confidence)")
        self.desplegarTexto(entrada: observation.identifier)
     
        }
        //la imagen que se pasará al modelo sera recortada para quedarse con el centro
        request.imageCropAndScaleOption = .centerCrop
        self.visionRequests = [request]
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .upMirrored, options: [:])
        DispatchQueue.global().async {
            try! imageRequestHandler.perform(self.visionRequests)
         }
     }
    
     private func desplegarTexto(entrada: String){
         let letrero = SCNText(string: entrada
         , extrusionDepth: 0)
         letrero.alignmentMode = CATextLayerAlignmentMode.center.rawValue
         letrero.firstMaterial?.diffuse.contents = UIColor.blue
         letrero.firstMaterial?.specular.contents = UIColor.white
         letrero.firstMaterial?.isDoubleSided = true
         letrero.font = UIFont(name: "Futura", size: 0.20)
         let nodo = SCNNode(geometry: letrero)
         nodo.position = SCNVector3(self.hitTestResult.worldTransform.columns.3.x,self.hitTestResult.worldTransform.columns.3.y-0.2,self.hitTestResult.worldTransform.columns.3.z )
         nodo.scale = SCNVector3Make(0.2, 0.2, 0.2)
         self.sceneView.scene.rootNode.addChildNode(nodo)
     }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATextLayerAlignmentMode(_ input: CATextLayerAlignmentMode) -> String {
    return input.rawValue
}
