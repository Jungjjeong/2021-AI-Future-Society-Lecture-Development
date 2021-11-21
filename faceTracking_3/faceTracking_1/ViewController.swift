//
//  ViewController.swift
//  faceTracking_1
//
//  Created by Book on 2021/11/08.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var contentNode: SCNNode?
    
    lazy var eyeLeftNode = contentNode?.childNode(withName: "eyeLeft", recursively: true)
    lazy var eyeRightNode = contentNode?.childNode(withName: "eyeRight", recursively: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSceneView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func resetTracking() {
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func setupSceneView(){
        sceneView.delegate = self
    }
}

extension ViewController: ARSCNViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else {return nil}

        let resourceName = "robotHead"
        let contentNode = SCNReferenceNode(named: resourceName)

        return contentNode
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {return}

        let blendShapes = faceAnchor.blendShapes
        if let eyeBlinkLeft = blendShapes[.eyeBlinkLeft] as? Float, let eyeBlinkRight = blendShapes[.eyeBlinkRight] as? Float {
            eyeLeftNode?.scale.z = 1-eyeBlinkLeft
            eyeRightNode?.scale.z = 1-eyeBlinkRight
        }
    }
}

extension SCNReferenceNode{
    convenience init(named resourceName: String, loadImmediately: Bool = true) {
        let url = Bundle.main.url(forResource: resourceName, withExtension: "scn", subdirectory: "Models.scnassets")!

        self.init(url : url)!
        if loadImmediately {
            self.load()
        }
    }
}
