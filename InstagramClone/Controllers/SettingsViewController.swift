//
//  SettingsViewController.swift
//  InstagramClone
//
//  Created by Arman Abkar on 5/8/21.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userPostsCount: UILabel!

    var posts: [Post] = []
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = Auth.auth().currentUser
        userLabel.text = currentUser?.email
        
        getUserData()
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: K.authSegue, sender: nil)
        } catch let signOutError as NSError {
            UIAlertController.showAlert(message: signOutError.localizedDescription, from: self)
        }
    }
    
    func getUserData() {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection(K.Firestore.collectionName).order(by: K.Firestore.dateField, descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                UIAlertController.showAlert(message: error?.localizedDescription ?? K.error.title, from: self)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.posts.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        if let postedBy = document.get(K.Firestore.postedByField) as? String,
                           let postComment = document.get(K.Firestore.postCommentField) as? String,
                           let likes = document.get(K.Firestore.likesField) as? Int,
                           let imageUrl = document.get(K.Firestore.imageUrlField) as? String {
                            let newPost = Post(postedBy: postedBy, postComment: postComment, likes: likes, imageUrl: imageUrl, documentID: documentID)
                            self.posts.append(newPost)
                        }
                        
                        DispatchQueue.main.async {
                            let currentUserPosts = self.posts.filter { $0.postedBy ==  self.currentUser?.email}
                            self.userPostsCount.text = "\(currentUserPosts.count) Posts"
                        }
                    }
                    
                }
            }
        }
    }
    
}
