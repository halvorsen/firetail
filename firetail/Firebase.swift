//
//  Firebase.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/5/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import Firebase

final class Firebase {
    static func persistSubscriber(_ isSubscriber: Bool, expirationTimestamp: TimeInterval, originalTransactionID: String) {
        guard let user = Auth.auth().currentUser, var email = user.email else { return }
        email = email.replacingOccurrences(of: ".", with: ",")
        Database.database().reference().child("users").child(email).child("vultureSubscriber").setValue(isSubscriber)
        Database.database().reference().child("users").child(email).child("vultureExpiration").setValue(expirationTimestamp)
        Database.database().reference().child("users").child(email).child("originalTransactionID").setValue(originalTransactionID)
    }
    static func persistDeprecatedSubscriber(_ isOldSubscriber: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("premium").setValue(isOldSubscriber)
    }
    
}
