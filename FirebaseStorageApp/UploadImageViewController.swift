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
import AVFoundation

class UploadImageViewController: UIViewController {
    
    // Setting Up UIImage to Select and Show Image.
    let showImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(named: "placeholderImage.jpg")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let uploadBtn: UIButton = {
        let btn = UIButton()
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
        btn.backgroundColor = UIColor.systemBlue
        btn.setTitle("Upload", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        btn.titleLabel?.textAlignment = .center
        btn.isHidden = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false) // Hiding the Back button.
        view.backgroundColor = UIColor.systemGreen // Setting Background Color for the View.
        
        view.addSubview(showImageView) // Adding ImageView (ShowImageView) inside the View.
        view.addSubview(uploadBtn) // Adding Upload Button inside the View.
        
        // Adding Tap Gesture on ImageView. (ShowImageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageViewTappedHandle))
        showImageView.addGestureRecognizer(tapGesture)
        
        // Setting up Action on UploadButton
        uploadBtn.addTarget(self, action: #selector(uploadBtnHandle), for: .touchUpInside)
        
        // Setting Up SignOutBtn as the Right Bar Button in Navigation Bar.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .done, target: self, action: #selector(signOutHandle))
        
        settingConstraints() // Setting Constraints
    }
    
    @objc func signOutHandle() {
        signOutActionSheet()
    }
}

extension UploadImageViewController {
    
    // When ShowImageView is Tapped.
    @objc func ImageViewTappedHandle() {
        print("Image View is Pressed!")
        settingSelectingImageActionSheet()
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
        
        uploadBtn.topAnchor.constraint(equalTo: showImageView.bottomAnchor, constant: 50).isActive = true
        uploadBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        uploadBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        uploadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
}

extension UploadImageViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private func settingImagePicker(sourceType: UIImagePickerController.SourceType) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        // Checking if the Source Type is Avialable in this Device.
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            // If True.
            pickerController.sourceType = sourceType
            
        } else {
            // If False.
    
            self.dismiss(animated: true, completion: nil) // Dissmissing the Controller.
            
            // if PhotoLibrary or Camera is not avaiable in the Device then Show Error with an Alert Message.
            showErrorAlert(title: "Feature not Available", message: "Sorry, This feature is not available on this Device. Try using a different device which has a working Camera.", showSettings: false)
        }
        
        DispatchQueue.main.async {
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    // When user Selected any Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage { // If allows Editing is True
            print("Edited Image is Selected.")
            showImageView.image = image
            uploadBtn.isHidden = false
        } else if let image = info[.originalImage] as? UIImage { // If allows Editing is False
            print("Original Image is Selected.")
            showImageView.image = image
            uploadBtn.isHidden = false
        }
        // Dismissing the ViewController when the image is selected.
        dismiss(animated: true, completion: nil)
    }
}

extension UploadImageViewController {
    
    // When Signout button is pressed on Navigation bar.
    private func signOutActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            print("Sign Out Successful")
            print("Action =", action)
            
            // Signing Out from Firebase and Google
            do {
                try Auth.auth().signOut() // Siging Out From Firebase
                GIDSignIn.sharedInstance().signOut() // Signing Out from Google
                self.navigationController?.popToRootViewController(animated: true) // Navigation Back to RootViewController
                print("Sign Out Successful")
            } catch {
                print("Error Signing Out -", error.localizedDescription)
            }
        }
        
        // Cancel Action to dimiss the Action Sheet.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(signOutAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func settingSelectingImageActionSheet() {
    
        // Creating a Controller as an Action Sheet.
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Creating Actions that we wanna show on the Alert Controller
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            // Photo Library is Slected
            self.settingImagePicker(sourceType: .photoLibrary)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            // Camera is Selected
            self.checkAutherization()
            self.settingImagePicker(sourceType: .camera)
        }
        
        let removePhotoAction = UIAlertAction(title: "Remove Photo", style: .destructive) { (action) in
            // Removes the Already Selected Image in the ShowImageView.
            self.uploadBtn.isHidden = true
            self.showImageView.image = UIImage(named: "placeholderImage.jpg")
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // Cancels the ActionSheet
            self.dismiss(animated: true, completion: nil)
        }
        
        // Adding Actions to the Controller
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(removePhotoAction)
        alertController.addAction(cancelAction)
        
        // Presenting the Controller.
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // Check for Autherizations to use Camera in this App.
    private func checkAutherization() {

        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            // Autherized Successfully.
            settingImagePicker(sourceType: .camera)
        case .denied:
            // Denied. Show Error and also Directions to Autherize it in Settings with an Alert Message.
            showErrorAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.", showSettings: true)
            
        case .notDetermined:
            //User has not yet asked to give permissions to use Camera.
            settingImagePicker(sourceType: .camera)
            
        case .restricted:
            // User is restricted to access camera buy the Owner of the Device. Showing an Alert Message.
            showErrorAlert(title: "Restricted", message: "Device owner must approve to use Camera on this Device.", showSettings: false)
        default:
            print("Default.")
        }
    }
    
    // Alert Controller to Show Error or Important Message on Screen.
    private func showErrorAlert(title: String, message: String, showSettings: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Okay Action to Cancel the AlertBox
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        // To open Settings if the User has denied the permissions.
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {return}
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, completionHandler: { (success) in
                    print("Settings opened:", success)
                })
            }
        }
        
        alertController.addAction(okayAction)
        
        if showSettings { // Only when User Denied Permissions.
            alertController.addAction(settingsAction)
        }
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension UploadImageViewController {
    
    @objc func uploadBtnHandle() {
        if showImageView.image == UIImage(named: "placeholderImage.jpg") { // If user has NOT Selected any Image.
            print("Please Select Image to Upload.")
        } else { // If user has Selected an Image.
            print("Image is Uploading.")
        }
    }
    
}
