//
//  AACircleCropViewController.swift
//
//  Created by Keke Arif on 29/02/2016.
//  Modified by Andrea Antonioni on 14/01/2017
//  Copyright © 2017 Andrea Antonioni. All rights reserved.
//

import UIKit

@objc public protocol AACircleCropViewControllerDelegate {
    
    func circleCropDidCropImage(_ image: UIImage)
    @objc optional func circleCropDidCancel()
}

open class AACircleCropViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Open properties
    /// Set the delegate to get the cropped image
    open var delegate: AACircleCropViewControllerDelegate?
    /// Image to crop
    open var image: UIImage!
    /// Set the size to get the cropped image resized. The
    /// default size is the circleDiameter
    open var imageSize: CGSize

    var scaleFactor: CGFloat {
        let padding: CGFloat = 25
        if imageSize.width > self.view.frame.width - padding*2 {
            return (self.view.frame.width - padding*2) / imageSize.width
        } else if imageSize.height > self.view.frame.height - padding*2 {
            return (self.view.frame.height - padding*2) / imageSize.height
        } else {
            return 1
        }
    }

    var scaledSize: CGSize {
        return CGSize(width: imageSize.width * scaleFactor, height: imageSize.height * scaleFactor)
    }

    /// Titles of the buttons. You can use them for localization
    open var selectTitle: String = "Select"
    open var cancelTitle: String = "Cancel"
    /// Status bar style
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private properties
    fileprivate var selectButton: UIButton!
    fileprivate var cancelButton: UIButton!
    fileprivate var imageView: UIImageView!
    fileprivate var scrollView: AACircleCropScrollView!
    fileprivate var cutterView: AACircleCropCutterView!

    public init(imageSize: CGSize) {
        self.imageSize = imageSize
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //- - -
    // MARK: - View Management
    //- - -
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black


        // Setup imageView
        imageView = UIImageView()
        imageView.image = image
        imageView.frame = CGRect(origin: CGPoint.zero, size: image.size)

        // Setup scrollView
        scrollView = AACircleCropScrollView(frame: CGRect(origin: CGPoint.zero, size: scaledSize))
        scrollView.backgroundColor = UIColor.black
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        scrollView.contentSize = image.size
        
        let scaleWidth = scrollView.frame.size.width / scrollView.contentSize.width
        scrollView.minimumZoomScale = scaleWidth
//        if imageView.frame.size.width < scrollView.frame.size.width {
//            print("We have the case where the frame is too small")
//            scrollView.maximumZoomScale = scaleWidth * 2
//        } else {
//            scrollView.maximumZoomScale = 1.0
//        }
        scrollView.zoomScale = scaleWidth

        // Center vertically
        scrollView.contentOffset = CGPoint(x: 0, y: (scrollView.contentSize.height - scrollView.frame.size.height)/2)
        
        scrollView.center = view.center
        view.addSubview(scrollView)
        
        setupCutterView()
        setupButtons()
    }
    
    override open func dismiss(animated: Bool, completion: (() -> Void)?) {
        if isModal {
            super.dismiss(animated: animated, completion: completion)
        } else {
            _ = navigationController?.popViewController(animated: animated)
        }
    }

    //- - -
    // MARK: - Helper methods
    //- - -
    
    fileprivate func setupCutterView() {
        cutterView = AACircleCropCutterView(frame: CGRect(origin: CGPoint.zero, size: imageSize))
        cutterView.center = self.view.center
        cutterView.imageSize = imageSize

        view.addSubview(cutterView)
        
        cutterView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: cutterView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: cutterView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: cutterView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: cutterView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0))
    }
    
    fileprivate func setupButtons() {
        
        selectButton = UIButton()
        cancelButton = UIButton()
        
        // Styles
        selectButton.setTitle(selectTitle, for: .normal)
        selectButton.setTitleColor(UIColor.white, for: .normal)
        selectButton.titleLabel?.font = cancelButton.titleLabel?.font.withSize(17)
        selectButton.addTarget(self, action: #selector(selectAction), for: .touchUpInside)
        
        cancelButton.setTitle(cancelTitle, for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.titleLabel?.font = cancelButton.titleLabel?.font.withSize(17)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        // Adding buttons to the superview
        cutterView.addSubview(selectButton)
        cutterView.addSubview(cancelButton)
        
        // cancelButton constraints
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cutterView.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: cutterView, attribute: .leadingMargin, multiplier: 1, constant: 20))
        cutterView.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .bottomMargin, relatedBy: .equal, toItem: cutterView, attribute: .bottomMargin, multiplier: 1, constant: -32))
        
        // selectButton consrtraints
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        cutterView.addConstraint(NSLayoutConstraint(item: selectButton, attribute: .trailing, relatedBy: .equal, toItem: cutterView, attribute: .trailingMargin, multiplier: 1, constant: -20))
        cutterView.addConstraint(NSLayoutConstraint(item: selectButton, attribute: .bottomMargin, relatedBy: .equal, toItem: cutterView, attribute: .bottomMargin, multiplier: 1, constant: -32))
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    //- - -
    // MARK: - Actions
    //- - -
    
    func selectAction() {
        
        let newSize = CGSize(width: image.size.width * scrollView.zoomScale / scaleFactor, height: image.size.height * scrollView.zoomScale / scaleFactor)
        let offset = CGPoint(x: scrollView.contentOffset.x / scaleFactor, y: scrollView.contentOffset.y / scaleFactor)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageSize.width, height: imageSize.height), false, 0)
        let sharpRect = CGRect(x: -offset.x, y: -offset.y, width: newSize.width, height: newSize.height)
        image.draw(in: sharpRect.integral)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let imageData = UIImagePNGRepresentation(finalImage!), var pngImage = UIImage(data: imageData) {
            pngImage = pngImage.resizeImage(newWidth: imageSize.width)
            delegate?.circleCropDidCropImage(pngImage)
            
        } else {
            delegate?.circleCropDidCancel?()
        }
        self.dismiss(animated: true, completion: nil) 
    }
    
    func cancelAction() {
        delegate?.circleCropDidCancel?()
        self.dismiss(animated: true, completion: nil)
    }
}
