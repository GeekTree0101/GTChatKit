//
//  ChatCellNode.swift
//  GTChatKit
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ChatCellNode: ASCellNode {
    typealias ATString = NSAttributedString
    typealias Node = ChatCellNode
    
    lazy var balloonNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.style.height = .init(unit: .points, value: 50.0)
        node.cornerRadius = 25.0
        node.style.maxWidth = .init(unit: .points,
                                    value: UIScreen.main.bounds.width / 2)
        node.backgroundColor = UIColor.rand()
        node.clipsToBounds = true
        return node
    }()
    
    lazy var contentNode: ASTextNode = {
        let node = ASTextNode()
        node.style.flexShrink = 1.0
        return node
    }()
    
    enum Position {
        case left
        case right
    }
    
    private let contentPosition: Position
    
    init(_ row: Int, pos: Position) {
        self.contentPosition = pos
        super.init()
        let attr = Node.contentAttributes
        self.contentNode.attributedText =
            ATString(string: "Index: \(row)",
                attributes: attr)
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentCenterLayout = ASCenterLayoutSpec(centeringOptions: .XY,
                                                     sizingOptions: [],
                                                     child: contentNode)
        
        let contentOverlayedBalloonLayout = ASOverlayLayoutSpec(child: balloonNode,
                                                                overlay: contentCenterLayout)
      
        let isLeft = self.contentPosition == .left
        let layoutInsets = UIEdgeInsetsMake(15.0,
                                            isLeft ? 15.0: .infinity,
                                            0.0,
                                            isLeft ? .infinity: 15.0)
        
        return ASInsetLayoutSpec(insets: layoutInsets,
                                 child: contentOverlayedBalloonLayout)
    }
}

extension ChatCellNode {
    
    static var contentAttributes: [NSAttributedStringKey: Any] {
        return [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15.0),
                NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
