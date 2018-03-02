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
    
    enum Section: Int {
        case prependIndicator
        case messages
        case appendIndicator
    }
    
    struct Const {
        static let maxiumRange: Int = 100
        static let minimumRange: Int = 0
        static let forceLoadDelay: TimeInterval = 2.0
        static let moreItemCount: Int = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.leadingScreensForBatching = 3.0
        self.node.delegate = self
        self.node.dataSource = self
        self.title = "Buddy Chat"
        self.node.backgroundColor = UIColor.frameColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.node.reloadData()
        self.node.reloadData(completion: { () in
            let center = self.items.count / 2
            self.node.scrollToItem(at: .init(item: center, section: Section.messages.rawValue),
                                   at: .centeredVertically, animated: false)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension ChatNodeController: GTChatNodeDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 3
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Section.prependIndicator.rawValue:
            return self.pagingStatus == .prepending ? 1: 0
        case Section.appendIndicator.rawValue:
            return self.pagingStatus == .appending ? 1: 0
        case Section.messages.rawValue:
            return self.items.count
        default: return 0
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        switch indexPath.section {
        case Section.appendIndicator.rawValue:
            return ChatLoadingIndicatorNode()
        case Section.messages.rawValue:
            let random = Int(arc4random_uniform(UInt32(items.count)))
            return ChatCellNode(random % 2 == 0 ? .left: .right)
        case Section.prependIndicator.rawValue:
            return ChatLoadingIndicatorNode()
        default: return ASCellNode()
        }
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
        guard let lastId = self.items.last, lastId < Const.maxiumRange else {
            self.completeBatchFetching(true, endDirection: .prepend)
            self.node.reloadSections(IndexSet(integer: Section.appendIndicator.rawValue))
            return
        }
        
        self.node.reloadSections(IndexSet(integer: Section.appendIndicator.rawValue))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Const.forceLoadDelay, execute: {

            
            let startId = lastId + 1
            let newItems: [Int] = Array(startId ..< min(Const.maxiumRange,
                                                        startId + Const.moreItemCount))
            
            let appendIndexPaths: [IndexPath] = newItems.enumerated()
                .map { IndexPath(item: self.items.count + $0.offset, section: Section.messages.rawValue) }
            
            self.items = self.items + newItems
            
            self.node.performBatchUpdates({
                self.node.insertItems(at: appendIndexPaths)
            }, completion: { done in
                self.completeBatchFetching(true, endDirection: .none)
                self.node.reloadSections(IndexSet(integer: Section.appendIndicator.rawValue))
            })
        })
    }
    
    func chatNode(_ cahtNode: ASCollectionNode, willBeginPrependBatchFetchWith context: ASBatchContext) {
        guard let firstId = self.items.first, firstId != Const.minimumRange else {
            self.completeBatchFetching(true, endDirection: .prepend)
            self.node.reloadSections(IndexSet(integer: Section.prependIndicator.rawValue))
            return
        }
        
        self.node.reloadSections(IndexSet(integer: Section.prependIndicator.rawValue))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Const.forceLoadDelay, execute: {
            
            let startId = firstId
            let newItems: [Int] = Array(max(Const.minimumRange, startId - Const.moreItemCount) ..< startId)
            let prependIndexPaths: [IndexPath] = newItems.enumerated()
                .map { IndexPath(item: $0.offset, section: Section.messages.rawValue) }
            
            self.items = newItems + self.items
            
            self.node.performBatch(animated: false, updates: {
                self.node.insertItems(at: prependIndexPaths)
            }, completion: { done in
                self.completeBatchFetching(true, endDirection: .none)
                self.node.reloadSections(IndexSet(integer: Section.prependIndicator.rawValue))
            })
        })
    }
}


