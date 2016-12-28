//
//  PostCell.swift
//  LandScrappers
//
//  Created by Andy Trang on 11/17/16.
//  Copyright © 2016 AlwaysOnAlpha. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likesImage: UIImageView!
    
    var post: ExplorePosts!
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Adding tap recognizer since storyboard doesn't instantiate properly in table
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likesImage.addGestureRecognizer(tap)
        likesImage.isUserInteractionEnabled = true
    }
    
    func configureCell(post: ExplorePosts, img: UIImage? = nil)
    {
        self.post = post
        
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        self.companyLabel.text = post.title
        self.likesLabel.text = "\(post.likes)"
        
        //If in cache, post image
        if img != nil
        {
            self.postImage.image = img
        }
        else
        {
            //Download images if not in cache
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in  //2mb
                if error != nil
                {
                    print("ANDREW: Unable to download image from Firebase storage")
                }
                else
                {
                    print("ANDREW: Image downloaded from Firebase storage and saving to cache")
                    if let imgData = data
                    {
                        if let img = UIImage(data: imgData)
                        {
                            self.postImage.image = img
                            ExploreTableVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
                
            })
        }
    }
    
    func likeTapped(sender: UITapGestureRecognizer)
    {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likesImage.image = UIImage(named: "ic_thumb_up")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
                self.likesLabel.text = "\(self.post.likes)"
            }
            else
            {
                self.likesImage.image = UIImage(named: "Circle")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
                self.likesLabel.text = "\(self.post.likes)"
            }
        })
    }
}
