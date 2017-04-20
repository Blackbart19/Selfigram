//
//  Post.swift
//  Selfigram
//
//  Created by lighthouselabs on 2017-04-19.
//  Copyright © 2017 lighthouselabs. All rights reserved.
//

import Foundation
import UIKit

class Post {
    let image:UIImage
    let user:User
    let comment:String
    
    init(image:UIImage, user:User, comment:String){
        self.image = image
        self.user = user
        self.comment = comment
    }
}
