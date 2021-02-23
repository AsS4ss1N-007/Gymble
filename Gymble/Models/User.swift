//
//  User.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 21/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import Foundation
struct User: Codable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let gender: String?
    let phoneNumber: String?
    let userProfileImage: String?
    
    init(dictionary: [String: Any]) {
        self.firstName = dictionary["FirstName"] as? String ?? ""
        self.lastName = dictionary["LastName"] as? String ?? ""
        self.email = dictionary["EmailAddress"] as? String ?? ""
        self.gender = dictionary["Gender"] as? String ?? ""
        self.phoneNumber = dictionary["PhoneNumber"] as? String ?? ""
        self.userProfileImage = dictionary["ProfileUrl"] as? String ?? ""
    }
}
