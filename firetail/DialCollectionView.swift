//
//  DialCollectionView.swift
//  firetail
//
//  Created by Aaron Halvorsen on 7/8/18.
//  Copyright © 2018 Aaron Halvorsen. All rights reserved.
//

import UIKit

final class DialCollectionView: UICollectionView {
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, cellID: String) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.delegate = delegate
        self.dataSource = dataSource
        register(DialCell.self, forCellWithReuseIdentifier: cellID)
        showsHorizontalScrollIndicator = false
        isUserInteractionEnabled = true
        backgroundColor = CustomColor.background
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
