//
//  AboutVC.swift
//  submission-ios-rawg
//
//  Created by Muhammad Hilmy Fauzi on 12/07/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    var def = UserDefaultServices.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgProfile.layer.cornerRadius = imgProfile.bounds.height/2
        imgProfile.contentMode = .scaleToFill

        NotificationCenter.default.addObserver(self, selector: #selector(profileUpdated(_:)), name: NOTIF_PROFILE_UPDATED, object: nil)

        setupUI()
    }
    
    func setupUI() {
        labelName.text = def.profileName
        labelPhone.text = def.profilePhoneNumber
        labelEmail.text = def.profileEmail
        
        if let profileImage = def.profileImage {
            imgProfile.image = UIImage(data: profileImage)
        }
    }
    
    @objc func profileUpdated(_ notif: Notification) {
        setupUI()
    }
    
    @IBAction func btnUpdateProfile(_ sender: Any) {
        performSegue(withIdentifier: "toUpdateProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUpdateProfile" {
            segue.destination.isModalInPresentation = true
        }
    }
}
