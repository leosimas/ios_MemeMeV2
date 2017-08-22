//
//  MemeEditorViewController.swift
//  Meme Me v1
//
//  Created by SoSucesso on 22/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var memedImage : UIImage!
    
    let TAG_TOP_TEXT = 1
    let TAG_BOTTOM_TEXT = 2
    
    var firstEditingTop = true
    var firstEditingBottom = true
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextfield.tag = TAG_TOP_TEXT
        topTextfield.defaultTextAttributes = memeTextAttributes
        topTextfield.textAlignment = .center
        
        bottomTextfield.tag = TAG_BOTTOM_TEXT
        bottomTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.textAlignment = .center
        
        topTextfield.delegate = self
        bottomTextfield.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = imageView.image != nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAlbumImage(_ sender: Any) {
        pickImage(from: .photoLibrary)
    }
    
    @IBAction func pickCameraImage(_ sender: Any) {
        pickImage(from: .camera)
    }
    
    private func pickImage( from sourceType : UIImagePickerControllerSourceType) {
        let pickImageController = UIImagePickerController()
        pickImageController.delegate = self
        pickImageController.sourceType = sourceType
        present(pickImageController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        memedImage = generateMemedImage()
        
        let shareVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareVC.completionWithItemsHandler = {(activityType, completed, returnedItems, activityError) in
            
            if activityError != nil {
                let alert = UIAlertController(title: "Share Error", message: activityError?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if completed {
                self.saveMeme()
            }
            
        }
        present(shareVC, animated: true, completion: nil)
    }
    
    // MARK: Meme generator
    
    private func saveMeme() {
        let meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        // TODO
    }
    
    private func generateMemedImage() -> UIImage {
        
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    
    // MARK: keyboard events
    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    private func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
}

// MARK: UIImagePickerControllerDelegate
extension MemeEditorViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: textfield delegate
extension MemeEditorViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == TAG_TOP_TEXT && firstEditingTop {
            firstEditingTop = false
            textField.text = "TOP"
        } else if textField.tag == TAG_BOTTOM_TEXT && firstEditingBottom {
            firstEditingTop = false
            textField.text = "BOTTOM"
        }
    }
    
}

