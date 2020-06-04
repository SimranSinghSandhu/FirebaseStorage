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

class ViewController: UIViewController, GIDSignInDelegate {

    // Setting Up Google Button.
    let googleSignInBtn: GIDSignInButton = {
        let btn = GIDSignInButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.delegate = self
        
        // presenting the view controller for Signing In
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        view.addSubview(googleSignInBtn) // Adding Google SignIn Button inside the View.
        settingUpConstraints() // Setting Constraints
        
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }

    // Setting all the constraints of the View.
    private func settingUpConstraints() {
        googleSignInBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        googleSignInBtn.heightAnchor.constraint(equalToConstant: 75).isActive = true
        googleSignInBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        googleSignInBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    
    private func navigateToDestinationViewController() {
        let destinationVC = UploadImageViewController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension ViewController {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print("Error Signing in with Google -", error.localizedDescription)
        } else {
            print("Google Signed In Successful!")
            // Navigating to DestinationViewController when Google Sign in is Successful.
            navigateToDestinationViewController()
            
            guard let authentication = user.authentication else {return}
            
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                if error != nil {
                    print("Error Authenticating with Firebase -", error?.localizedDescription)
                } else {
                    print("Firebase Sign In Successful!")
                }
            }
        }
    }
}
