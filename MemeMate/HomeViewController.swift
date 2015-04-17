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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pickAlbumImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    private func setupUI() {
        // Setup imageView - this is where the camera photo / the image selected from the photo gallery will appear
        imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.backgroundColor = UIColor.grayColor()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Add a bottom toolbar with "pick" and "camera" options
        let toolbar: UIToolbar = UIToolbar()
        let pickAlbumImageButton = UIBarButtonItem(title: "Album", style: .Done, target: self, action: "pickAlbumImage")
        
        toolbar.frame = CGRectMake(0, self.view.frame.size.height - 46, self.view.frame.size.width, 48)
        toolbar.setItems([pickAlbumImageButton], animated: false)
        toolbar.backgroundColor = UIColor.grayColor()
        
        // Add all the subviews
        view.addSubview(toolbar)
        view.addSubview(imageView)
        
        // Setup constraints
        var imageWidthConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: 200
        )
        
        var imageHeightConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: 200
        )
        
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
        
        view.addConstraints([
            imageVerticalCenterConstraint, imageHorizontalCenterConstraint,
            imageWidthConstraint, imageHeightConstraint
        ])
    }

}

