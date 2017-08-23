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
    
    @IBOutlet weak var fontButton: UIBarButtonItem!
    
    var memedImage : UIImage!
    var meme : Meme?
    
    let TAG_TOP_TEXT = 1
    let TAG_BOTTOM_TEXT = 2
    
    var firstEditingTop = true
    var firstEditingBottom = true
    
    var topFontIndex = 0
    var bottomFontIndex = 0
    
    let availableFonts = [
        UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        UIFont(name: "Arial-BoldMT", size: 40)!,
        UIFont(name: "Futura-Medium", size: 40)!
    ]
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2]
    
    let placeHolderString = NSAttributedString(string: "Type Here",
    attributes: [
        NSForegroundColorAttributeName: UIColor.gray,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(topTextfield, withTag : TAG_TOP_TEXT)
        configure(bottomTextfield, withTag : TAG_BOTTOM_TEXT)
        
        if meme != nil {
            let meme = self.meme!
            topTextfield.text = meme.topText
            bottomTextfield.text = meme.topText
            imageView.image = meme.originalImage
        }
        
    }
    
    private func configure(_ textfield : UITextField, withTag tag : Int) {
        textfield.tag = tag
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .center
        textfield.attributedPlaceholder = placeHolderString
        textfield.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = imageView.image != nil
        
        hideFontButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAlbumImage(_ sender: Any) {
        pickImage(from: .photoLibrary)
    }
    
    
    @IBAction func cancelEditing(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickCameraImage(_ sender: Any) {
        pickImage(from: .camera)
    }
    
    private func pickImage( from sourceType : UIImagePickerControllerSourceType) {
        let pickImageController = UIImagePickerController()
        pickImageController.allowsEditing = true;
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
        
        AppDelegate.shared().add(meme)
        
        dismiss(animated: true, completion: nil)
    }
    
    private func generateMemedImage() -> UIImage {
        
        setMemeTools(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        setMemeTools(hidden: false)
        
        return memedImage
    }
    
    private func setMemeTools(hidden : Bool) {
        topToolbar.isHidden = hidden
        bottomToolbar.isHidden = hidden
        
        if hidden {
            topTextfield.placeholder = ""
            bottomTextfield.placeholder = ""
        } else {
            topTextfield.attributedPlaceholder = placeHolderString
            bottomTextfield.attributedPlaceholder = placeHolderString
        }
    }
    
    // MARK: font changing
    
    @IBAction func fontChange(_ sender: Any) {
        var newIndex : Int
        var textfield : UITextField
        
        if topTextfield.isEditing {
            topFontIndex = (topFontIndex + 1) % availableFonts.count
            newIndex = topFontIndex
            textfield = topTextfield
        } else {
            bottomFontIndex = (bottomFontIndex + 1) % availableFonts.count
            newIndex = bottomFontIndex
            textfield = bottomTextfield
        }
        
        let newFont = availableFonts[newIndex]
        textfield.font = newFont
        
        fontButton.title = newFont.fontName
    }
    
    
    fileprivate func showFontButton(of textfield : UITextField) {
        fontButton.title = textfield.font?.fontName
        fontButton.isEnabled = true
        fontButton.tintColor = nil
    }
    
    private func hideFontButton() {
        fontButton.isEnabled = false
        fontButton.tintColor = UIColor.clear
    }
    
    // MARK: keyboard events
    func keyboardWillShow(_ notification:Notification) {
        if topTextfield.isEditing {
            return
        }
        
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        if topTextfield.isEditing {
            return
        }
        
        view.frame.origin.y = 0
        
        hideFontButton()
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
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
        
        showFontButton(of: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == TAG_TOP_TEXT || textField.tag == TAG_BOTTOM_TEXT {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
}

