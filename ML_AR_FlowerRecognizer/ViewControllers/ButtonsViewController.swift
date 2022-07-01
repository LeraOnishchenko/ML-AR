//
//  ButtonsViewController.swift
//  ML_AR_FlowerRecognizer
//
//  Created by Iryna Zubrytska on 30.06.2022.
//

import UIKit

class ButtonsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var cameraImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureActions()
    }

    private func configureActions() {
        let galleryTap = UITapGestureRecognizer(target: self, action: #selector(galleryTapped))
        photoImage.addGestureRecognizer(galleryTap)

        let cameraTap = UITapGestureRecognizer(target: self, action: #selector(cameraTapped))
        cameraImage.addGestureRecognizer(cameraTap)

        cameraImage.isUserInteractionEnabled = true
        photoImage.isUserInteractionEnabled = true
    }

    @objc func galleryTapped() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .photoLibrary
        present(imagePickerVC, animated: true)
    }

    @objc func cameraTapped() {
        let alert = UIAlertController(title: "Oops!",
                                      message: "The feature is not implemented yet.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
