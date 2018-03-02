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
    
    let gfriend = String.gfriend
    
    lazy var profileImageNode: ASNetworkImageNode = {
        let node = ASNetworkImageNode()
        node.image = UIImage(named: self.gfriend)
        node.style.preferredSize = .init(width: 50.0, height: 50.0)
        node.clipsToBounds = true
        node.borderColor = UIColor.otherChat.cgColor
        node.cornerRadius = 25.0
        node.borderWidth = 1.0
        return node
    }()
    
    lazy var usernameNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()
    
    lazy var balloonNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.style.height = .init(unit: .points, value: 50.0)
        node.cornerRadius = 25.0
        node.style.maxWidth = .init(unit: .points,
                                    value: UIScreen.main.bounds.width / 2)
        let isMyChat: Bool = self.contentPosition == .left
        node.backgroundColor = isMyChat ? .otherChat: .myChat
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
    
    init(_ pos: Position) {
        self.contentPosition = pos
        super.init()
        
        self.contentNode.attributedText =
            ATString(string: String.randomMessage,
                     attributes: Node.contentAttributes)
        
        self.usernameNode.attributedText =
            ATString(string: gfriend,
                     attributes: Node.usernameAttributes)
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
        
        if isLeft {
            let usernameWithProfileImageLayout = ASStackLayoutSpec(direction: .vertical,
                                                                   spacing: 5.0,
                                                                   justifyContent: .start,
                                                                   alignItems: .center,
                                                                   children: [profileImageNode,
                                                                              usernameNode])
            
            let profileAttachBalloonLayout = ASStackLayoutSpec(direction: .horizontal,
                                                               spacing: 10.0,
                                                               justifyContent: .start,
                                                               alignItems: .center,
                                                               children: [usernameWithProfileImageLayout, contentOverlayedBalloonLayout])
            
            return ASInsetLayoutSpec(insets: layoutInsets,
                                     child: profileAttachBalloonLayout)
            
        } else {
            return ASInsetLayoutSpec(insets: layoutInsets,
                                     child: contentOverlayedBalloonLayout)
        }
        
    }
}

extension ChatCellNode {
    static var usernameAttributes: [NSAttributedStringKey: Any] {
        return [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0),
                NSAttributedStringKey.foregroundColor: UIColor.darkGray]
    }
    
    static var contentAttributes: [NSAttributedStringKey: Any] {
        return [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15.0),
                NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
