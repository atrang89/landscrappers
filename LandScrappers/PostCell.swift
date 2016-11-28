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
    
    var post: ExplorePosts!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: ExplorePosts, img: UIImage? = nil)
    {
        self.post = post
        self.companyLabel.text = post.title
        self.likesLabel.text = "\(post.likes)"
        
        //Download images here
        if img != nil
        {
            self.postImage.image = img
        }
        else
        {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
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
                
            }) //2mb
            
        }
    }
}
