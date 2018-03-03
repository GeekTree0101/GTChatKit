//
//  GTChatMessageButtonNode.swift
//  GTChatKit
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import Foundation
import AsyncDisplayKit

public class GTChatMessageButtonNode: ASButtonNode {
    public typealias Node = GTChatMessageButtonNode
    
    open var buttonSize: CGSize = .init(width: 24, height: 24)
    open var buttonColor: UIColor = .white
    open var buttonTintColor: UIColor = .white
    
    // When message is placeholder then automatically inactive
    open var autoInActive: Bool = true
    
    override public init() {
        super.init()
        self.tintColor = self.buttonTintColor
        self.imageNode.contentMode = .scaleAspectFit
        self.style.flexGrow = 0.0
        self.style.flexShrink = 1.0
        self.style.preferredSize = self.buttonSize
    }
    
    @discardableResult open func setChatButtonImage(_ image: UIImage,
                                                    color: UIColor,
                                                    for status: UIControlState) -> Node {
        self.setImage(image.applyButtonColor(with: color), for: status)
        return self
    }
    
    @discardableResult open func setChatButtonSize(_ size: CGSize) -> Node {
        self.buttonSize = size
        self.style.preferredSize = size
        return self
    }
    
    @discardableResult @objc open func setChatButtonTintColor(_ color: UIColor) -> Node {
        self.buttonTintColor = color
        self.tintColor = color
        return self
    }
    
    @discardableResult open func setChatButtonText(_ title: NSAttributedString,
                                                   for state: UIControlState) -> Node {
        self.setAttributedTitle(title, for: state)
        return self
    }
}
