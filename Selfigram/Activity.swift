//
//  Activity.swift
//  Selfigram
//
//  Created by lighthouselabs on 2017-05-10.
//  Copyright © 2017 lighthouselabs. All rights reserved.
//

import Parse

class Activity:PFObject, PFSubclassing {
    
    @NSManaged var type:String
    @NSManaged var post:Post
    @NSManaged var user:PFUser
    
    static func parseClassName() -> String {
        return "Activity"
    }
    
    convenience init(type:String, post:Post, user:PFUser){
        self.init()
        self.type = type
        self.post = post
        self.user = user
    }
}
