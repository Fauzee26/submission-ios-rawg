//
//  UpdateProfileVC.swift
//  submission-ios-rawg
//
//  Created by Muhammad Hilmy Fauzi on 18/07/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit

class UpdateProfileVC: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    
    var def = UserDefaultServices.instance
    private let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        btnUpdate.layer.cornerRadius = 5
        imgProfile.layer.cornerRadius = imgProfile.bounds.height/2
        imgProfile.contentMode = .scaleToFill

        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        txtName.text = def.profileName
        txtEmail.text = def.profileEmail
        txtPhoneNumber.text = def.profilePhoneNumber
        if let profileImage = def.profileImage {
            imgProfile.image = UIImage(data: profileImage)
        }        
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func alert(_ field: String ){
        let alertController = UIAlertController(title: "Warning", message: "\(field) cannot be empty", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnGetImagePressed(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnUpdateClicked(_ sender: Any) {
        if txtName.text!.isEmpty {
            alert("Name")
            return
        }
        
        if txtEmail.text!.isEmpty {
            alert("Email")
            return
        }
        
        if txtPhoneNumber.text!.isEmpty {
            alert("Phone Number")
            return
        }
        
        if let name = txtName.text, let email = txtEmail.text, let phoneNumber = txtPhoneNumber.text, let image = imgProfile.image, let data = image.pngData() as Data? {
            def.profileName = name
            def.profileEmail = email
            def.profilePhoneNumber = phoneNumber
            def.profileImage = data as Data
        }
        
        NotificationCenter.default.post(name: NOTIF_PROFILE_UPDATED, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UpdateProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let result = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.imgProfile.image = result
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Failed", message: "Image can't be loaded.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
