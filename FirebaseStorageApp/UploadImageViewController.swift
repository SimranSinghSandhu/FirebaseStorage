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
        settingActionSheet()
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

extension UploadImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private func settingActionSheet() {
    
        // Creating a Controller as an Action Sheet.
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Creating Actions that we wanna show on the Alert Controller
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            print("Photo Library is Selected.")
            self.settingImagePicker(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            print("Camera is Selected.")
            self.settingImagePicker(sourceType: .camera)
        }
        
        // Removes the Already Selected Image
        let removePhotoAction = UIAlertAction(title: "Remove Photo", style: .destructive) { (action) in
            print("Remove Selected Photo.")
            self.showImageView.image = UIImage(named: "placeholderImage.jpg")
        }
        
        // Cancels the ActionSheet
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Cancel Action Sheet.")
            self.dismiss(animated: true, completion: nil)
        }
        
        // Adding Actions to the Controller
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(removePhotoAction)
        alertController.addAction(cancelAction)
        
        // Presenting the Controller.
        present(alertController, animated: true, completion: nil)
    }
    
    private func settingImagePicker(sourceType: UIImagePickerController.SourceType) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            pickerController.sourceType = sourceType
            print("Source Type is Aviable.")
        } else {
            print("Sorry This Feature does not exist in this Device.")
            self.dismiss(animated: true, completion: nil)
            
            // if PhotoLibrary or Camera is not avaiable in the Device then Show Error.
            showErrorAlert()
        }
        
        DispatchQueue.main.async {
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage { // If allows Editing is True
            print("Edited Image is Selected.")
            showImageView.image = image
        } else if let image = info[.originalImage] as? UIImage { // If allows Editing is False
            print("Original Image is Selected.")
            showImageView.image = image
        }
        // Dismissing the ViewController when the image is selected.
        dismiss(animated: true, completion: nil)
    }
    
    // Show Error if Camera or Photolibrary is not avaiable in the device.
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Feature Not Found.", message: "Sorry, This feature is not available in this Device.", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okayAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
