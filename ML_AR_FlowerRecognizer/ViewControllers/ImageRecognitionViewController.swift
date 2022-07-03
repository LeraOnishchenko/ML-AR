//
//  ImageRecognitionViewController.swift
//  ML_AR_FlowerRecognizer
//
//  Created by Iryna Zubrytska on 03.07.2022.
//

import UIKit

class ImageRecognitionViewController: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
        self.configureLabels()
        self.configureActions()
    }

    private func configureLabels() {
        self.flowerNameLabel.text = "Flower Name"
        self.probabilityLabel.text = "99%"
        self.originLabel.text = "Origin: Ukraine"
        self.bloomingLabel.text = "🌸 Blooms in spring"
        self.sunLabel.text = "☀️ Loves sun"
        self.wateringLabel.text = "💧 Needs watering every 2-3 days"
        self.soilLabel.text = "🌿 some kind of soil"
    }

    private func configureActions() {
        let galleryTap = UITapGestureRecognizer(target: self, action: #selector(galleryTapped))
        galleryImage.addGestureRecognizer(galleryTap)
        galleryImage.isUserInteractionEnabled = true
    }

    @objc func galleryTapped() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .photoLibrary
        present(imagePickerVC, animated: true)
    }

    func setImage(_ image: UIImage) {
        self.image = image
    }
}

extension ImageRecognitionViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        imageView.image = image
//        DispatchQueue.global(qos: .userInteractive).async {
//            self.predictor.predict(image: image, completion: self.showPrediction)
//        }
        picker.dismiss(animated: true)
    }
}
