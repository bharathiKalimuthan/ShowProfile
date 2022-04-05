//
//  UserDetails.swift
//  UserProfileFeed
//
//  Created by BHARATHI K on 04/04/22.
//  Copyright © 2022 BHARATHI K. All rights reserved.
//

import Foundation

struct UserProfile : Codable {
    
    var name : String
    var company : String
    var avatarUrl: String
    var followers: Int
    var location: String
    
}
