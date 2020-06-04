//
//  UploadImageViewController.swift
//  FirebaseStorageApp
//
//  Created by Simran Singh Sandhu on 04/06/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class UploadImageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemGreen
        
        // Setting Up SignOutBtn
        settingSignOutButton()
        
        // Hiding the Back button.
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func settingSignOutButton() {
        // Creating SignOutButton as Right Bar Button in Navigation Bar.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutHandle))
    }
    
    @objc func signOutHandle() {
        do {
            try Auth.auth().signOut() // Siging Out From Firebase
            GIDSignIn.sharedInstance().signOut() // Signing Out from Google
            navigationController?.popToRootViewController(animated: true) // Navigation Back to RootViewController
            print("Sign Out Successful")
        } catch {
            print("Error Signing Out -", error.localizedDescription)
        }
    }
}
