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
        DispatchQueue.main.async {
            self.flowerNameLabel.text = prediction.0
            self.probabilityLabel.text = "\(prediction.1 * 100) %"
            self.originLabel.text = "🏠 \(flower.description.origin)"
            self.bloomingLabel.text = "🌸 \(flower.description.blooming)"
            self.sunLabel.text = "☀️ \(flower.maintenance.sunlight)"
            self.wateringLabel.text = "💧 \(flower.maintenance.watering)"
            self.soilLabel.text = "🌿 \(flower.maintenance.soil)"
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
    private func clearLabels(){
        self.flowerNameLabel.text = nil
        self.probabilityLabel.text = nil
        self.originLabel.text = nil
        self.bloomingLabel.text = nil
        self.sunLabel.text = nil
        self.wateringLabel.text = nil
        self.soilLabel.text = nil
    }
}

extension ImageRecognitionViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        clearLabels()
        let image = info[.originalImage] as! UIImage
        imageView.image = image
        DispatchQueue.global(qos: .userInteractive).async {
            self.predictor.predict(image: image, completion: self.showPrediction)
        }
        picker.dismiss(animated: true)
    }
}
