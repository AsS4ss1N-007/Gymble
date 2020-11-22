//
//  Constants.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 22/11/20.
//

import UIKit
import Firebase

struct FirestoreReferenceManagement {
    static let db = Firestore.firestore()
    static let environment = "Users"
    static let root = db.collection(environment).document(environment)
    
}
