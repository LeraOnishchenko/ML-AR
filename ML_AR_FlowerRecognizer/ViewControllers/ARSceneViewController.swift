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
                                                         -0.5)

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

                let info = FlowerPredictionInfo(flower: flower, prediction: prediction)
                let node: SCNNode = self.createTitleNode(info.allInfo)
                self.sceneView.scene.rootNode.addChildNode(node)
                node.position = worldCoord
            })
        }
    }
    
    private func createTitleNode(_ text : String) -> SCNNode {
        let title = SCNText(string: text, extrusionDepth: 0.6)
        title.firstMaterial?.diffuse.contents = UIColor.orange
        title.firstMaterial?.specular.contents = UIColor.white
        title.firstMaterial?.isDoubleSided = true
        title.chamferRadius = CGFloat(0.01)

        let titleNode = SCNNode(geometry: title)
        titleNode.scale = SCNVector3(0.005, 0.005, 0.01)

//        let (minBound, maxBound) = bubble.boundingBox
//        let bubbleNode = SCNNode(geometry: bubble)
        // Centre Node - to Centre-Bottom point
//        bubbleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, 0.01/2)

        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        // to face the user
        titleNode.constraints = [billboardConstraint]
        return titleNode
    }
}
