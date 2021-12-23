//
//  ViewController.swift
//  imageObject
//
//  Created by Book on 2021/12/07.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        
        // 네모박스
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "아코.png")
        
        let node = SCNNode()
        node.geometry = box
        node.geometry?.materials = [material]
        node.position = SCNVector3(-0.2,0.1,-0.5)
        
        // 구
        let sphere = SCNSphere(radius: 0.2)
        
        sphere.firstMaterial?.diffuse.contents = UIImage(named: "earth.jpeg")
        
        let sphereNode = SCNNode(geometry: sphere)
        
        sphereNode.position = SCNVector3(0.2,0.1,-0.5)
        
        
        // 텍스트
        let textGeo = SCNText(string: "Dongguk Univ", extrusionDepth: 1.0)
        
        textGeo.firstMaterial?.diffuse.contents = UIColor.orange
        
        let textNode = SCNNode(geometry: textGeo)
        textNode.position = SCNVector3(-0.2, 0.3, -0.5)
        textNode.scale = SCNVector3(0.02,0.02,0.02)
        
        
        // 터치 적용 박스
        let touchBox = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let touchMaterial = SCNMaterial()
        touchMaterial.diffuse.contents = UIColor.orange
        touchMaterial.name = "Color"
        
        let touchNode = SCNNode(geometry: touchBox)
        touchNode.geometry?.materials = [touchMaterial]
        touchNode.position = SCNVector3(0.6, 0.1, -0.5)
        
        
        scene.rootNode.addChildNode(node)
        scene.rootNode.addChildNode(sphereNode)
        scene.rootNode.addChildNode(textNode)
        scene.rootNode.addChildNode(touchNode)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedLocation))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    @objc func tapped(recognizer : UITapGestureRecognizer){
        let sceneView = recognizer.view as! SCNView
        let touchLocation : CGPoint = recognizer.location(in: sceneView)
        let hitResults : [SCNHitTestResult] = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty {
            let node = hitResults[0].node
            let material : SCNMaterial? = node.geometry?.material(named: "Color")
            material?.diffuse.contents = UIColor.black
        }
    }
    
    @objc func tappedLocation(recognizer : UITapGestureRecognizer){
        let sceneView = recognizer.view as! SCNView
        let touchLocation : CGPoint = recognizer.location(in: sceneView)
        let hitResults : [SCNHitTestResult] = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty {
            let node = hitResults[0].node
            let touchNode : SCNNode? = node
            touchNode?.position = SCNVector3(0, 0, 0)
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
