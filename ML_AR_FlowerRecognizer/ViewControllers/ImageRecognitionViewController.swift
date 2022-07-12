//
//  ImageRecognitionViewController.swift
//  ML_AR_FlowerRecognizer
//
//  Created by Iryna Zubrytska on 03.07.2022.
//

import UIKit

class ImageRecognitionViewController: UIViewController {

    @IBOutlet private weak var backButton: UIButton!

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var flowerNameLabel: UILabel!
    @IBOutlet private weak var probabilityLabel: UILabel!
    @IBOutlet private weak var originLabel: UILabel!
    @IBOutlet private weak var bloomingLabel: UILabel!
    @IBOutlet private weak var sunLabel: UILabel!
    @IBOutlet private weak var wateringLabel: UILabel!
    @IBOutlet private weak var soilLabel: UILabel!

    @IBOutlet weak var galleryButton: UIButton!

    private var image: UIImage?

    private let predictor = Predictor()
    private let flowerSearcher = FlowerSearcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
        self.configureActions()
    }

    private func configureActions() {
        galleryButton.addTarget(self, action: #selector(galleryTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(moveBack), for: .touchUpInside)
    }

    @objc func galleryTapped() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .photoLibrary
        present(imagePickerVC, animated: true)
    }

    @objc func moveBack() {
        self.dismiss(animated: true)
    }

    func setImage(_ image: UIImage) {
        self.image = image
    }

    private func showPrediction(_ predictions: [Prediction]?) {
        guard let prediction = predictions?.first,
              let flower = flowerSearcher.findFlowerWith(name: prediction.0) else {
                  showFlowerNotRecognized()
                  return
              }
        self.setInfo(FlowerPredictionInfo(flower: flower, prediction: prediction))
    }

    private func setInfo(_ info: FlowerPredictionInfo) {
        DispatchQueue.main.async {
            self.flowerNameLabel.text = info.name
            self.probabilityLabel.text = info.probability
            self.originLabel.text = info.origin
            self.bloomingLabel.text = info.blooming
            self.sunLabel.text = info.sunlight
            self.wateringLabel.text = info.watering
            self.soilLabel.text = info.soil
        }
    }

    private func showFlowerNotRecognized() {
        let alert = UIAlertController(title: "Flower could not be recognized.",
                                      message: "Try again or choose another image.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ImageRecognitionViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        DispatchQueue.global(qos: .userInteractive).async {
            self.predictor.predict(image: image, completion: self.showPrediction)
        }
        picker.dismiss(animated: true)
    }
}
