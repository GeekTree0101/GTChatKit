//
//  GTChatMessageBoxNode.swift
//  GTChatKit
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import Foundation
import AsyncDisplayKit

public class GTChatMessageBoxNode: ASDisplayNode {
    
    lazy var messageInputBoxNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.tintColor = UIColor(red: 0/255, green: 214/255, blue: 238/255, alpha: 1.0)
        node.textContainerInset = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
        node.cornerRadius = 5.0
        node.clipsToBounds = true
        node.style.minHeight = .init(unit: .points, value: 30.0)
        node.style.flexGrow = 1.0
        node.style.flexShrink = 1.0
        node.backgroundColor = .white
        return node
    }()
    
    lazy var cameraButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(#imageLiteral(resourceName: "photo").applyNewColor(with: .white), for: .normal)
        node.tintColor = .white
        node.imageNode.contentMode = .scaleAspectFit
        node.style.flexGrow = 0.0
        node.style.flexShrink = 1.0
        node.style.preferredSize = .init(width: 24, height: 24)
        return node
    }()
    
    lazy var sendButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(#imageLiteral(resourceName: "send").applyNewColor(with: .white), for: .normal)
        node.tintColor = .white
        node.imageNode.contentMode = .scaleAspectFit
        node.style.flexGrow = 0.0
        node.style.flexShrink = 1.0
        node.style.preferredSize = .init(width: 24, height: 24)
        return node
    }()
    
    override public init() {
        super.init()
        self.backgroundColor = UIColor(red: 0/255, green: 214/255, blue: 238/255, alpha: 1.0)
        self.automaticallyManagesSubnodes = true
    }
    
    public func dismissMessageInput() {
        self.messageInputBoxNode.resignFirstResponder()
    }
    
    override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let messageElementLayout = ASStackLayoutSpec(direction: .horizontal,
                                                     spacing: 10.0,
                                                     justifyContent: .spaceBetween,
                                                     alignItems: .center,
                                                     children: [cameraButtonNode,
                                                                messageInputBoxNode,
                                                                sendButtonNode])
        
        return ASInsetLayoutSpec(insets: .init(top: 10,
                                               left: 10,
                                               bottom: 10,
                                               right: 10),
                                 child: messageElementLayout)
    }
}

extension UIImage {
    
    func applyNewColor(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
