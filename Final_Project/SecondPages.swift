//
//  SecondPages.swift
//  Final_Project
//
//  Created by Narathorn Dontricharoen on 19/3/2562 BE.
//  Copyright © 2562 Narathorn Dontricharoen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SecondPages: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var addDeviceButton: UIButton!
    
    @IBOutlet weak var generateQRButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDeviceButton.setImage(UIImage(named: "plus.png"), for: [])
        generateQRButton.setImage(UIImage(named: "qr_code.png"), for: [])
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "homekit_wallpaper.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        addDeviceButton.backgroundColor = UIColor.white
        addDeviceButton.layer.cornerRadius = 5
        addDeviceButton.layer.borderWidth = 1
        addDeviceButton.layer.borderColor = UIColor.white.cgColor
        
        generateQRButton.backgroundColor = UIColor.white
        generateQRButton.layer.cornerRadius = 5
        generateQRButton.layer.borderWidth = 1
        generateQRButton.layer.borderColor = UIColor.white.cgColor
        
        signOutButton.backgroundColor = UIColor.white
        signOutButton.layer.cornerRadius = 5
        signOutButton.layer.borderWidth = 1
        signOutButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //self.performSegue(withIdentifier: "toLoginPage", sender: self)
            if Auth.auth().currentUser == nil {
                self.performSegue(withIdentifier: "toLoginPage", sender: self)
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
