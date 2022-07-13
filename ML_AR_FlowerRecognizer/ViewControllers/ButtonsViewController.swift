//
//  ButtonsViewController.swift
//  ML_AR_FlowerRecognizer
//
//  Created by Iryna Zubrytska on 30.06.2022.
//

import UIKit

class ButtonsViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet private weak var photoImage: UIImageView!
    @IBOutlet private weak var cameraImage: UIImageView!

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
        let vc = ImageRecognitionViewController(nibName: "ImageRecognitionViewController", bundle: nil)
        vc.setImage(UIImage(systemName: "photo.artframe")!)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    @objc func cameraTapped() {
        let vc = ARSceneViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    @objc func cameraTappedAlert() {
        let alert = UIAlertController(title: "Oops!",
                                      message: "The feature is not implemented yet.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
