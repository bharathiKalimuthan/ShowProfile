//
//  ErrorMessage.swift
//  UserProfileFeed
//
//  Created by BHARATHI K on 31/03/22.
//  Copyright © 2022 BHARATHI K. All rights reserved.
//

import Foundation

enum ErrorMessage: String, Error {
    
    case invalidData = "sorry something went wrong"
    case invalidResponse = "server error; Please try again..."
    
}
