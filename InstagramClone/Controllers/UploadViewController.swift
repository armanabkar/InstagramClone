//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by Arman Abkar on 5/8/21.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func chooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child(Constants.Firestore.storageFolderName)
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    UIAlertController.showAlert(message: error?.localizedDescription ?? "Error", from: self)
                } else {
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString

                            let db = Firestore.firestore()
                            
                            let firestorePost = [
                                Constants.Firestore.imageUrlField : imageUrl!,
                                Constants.Firestore.postedByField : Auth.auth().currentUser!.email!,
                                Constants.Firestore.postCommentField : self.commentText.text!,
                                Constants.Firestore.dateField : FieldValue.serverTimestamp(),
                                Constants.Firestore.likesField : 0 ] as [String : Any]
                            
                            db.collection(Constants.Firestore.collectionName).addDocument(data: firestorePost) { (error) in
                                if error != nil {
                                    UIAlertController.showAlert(message: error?.localizedDescription ?? "Error", from: self)
                                } else {
                                    self.imageView.image = UIImage(named: "camera.viewfinder")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            }
                            
                            self.commentText.text = ""
                            self.imageView.image = UIImage(systemName: "camera.viewfinder")
                            
                        }
                    }
                }
            }
        }
    }
    
}
