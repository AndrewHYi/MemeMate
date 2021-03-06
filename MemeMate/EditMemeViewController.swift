//
//  EditMemeViewController.swift
//  MemeMate
//
//  Created by Andrew H. Yi on 4/11/15.
//  Copyright (c) 2015 AndrewHYi. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var imageView: UIImageView!
    var topTextField: UITextField!
    var bottomTextField: UITextField!
    var shareButton: UIBarButtonItem!
    var toolbar: UIToolbar!
    var meme: Meme!
    var mode = Mode.New
    var index: Int!
    enum Mode {
        case New
        case Resend
        case Edit
    }
    
    // MARK: Lifecycle callbacks
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        keyboardSubscribe()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardUnsubscribe()
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
            shareButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func shareImage() {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activity, completed, returnedItems, error) in
            if(completed) {
                self.saveImage(memedImage)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func cancel() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: helper functions
    func saveImage(memedImage: UIImage, completion: (()->())? = nil) {
        var meme = Meme(
            topText: topTextField.text,
            bottomText: bottomTextField.text,
            image: imageView.image!,
            memedImage: memedImage
        )
        
        if(mode == Mode.Edit) { // If edit mode, replace the old meme with the new edited one
            (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes[index] = meme
        } else {
            (UIApplication.sharedApplication().delegate as! AppDelegate).savedMemes.append(meme)
        }
    }
    
    func generateMemedImage() -> UIImage {
        toolbar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolbar.hidden = false
        return memedImage
    }
    
    // MARK: Text Field Events
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Mark: Subscribe to Keyboard Notifications and hook into show/hide events
    func keyboardSubscribe() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardUnsubscribe() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue().height
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= keyboardHeight!
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    // MARK: UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.grayColor()
        setupImageView()
        setupTextFields()
        setupToolbar()
        setupTopButtons()
        setupResendMeme() // Needs to be last; otherwise the various UIViews would be nil
    }
    
    private func setupResendMeme() {
        if(meme != nil){
            imageView.image = meme.image
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            shareButton.enabled = true
        }
        
        if(mode == Mode.Resend) {
            self.title = "Resend Meme"
            topTextField.enabled = false
            bottomTextField.enabled = false
        } else if(mode == Mode.Edit) {
           self.title = "Edit Meme"
        }
    }
    
    private func setupToolbar() {
        // Add a bottom toolbar with "pick" and "camera" options
        toolbar = UIToolbar()
        let pickAlbumImageButton = UIBarButtonItem(title: "Album", style: .Done, target: self, action: "pickImage:")
        pickAlbumImageButton.tag = UIImagePickerControllerSourceType.PhotoLibrary.rawValue
        
        let pickCameraImageButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "pickImage:")
        pickCameraImageButton.tag = UIImagePickerControllerSourceType.Camera.rawValue
        
        // Disable camera button for devices without a camera
        pickCameraImageButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Flex space for centering the toolbar buttons
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace, pickCameraImageButton, flexSpace, pickAlbumImageButton, flexSpace], animated: false)
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
        
        let toolbarLeftConstraint = NSLayoutConstraint(
            item: toolbar,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1,
            constant: 0
        )
        
        let toolbarRightConstraint = NSLayoutConstraint(
            item: toolbar,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1,
            constant: 0
        )
        
        view.addConstraints([toolbarBottomConstraint, toolbarLeftConstraint, toolbarRightConstraint])
    }
    
    private func setupImageView() {
        // Setup imageView - this is where the camera photo / the image selected from the photo gallery will appear
        imageView = UIImageView()
        imageView.backgroundColor = UIColor.grayColor()
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.backgroundColor = UIColor.grayColor()
        
        view.addSubview(imageView)
        
        let imageLeftConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1,
            constant: 0
        )
        
        let imageRightConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1,
            constant: 0
        )
        
        let top = NSLayoutConstraint(
            item: imageView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0
        )
        
        let bottom = NSLayoutConstraint(
            item: imageView,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0
        )
        
        view.addConstraints([
            top, bottom,
            imageLeftConstraint, imageRightConstraint
        ])
    }
    
    func setupTextFields() {
        func setupTextField(textField: UITextField, text: String) {
            let memeTextAttributes = [
                NSStrokeColorAttributeName : UIColor.blackColor(),
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
                NSStrokeWidthAttributeName : -3.0
            ]
            
            textField.delegate = self
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
    
    func setupTopButtons() {
        shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareImage")
        shareButton.enabled = false
        let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancel")
        
        navigationItem.leftBarButtonItem = shareButton
        navigationItem.rightBarButtonItem = cancelButton
    }

}

