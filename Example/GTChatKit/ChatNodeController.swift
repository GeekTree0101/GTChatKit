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
        return 100
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return ChatCellNode(indexPath.row, pos: indexPath.row % 2 == 0 ? .left: .right)
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
        
        context.completeBatchFetching(true)
    }
    
    func chatNode(_ cahtNode: ASCollectionNode, willBeginPrependBatchFetchWith context: ASBatchContext) {
        
        context.completeBatchFetching(true)
    }
}


