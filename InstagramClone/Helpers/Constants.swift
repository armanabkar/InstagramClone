//
//  Constants.swift
//  InstagramClone
//
//  Created by Arman Abkar on 5/9/21.
//

import Foundation

struct Constants {
    static let appName = "Instagram Clone"
    static let cellIdentifier = "Cell"
    static let cellNibName = "MessageCell"
    static let feedSegue = "toFeedVC"
    static let authSegue = "toAuthController"
    
    struct Firestore {
        static let collectionName = "Posts"
        static let storageFolderName = "media"
        static let postedByField = "postedBy"
        static let imageUrlField = "imageUrl"
        static let postCommentField = "postComment"
        static let dateField = "date"
        static let likesField = "likes"
    }
}
