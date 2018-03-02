//
//  ChatIndicatorNode.swift
//  GTChatKit_Example
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import Foundation
import AsyncDisplayKit
import UIKit

class ChatLoadingIndicatorNode: ASCellNode {
    
    lazy var indicatorNode: ASDisplayNode = {
        let node = ASDisplayNode(viewBlock: {
            let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            view.hidesWhenStopped = true
            return view
        })
        return node
    }()
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.style.preferredSize = .init(width: UIScreen.main.bounds.width, height: 100.0)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASCenterLayoutSpec(centeringOptions: .XY,
                                  sizingOptions: [],
                                  child: indicatorNode)
    }
    
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
        guard let view = indicatorNode.view as? UIActivityIndicatorView else { return }
        view.startAnimating()
        view.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        })
    }
    
    override func didExitVisibleState() {
        super.didExitVisibleState()
        guard let view = indicatorNode.view as? UIActivityIndicatorView else { return }
        view.stopAnimating()
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform(scaleX: 0, y: 0)
        })
    }
}
