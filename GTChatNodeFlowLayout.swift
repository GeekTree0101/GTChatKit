//
//  GTChatFlowLayout.swift
//  GTChatKit
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import Foundation
import AsyncDisplayKit



class GTChatNodeFlowLayout: UICollectionViewFlowLayout {
    
    required override init() {
        super.init()
        self.scrollDirection = .vertical
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        
    }
    
}
