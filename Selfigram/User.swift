//
//  User.swift
//  Selfigram
//
//  Created by lighthouselabs on 2017-04-19.
//  Copyright © 2017 lighthouselabs. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    let username:String
    let profileImage:UIImage

    init(aUsername:String, aProfileImage:UIImage){
        username = aUsername
        profileImage = aProfileImage
    }
}
