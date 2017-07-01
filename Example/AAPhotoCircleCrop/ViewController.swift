//
//  ViewController.swift
//  AAPhotoCircleCrop
//
//  Created by Andrea Antonioni on 01/14/2017.
//  Copyright (c) 2017 Andrea Antonioni. All rights reserved.
//

import UIKit
import AAPhotoCircleCrop

class ViewController: UIViewController, AACircleCropViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = false
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.contentMode = .scaleAspectFit
    }
    
    //- - -
    // MARK: - Actions
    //- - -
    @IBAction func cropAction(_ sender: UIButton) {
        let circleCropController = AACircleCropViewController(imageSize: CGSize(width: 300, height: 150))
        circleCropController.image = UIImage(named: "my_photo.jpg")!
        circleCropController.delegate = self
        
        // 🌎 use selectTitle and cancelTitle to localize buttons
        circleCropController.selectTitle = "Scegli" // 🇮🇹
        circleCropController.cancelTitle = "Annulla" // 🇮🇹
        present(circleCropController, animated: true, completion: nil)
    }

    //- - -
    // MARK: - AACircleCropViewControllerDelegate
    //- - -
    func circleCropDidCancel() {
        print("User canceled the crop flow")
    }
    
    func circleCropDidCropImage(_ image: UIImage) {
        imageView.image = image
        print("Image cropped!")
    }
}

