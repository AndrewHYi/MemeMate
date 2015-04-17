//
//  HomeViewController.swift
//  MemeMate
//
//  Created by Andrew H. Yi on 4/11/15.
//  Copyright (c) 2015 AndrewHYi. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageView: UIImageView!
    var topTextField: UITextField!
    var bottomTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Button Actions
    func pickImage(sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType(rawValue: sender.tag)!
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.grayColor()
        setupImageView()
        setupTextFields()
        setupToolbar()
    }
    
    private func setupToolbar() {
        // Add a bottom toolbar with "pick" and "camera" options
        let toolbar: UIToolbar = UIToolbar()
        let pickAlbumImageButton = UIBarButtonItem(title: "Album", style: .Done, target: self, action: "pickImage:")
        pickAlbumImageButton.tag = UIImagePickerControllerSourceType.PhotoLibrary.rawValue
        
        let pickCameraImageButton = UIBarButtonItem(title: "Camera", style: .Done, target: self, action: "pickImage:")
        pickCameraImageButton.tag = UIImagePickerControllerSourceType.Camera.rawValue
        
        // Disable camera button for devices without a camera
        pickCameraImageButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        toolbar.frame = CGRectMake(0, self.view.frame.size.height - 46, self.view.frame.size.width, 48)
        toolbar.setItems([pickCameraImageButton, pickAlbumImageButton], animated: false)
        toolbar.backgroundColor = UIColor.grayColor()
        toolbar.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addSubview(toolbar)
        
        // Toolbar constraints
        let toolbarBottomConstraint = NSLayoutConstraint(
            item: toolbar,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0
        )
        
        let toolbarHeightConstraint = NSLayoutConstraint(
            item: toolbar,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: 50
        )
        
        let toolbarLeftConstraint = NSLayoutConstraint(
            item: toolbar,
            attribute: NSLayoutAttribute.LeadingMargin,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.LeadingMargin,
            multiplier: 1,
            constant: 0
        )
        
        let toolbarRightConstraint = NSLayoutConstraint(
            item: toolbar,
            attribute: NSLayoutAttribute.TrailingMargin,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.TrailingMargin,
            multiplier: 1,
            constant: 0
        )
        
        view.addConstraints([toolbarBottomConstraint, toolbarHeightConstraint, toolbarLeftConstraint, toolbarRightConstraint])
    }
    
    private func setupImageView() {
        // Setup imageView - this is where the camera photo / the image selected from the photo gallery will appear
        imageView = UIImageView()
        imageView.backgroundColor = UIColor.grayColor()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        view.addSubview(imageView)
        
        let imageVerticalCenterConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let imageHorizontalCenterConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let imageLeftConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: NSLayoutAttribute.LeadingMargin,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.LeadingMargin,
            multiplier: 1,
            constant: 0
        )
        
        let imageRightConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: NSLayoutAttribute.TrailingMargin,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.TrailingMargin,
            multiplier: 1,
            constant: 0
        )
        
        view.addConstraints([
            imageVerticalCenterConstraint, imageHorizontalCenterConstraint,
            imageLeftConstraint, imageRightConstraint
        ])
    }
    
    func setupTextFields() {
        func setupTextField(textField: UITextField, text: String) {
            let memeTextAttributes = [
                NSStrokeColorAttributeName : UIColor.blackColor(),
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                NSStrokeWidthAttributeName : -3.0
            ]
            
            textField.text = text
            textField.defaultTextAttributes = memeTextAttributes
            textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
            textField.textAlignment = NSTextAlignment.Center
            textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        }
        
        topTextField = UITextField()
        bottomTextField = UITextField()
        
        setupTextField(topTextField, "TOP")
        setupTextField(bottomTextField, "BOTTOM")
        
        view.addSubview(topTextField)
        view.addSubview(bottomTextField)
        
        // Top text field constraints
        let topTextTopConstraint = NSLayoutConstraint(
            item: topTextField,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 70
        )
        
        let topTextLeftConstraint = NSLayoutConstraint(
            item: topTextField,
            attribute: NSLayoutAttribute.LeadingMargin,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.LeadingMargin,
            multiplier: 1,
            constant: 10
        )
        
        let topTextRightConstraint = NSLayoutConstraint(
            item: topTextField,
            attribute: NSLayoutAttribute.TrailingMargin,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.TrailingMargin,
            multiplier: 1,
            constant: -10
        )
        
        // Bottom text field constraints
        let bottomTextBottomConstraint = NSLayoutConstraint(
            item: bottomTextField,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: -70
        )
        
        let bottomTextLeftConstraint = NSLayoutConstraint(
            item: bottomTextField,
            attribute: NSLayoutAttribute.LeadingMargin,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.LeadingMargin,
            multiplier: 1,
            constant: 10
        )
        
        let bottomTextRightConstraint = NSLayoutConstraint(
            item: bottomTextField,
            attribute: NSLayoutAttribute.TrailingMargin,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.TrailingMargin,
            multiplier: 1,
            constant: -10
        )
        
        
        view.addConstraints([
            topTextTopConstraint, topTextLeftConstraint, topTextRightConstraint,
            bottomTextBottomConstraint, bottomTextLeftConstraint, bottomTextRightConstraint
        ])
    }

}

