//
//  NetworkManager.swift
//  FirebaseStorageApp
//
//  Created by Simran Singh Sandhu on 06/06/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class NetworkManager {
    
    // Uploading Image in Storage and Getting the URL to retreive it in Future.
    func uploadData(image: UIImage, onCompletion: @escaping ((_ url: URL?) -> ())) {
        
        let storage = Storage.storage()
        let imageName: String = UUID().uuidString // Unique Image name
        let storageRef = storage.reference().child("\(imageName).jpg") // Creating Storage Reference
        guard let imageData = image.jpegData(compressionQuality: 1) else {return}
        
        let metaData = StorageMetadata()
        
        storageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if error != nil {
                print("Error Saving Image with Error Code -", error?.localizedDescription)
                
                // Dismissing the Previuos ProgressHUD and Showing the Error messgae if Image Upload Failed.
                SVProgressHUD.dismiss()
                SVProgressHUD.show(withStatus: "Error Uploading Image")
            } else {
                
                // Showing the Success ProgressHUD with auto Dismissile.
                SVProgressHUD.showSuccess(withStatus: "Upload Completed!")
                SVProgressHUD.dismiss(withDelay: 0.85) // Dismiss Time is Seconds.
                
                storageRef.downloadURL { (url, error) in // Downloading the URL so we can retrive it in Future.
                    if url != nil {
                        // Success Downloading URL, Pass the URL String in UploadImageVC Class
                        onCompletion(url!)
                    } else {
                        print("Error Downloading URL of the Uploaded Image with Error Code -", error?.localizedDescription)
                    }
                }
            }
        }
    }
}
