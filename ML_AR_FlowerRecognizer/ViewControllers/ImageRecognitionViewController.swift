//
//  ImageRecognitionViewController.swift
//  ML_AR_FlowerRecognizer
//
//  Created by Iryna Zubrytska on 03.07.2022.
//

import UIKit

class ImageRecognitionViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var flowerNameLabel: UILabel!
    @IBOutlet weak var probabilityLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var bloomingLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var wateringLabel: UILabel!
    @IBOutlet weak var soilLabel: UILabel!

    @IBOutlet weak var galleryImage: UIImageView!

    private var image: UIImage?

    private let predictor = Predictor()
    private let flowerSearcher = FlowerSearcher()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
        self.configureActions()
    }

    private func configureActions() {
        let galleryTap = UITapGestureRecognizer(target: self, action: #selector(galleryTapped))
        galleryImage.addGestureRecognizer(galleryTap)
        galleryImage.isUserInteractionEnabled = true

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
