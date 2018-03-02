//
//  ViewController.swift
//  GTChatKit
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import AsyncDisplayKit
import GTChatKit

class ChatNodeController: GTChatNodeController {
    
    var items: [Int] = [50, 51, 52, 53, 54, 55, 56, 57, 58, 59]
    struct Const {
        static let moreItemCount: Int = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.node.delegate = self
        self.node.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.node.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ChatNodeController: GTChatNodeDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let item = self.items[indexPath.row]
        return ChatCellNode(item, pos: item % 2 == 0 ? .left: .right)
    }
}

extension ChatNodeController: GTChatNodeDelegate {
    
    func shouldAppendBatchFetch(for chatNode: ASCollectionNode) -> Bool {
        
        return true
    }
    
    func shouldPrependBatchFetch(for chatNode: ASCollectionNode) -> Bool {
        
        return true
    }
    
    func chatNode(_ cahtNode: ASCollectionNode, willBeginAppendBatchFetchWith context: ASBatchContext) {
        guard let lastId = self.items.last else {
            context.completeBatchFetching(true)
            return
        }
        
        let startId = lastId + 1
        let newItems: [Int] = Array(startId ..< startId + Const.moreItemCount)
        
        let appendIndexPaths: [IndexPath] = newItems.enumerated()
            .map { IndexPath(item: self.items.count + $0.offset, section: 0) }
        
        self.items = items + newItems
        
        self.node.performBatchUpdates({
            self.node.insertItems(at: appendIndexPaths)
        }, completion: { done in
            context.completeBatchFetching(done)
        })
    }
    
    func chatNode(_ cahtNode: ASCollectionNode, willBeginPrependBatchFetchWith context: ASBatchContext) {
        guard let firstId = self.items.first, firstId != 0 else {
            context.completeBatchFetching(true)
            return
        }
        
        let startId = firstId
        let newItems: [Int] = Array(max(0, startId - Const.moreItemCount) ..< startId)
        let prependIndexPaths: [IndexPath] = newItems.enumerated()
            .map { IndexPath(item: $0.offset, section: 0) }
        
        self.items = newItems + items
        
        self.node.performBatchUpdates({
            self.node.insertItems(at: prependIndexPaths)
        }, completion: { done in
            context.completeBatchFetching(done)
        })
    }
}


