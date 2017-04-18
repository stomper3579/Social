//
//  PostCell.swift
//  Social
//
//  Created by Tyler Brady on 4/4/17.
//  Copyright © 2017 Tyler Brady. All rights reserved.
//

import UIKit
import Firebase


class PostCell: UITableViewCell {

    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    //let likesref = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
    var likesref: FIRDatabaseReference!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesref = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)

        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if (img != nil) {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            //let ref = FIRStorage.storage().reference(forUrl: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("TYLER unable to download")
                } else {
                    print("image downloaded from firebase storage")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            }
            else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesref.setValue(true)
            }
            else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesref.removeValue()
            }
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}






