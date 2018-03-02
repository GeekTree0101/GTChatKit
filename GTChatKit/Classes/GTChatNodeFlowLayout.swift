//
//  GTChatFlowLayout.swift
//  GTChatKit
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import Foundation
import AsyncDisplayKit

open class GTChatNodeFlowLayout: UICollectionViewFlowLayout {
    private var topVisibleItem =  Int.max
    private var bottomVisibleItem = -Int.max
    private var offset: CGFloat = 0.0
    private var visibleAttributes: [UICollectionViewLayoutAttributes]?
    private var isPrependingItems = false
    private var isAppendingItems = false
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        visibleAttributes = super.layoutAttributesForElements(in: rect)
        offset = 0.0
        isPrependingItems = false
        isAppendingItems = false
        return visibleAttributes
    }
    
    override open func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        guard let collectionView = self.collectionView else { return }
        guard let visibleAttributes = self.visibleAttributes else { return }
        
        bottomVisibleItem = -Int.max
        topVisibleItem = Int.max
        
        var containerHeight: CGFloat = collectionView.frame.size.height
        containerHeight -= collectionView.contentInset.top
        containerHeight -= collectionView.contentInset.bottom
        
        let container = CGRect(x: collectionView.contentOffset.x,
                               y: collectionView.contentOffset.y,
                               width: collectionView.frame.size.width,
                               height: containerHeight)
        
        for attributes in visibleAttributes {
            if attributes.frame.intersects(container) {
                let item = attributes.indexPath.item
                
                if item < topVisibleItem {
                    topVisibleItem = item
                }
                
                if item > bottomVisibleItem {
                    bottomVisibleItem = item
                }
            }
        }
        
        super.prepare(forCollectionViewUpdates: updateItems)
        
        var shouldPrependItems = false
        var shouldAppendItems = false
        
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .insert:
                guard let indexPathAfterUpdate = updateItem.indexPathAfterUpdate,
                    case let item = indexPathAfterUpdate.item else {
                    continue
                }
                
                if topVisibleItem + updateItems.count > item,
                    let newAttributes = self.layoutAttributesForItem(at: indexPathAfterUpdate) {
                    offset += newAttributes.size.height + self.minimumLineSpacing
                    shouldPrependItems = true
                } else if bottomVisibleItem <= item,
                    let newAttributes = self.layoutAttributesForItem(at: indexPathAfterUpdate) {
                    offset += newAttributes.size.height + self.minimumLineSpacing
                    shouldAppendItems = true
                    
                }
            case.delete:
                break
            default:
                break
            }
        }
        
        let collectionViewContentHeight = collectionView.contentSize.height
        var collectionViewFrameHeight = collectionView.frame.size.height
        collectionViewFrameHeight -= collectionView.contentInset.top
        collectionViewFrameHeight -= collectionView.contentInset.bottom
        
        guard shouldPrependItems || shouldAppendItems,
            collectionViewContentHeight + offset > collectionViewFrameHeight else {
                return
        }
        
        if shouldPrependItems {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            isPrependingItems = true
        } else if shouldAppendItems {
            isAppendingItems = true
        }
    }
    
    override open func finalizeCollectionViewUpdates() {
        guard let collectionView = self.collectionView else { return }
        
        if isPrependingItems {
            let newContentOffset = CGPoint(x: collectionView.contentOffset.x,
                                           y: collectionView.contentOffset.y + offset)
            collectionView.contentOffset = newContentOffset
            CATransaction.commit()
        } else if isAppendingItems {
            let newContentOffset = CGPoint(x: collectionView.contentOffset.x,
                                           y: collectionView.contentSize.height + offset - collectionView.frame.size.height + collectionView.contentInset.bottom)
            collectionView.setContentOffset(newContentOffset, animated: true)
        }
    }
}
