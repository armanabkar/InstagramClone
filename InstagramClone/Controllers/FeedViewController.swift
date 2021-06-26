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
    
    var posts: [Post] = []
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
    
    override func viewWillAppear(_ animated: Bool) {
        getDataFromFirestore()
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
            self.tableView.endUpdates()
        }
    }
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! FeedCell
        cell.userEmailLabel.text = posts[indexPath.row].postedBy
        cell.likeLabel.text = String(posts[indexPath.row].likes)
        cell.commentLabel.text = posts[indexPath.row].postComment
        cell.userImageView.sd_setImage(with: URL(string: self.posts[indexPath.row].imageUrl))
        cell.documentIdLabel.text = posts[indexPath.row].documentID
        return cell
    }
    
    func getDataFromFirestore() {
        let fireStoreDatabase = Firestore.firestore()
        listener = fireStoreDatabase.collection(K.Firestore.collectionName).order(by: K.Firestore.dateField, descending: true).addSnapshotListener { (snapshot, error) in
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
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getDataFromFirestore()
    }
    
}
