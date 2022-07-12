//
//  ARSceneViewController.swift
//  ML_AR_FlowerRecognizer
//
//  Created by Iryna Zubrytska on 06.07.2022.
//

import UIKit
import SceneKit
import ARKit

class ARSceneViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet private var sceneView: ARSCNView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    private let predictor = Predictor()
    private let flowerSearcher = FlowerSearcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSceneView()
        self.setupActions()
    }

    private func setupSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = true

        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(moveBack), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearScene), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    @objc func moveBack() {
        self.dismiss(animated: true)
    }

    @objc func clearScene() {
        sceneView.scene.rootNode.enumerateChildNodes({ (node,_)  in
            node.removeFromParentNode()
        })
    }

    @objc func handleTap() {
        let results = sceneView.hitTest(sceneView.center, types: [.estimatedHorizontalPlane])

        if let closestResult = results.first {
            let transform : matrix_float4x4 = closestResult.worldTransform
            let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x,
                                                         transform.columns.3.y,
                                                         transform.columns.3.z)

            let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
            guard let pixbuff = pixbuff else {
                return
            }
            let ciImage = CIImage(cvPixelBuffer: pixbuff)

            predictor.predict(image: ciImage, completion: { [weak self] predictions in
                guard let self = self,
                      let prediction = predictions?.first,
                      let flower = self.flowerSearcher.findFlowerWith(name: prediction.0) else {
                    return
                }

                let node: SCNNode = self.textNode(FlowerPredictionInfo(flower: flower,
                                                                       prediction: prediction).allInfo)
                self.sceneView.scene.rootNode.addChildNode(node)
                node.position = worldCoord
            })
        }
    }

    func textNode(_ text : String) -> SCNNode {
        // Warning: Creating 3D Text is susceptible to crashing. To reduce chances of crashing; reduce number of polygons, letters, smoothness, etc.

        let bubble = SCNText(string: text, extrusionDepth: CGFloat(0.01))
        let font = UIFont(name: "Futura", size: 0.15)
        bubble.font = font
        bubble.firstMaterial?.diffuse.contents = UIColor.orange
        bubble.firstMaterial?.specular.contents = UIColor.white
        bubble.firstMaterial?.isDoubleSided = true
        // bubble.flatness // setting this too low can cause crashes.
        bubble.chamferRadius = CGFloat(0.01)

        // BUBBLE NODE
        let (minBound, maxBound) = bubble.boundingBox
        let bubbleNode = SCNNode(geometry: bubble)
        // Centre Node - to Centre-Bottom point
        bubbleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, 0.01/2)
        // Reduce default text size
        bubbleNode.scale = SCNVector3Make(0.2, 0.2, 0.2)

        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        // to face the user
        bubbleNode.constraints = [billboardConstraint]

        return bubbleNode
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
