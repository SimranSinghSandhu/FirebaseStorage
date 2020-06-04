//
//  ViewController.swift
//  FirebaseStorageApp
//
//  Created by Simran Singh Sandhu on 03/06/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    // Setting Up Google Button.
    let googleSignInBtn: GIDSignInButton = {
        let btn = GIDSignInButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(googleSignInBtn) // Adding Google SignIn Button inside the View.
        settingUpConstraints() // Setting Constraints
        
        // presenting the view controller for Signing In 
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Automatically sign in the user.
        restoreCredentials()
    }

    // Setting all the constraints of the View.
    private func settingUpConstraints() {
        googleSignInBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        googleSignInBtn.heightAnchor.constraint(equalToConstant: 75).isActive = true
        googleSignInBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        googleSignInBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    
    // Restore the Previous Sign in, If the user already exists.
    private func restoreCredentials() {
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        if Auth.auth().currentUser != nil {
            print("Current User Exists!")
        } else {
            print("No User Found!")
        }
    }
}

