//
//  SelfieCell.swift
//  Selfigram
//
//  Created by lighthouselabs on 2017-04-26.
//  Copyright © 2017 lighthouselabs. All rights reserved.
//

import UIKit
import Parse

class SelfieCell: UITableViewCell {

    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var heartAnimationView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var post:Post? {
        // didSet is run when we set this variable in FeedViewController
        didSet{
            if let post = post {
                
                // I've added the below line to prevent flickering of images
                // This always resets the image to blank, waits for the image to download, and then sets it
                selfieImageView.image = nil
                
                let imageFile = post.image
                imageFile.getDataInBackground(block: {(data, error) -> Void in
                    if let data = data {
                        let image = UIImage(data: data)
                        self.selfieImageView.image = image
                    }
                })
                
                usernameLabel.text = post.user.username
                commentLabel.text = post.comment
                
                likeButton.isSelected = false
                
                let query = post.likes.query()
                query.findObjectsInBackground(block: { (users, error) -> Void in
                    
                    if let users = users as? [PFUser]{
                        for user in users {
                            // If we find that the current user's objectId in our collection
                            // of likes we set the likeButton to selected
                            // objectId is a great way to compare if two objects are equal
                        if user.objectId == PFUser.current()?.objectId {
                            self.likeButton.isSelected = true
                                
                            }
                        }
                    }
                })
            }
        }
    }

    @IBAction func likeButtonClicked(_ sender: UIButton) {
        
        // the ! symbol means NOT
        // We are therefore setting the button's selected state to
        // the opposite of what it was. This is a great way to toggle buttons
        //
        
        sender.isSelected = !sender.isSelected
        
        if let post = post,
            let user = PFUser.current() {
            
            if sender.isSelected {
                post.likes.add(user)
                
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("like from user successfully saved")
                        
                        let activity = Activity(type: "like", post: post, user: user)
                        activity.saveInBackground(block: { (success, error) -> Void in
                            print("activity successfully saved")
                        })
                        
                        }else{
                        print("error is \(error!)")
                    }
                })
                
            } else {
                
                post.likes.remove(user)
                post.saveInBackground(block: { (success, error) -> Void in
                    if success {
                        print("like from user successfully removed")
                        
                        if let activityQuery = Activity.query(){
                            activityQuery.whereKey("post", equalTo: post)
                            activityQuery.whereKey("user", equalTo: user)
                            activityQuery.whereKey("type", equalTo: "like")
                            activityQuery.findObjectsInBackground(block: { (activities, error) -> Void in
                                
                                if let activities = activities {
                                    for activity in activities {
                                        activity.deleteInBackground(block: { (success, error) -> Void in
                                            print("deleted activity")
                                            
                                        })
                                    }
                                }
                            })
                        }
                        
                    } else {
                        print("error is \(error)")
                    }
                })
            }
        }
    }
    
    func tapAnimation() {
        self.heartAnimationView.isHidden = false
        self.heartAnimationView.transform = CGAffineTransform(scaleX: 0, y: 0)
        //animation for 1 second, no delay
        UIView.animate(withDuration: 1.0, delay: 0, options: [], animations: { () -> Void in
            
            // during our animation change heartAnimationView to be 3X what it is on storyboard
            self.heartAnimationView.transform = CGAffineTransform(scaleX: 3, y: 3)
            
        }) { (success) -> Void in
            
            // when animation is complete set heartAnimationView to be hidden
            self.heartAnimationView.isHidden = true
        }
        likeButtonClicked(likeButton)
    }
    
}
