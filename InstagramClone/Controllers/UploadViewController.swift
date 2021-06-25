//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by Arman Abkar on 5/8/21.
//

import UIKit
import Firebase

class UploadViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
}

// MARK: - UIImagePickerController

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child(K.Firestore.storageFolderName)
        
        if let data = imageView.image?.resizeImage(400, opaque: false).jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    UIAlertController.showAlert(message: error?.localizedDescription ?? K.error.title, from: self)
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            let db = Firestore.firestore()
                            
                            let firestorePost = [
                                K.Firestore.imageUrlField : imageUrl!,
                                K.Firestore.postedByField : Auth.auth().currentUser!.email!,
                                K.Firestore.postCommentField : self.commentText.text!,
                                K.Firestore.dateField : FieldValue.serverTimestamp(),
                                K.Firestore.likesField : 0 ] as [String : Any]
                            
                            db.collection(K.Firestore.collectionName).addDocument(data: firestorePost) { (error) in
                                if error != nil {
                                    UIAlertController.showAlert(message: error?.localizedDescription ?? K.error.title, from: self)
                                } else {
                                    self.imageView.image = UIImage(systemName: K.icons.camera)
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            }
                            
                            self.commentText.text = ""
                            self.imageView.image = UIImage(systemName: K.icons.camera)
                        }
                    }
                }
            }
        }
    }
    
}
