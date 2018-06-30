//
//  AlertCollectionView.swift
//  firetail
//
//  Created by Aaron Halvorsen on 6/29/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import UIKit

final class AlertCollectionView: UICollectionView {
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, cellID: String) {
        super.init(frame: frame, collectionViewLayout: layout)
       
        self.delegate = delegate
        self.dataSource = dataSource
        self.register(AlertCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.showsVerticalScrollIndicator = false
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func AlertStringList(urgent: Bool, email: Bool, sms: Bool, push: Bool, flash: Bool) -> String {
        var alerts = ""
        if urgent {
            alerts += "All"
        } else {
            if email {
                alerts += "Email"
            }
            if alerts != "" && alerts.last != " "  {
                alerts += ", "
            }
            if sms {
                alerts += "SMS"
            }
            if alerts != "" && alerts.last != " " {
                alerts += ", "
            }
            if push {
                alerts += "Push"
            }
            if alerts != "" && alerts.last != " " {
                alerts += ", "
            }
            
            if flash {
                alerts += "Flash"
            }
            if alerts != "" && alerts.last != " "  {
                alerts += ", "
            }
            
            if alerts.last == " "  {
                alerts.remove(at: alerts.index(before: alerts.endIndex))
                alerts.remove(at: alerts.index(before: alerts.endIndex))
            }
        }
        return alerts
    }
}
