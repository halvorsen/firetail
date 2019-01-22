//
//  Database.swift
//  firetail
//
//  Created by Aaron Halvorsen on 1/21/19.
//  Copyright © 2019 Aaron Halvorsen. All rights reserved.
//

import Foundation
import Firebase

final class Database {
    
    
    
    
}

/*
V2 of Database:
timestamp: Int,
firebaseuser: {
    uid: {
        email: String,
        firstName: String,
        lastName: String,
        email: String,
        phone: String,
        memberType: String,
        stockBroker: String,
        cryptoExchange: String,
        creationDate: String,
        alertData: {
            crypto2352092BTC:true,
            2352352234TSLA:false,
            .
            .
            .
        }
    },
    .
    .
    .
    nthUser: ...
},
firebasealert: {
    crypto23532453ETH: {
        data1 (timestamp?): Int,
        deleted: bool,
        notificationType: {
            flash: true,
            push: true,
            sms: true,
            email: true,
            urgent: false,
            intelligent: false
        }
        isGreaterThan: bool,
        price: Double,
        ticker: String,
        triggered: Bool
        owner: StringUID
    }
    .
    .
    .
    nthAlert: ...
}
*/
