//
//  MemeMeViewController.swift
//  MemeMe 1.0
//
//  Created by Reem Alosaimi on 24/09/2019.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var topToolbar: UIToolbar!
    @IBOutlet var bottomToolbar: UIToolbar!
    @IBOutlet var actionButton: UIBarButtonItem!
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionButton.isEnabled = false
        setupTextField(topTextField, text: "TOP")
        setupTextField(bottomTextField, text: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        keyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeKeyboardNotifications()
    }
    
    func setupTextField(_ textField: UITextField, text: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttribs
        textField.textAlignment = .center
        textField.text = text
    }
    
    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            actionButton.isEnabled = true
        }
        else if let image = info [UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            actionButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func pickImage(_ sender: Any) {
        let button = sender as! UIBarButtonItem
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = button.tag == 0 ? .camera : .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        actionButton.isEnabled = false
        imageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memeImage: UIImage = generateMeme()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {( type, ok, items, error ) in
            if ok {
                self.saveMeme(memeImage)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
     func generateMeme() -> UIImage {
        // Hide toolbar and navbar
        setToolbarState(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        setToolbarState(false)
        
        return memedImage
    }
    
    
    func saveMeme(_ img: UIImage)
    {
        _=Meme(topText:topTextField.text!, bottomText: bottomTextField.text!,originalImage:imageView.image!,memedImage:generateMeme())
    }
    
    func setToolbarState(_ hidden: Bool) {
        topToolbar.isHidden = hidden
        bottomToolbar.isHidden = hidden
    }
    
    let memeTextAttribs: [NSAttributedString.Key:Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 40)!,
        NSAttributedString.Key.strokeWidth: -2]
    
}


