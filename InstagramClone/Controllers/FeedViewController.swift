//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Arman Abkar on 5/8/21.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: K.colors.primaryColor)
        
        tableView.refreshControl = refreshControl
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        listener?.remove()
    }
    
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    
    func getDataFromFirestore() {
        let fireStoreDatabase = Firestore.firestore()
        listener = fireStoreDatabase.collection(K.Firestore.collectionName).order(by: K.Firestore.dateField, descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                UIAlertController.showAlert(message: error?.localizedDescription ?? K.error.title, from: self)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get(K.Firestore.postedByField) as? String {
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let postComment = document.get(K.Firestore.postCommentField) as? String {
                            self.userCommentArray.append(postComment)
                        }
                        
                        if let likes = document.get(K.Firestore.likesField) as? Int {
                            self.likeArray.append(likes)
                        }
                        
                        if let imageUrl = document.get(K.Firestore.imageUrlField) as? String {
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getDataFromFirestore()
    }
    
}
