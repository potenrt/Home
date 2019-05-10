//
//  ViewController.swift
//  Final_Project
//
//  Created by Narathorn Dontricharoen on 18/3/2562 BE.
//  Copyright © 2562 Narathorn Dontricharoen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    var selectorStatus:Bool = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "toSecondPage", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        signInButton.backgroundColor = .clear
        signInButton.layer.cornerRadius = 5
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.orange.cgColor
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signInSelectorChanged(_ sender: Any) {
        
        selectorStatus = !selectorStatus
        
        if selectorStatus {
            //signInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
        } else {
            //signInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            if selectorStatus {
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                    
                    if let u = user {
                        self?.performSegue(withIdentifier: "toSecondPage", sender: self)
                    } else {
                        
                    }
                    
                }
            } else {
                Auth.auth().createUser(withEmail: email, password: password) { user, error in
                    
                    if let u = user {
                        self.performSegue(withIdentifier: "toSecondPage", sender: self)
                    } else {
                        
                    }
                    
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
}

