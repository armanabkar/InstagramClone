//
//  FeedCell.swift
//  InstagramClone
//
//  Created by Arman Abkar on 5/9/21.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var userEmailLabel: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButtonLabel: UIButton!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!) {
            let likeStore = [K.Firestore.likesField : likeCount + 1] as [String : Any]
            
            fireStoreDatabase.collection(K.Firestore.collectionName).document(documentIdLabel.text!).setData(likeStore, merge: true)
            
            likeButtonLabel.isEnabled = false
            likeButtonLabel.setTitleColor(.lightGray, for: .normal)
        }
    }
    
}
