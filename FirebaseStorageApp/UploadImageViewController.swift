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
    
    // Setting Up UIImage to Select and Show Image.
    let showImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "placeholderImage.jpg")
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false) // Hiding the Back button.
        view.backgroundColor = UIColor.systemGreen // Setting Background Color for the View.
        
        view.addSubview(showImageView) // Adding ImageView (ShowImageView) inside the View.
        
        // Adding Tap Gesture on ImageView. (ShowImageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageViewTappedHandle))
        showImageView.addGestureRecognizer(tapGesture)
        
        // Setting Up SignOutBtn as the Right Bar Button in Navigation Bar.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutHandle))
        
        settingConstraints() // Setting Constraints
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

extension UploadImageViewController {
    
    // When ShowImageView is Tapped.
    @objc func ImageViewTappedHandle() {
        print("Image View is Pressed!")
    }
    
    private func settingConstraints() {
        
        // Determining the Screen Size
        let screenSize: CGRect = UIScreen.main.bounds
        let width = screenSize.width
        let spacing: CGFloat = 100
        
        showImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        showImageView.heightAnchor.constraint(equalToConstant: width - spacing).isActive = true
        showImageView.widthAnchor.constraint(equalToConstant: width - spacing).isActive = true
        showImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
}
