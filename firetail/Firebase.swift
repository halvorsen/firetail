//
//  Firebase.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/5/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import Firebase

final class Firebase {
    static func persistSubscriber(_ isSubscriber: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
    Database.database().reference().child("users").child(uid).child("vultureSubscriber").setValue(isSubscriber)
    }
    static func persistDeprecatedSubscriber(_ isOldSubscriber: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("premium").setValue(isOldSubscriber)
    }
    
}
