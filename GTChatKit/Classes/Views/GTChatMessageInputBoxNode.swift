//
//  GTChatMessageInputBoxNode.swift
//  GTChatKit
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import Foundation
import AsyncDisplayKit

public class GTChatMessageInputBoxNode: ASEditableTextNode {
    public typealias Node = GTChatMessageInputBoxNode
    
    public override init() {
        super.init(textKitComponents: ASTextKitComponents(attributedSeedString: nil,
                                                          textContainerSize: .zero),
                   placeholderTextKitComponents: ASTextKitComponents(attributedSeedString: nil,
                                                                     textContainerSize: .zero))
        
        self.backgroundColor = .white
        self.placeholderEnabled = true
        self.setChatPlaceholder("Type Message",
                            attribute: Node.defaultPlaceholdereAttributes)
        self.setChatTypingAttributes(Node.defaultTypingAttributes)
        
        self.cursorColor(.chatKitDefaultColor)
        self.style.flexGrow = 1.0
        self.style.flexShrink = 1.0
    }
    
    deinit {
        self.delegate = nil
    }
    
    @discardableResult func setChatPlaceholder(_ text: String,
                                               attribute: [String: Any]) -> Node {
        self.attributedPlaceholderText = .init(string: text,
                                               attributes: attribute)
        return self
    }
    
    @discardableResult @objc func setChatTypingAttributes(_ attribute: [String: Any]) -> Node {
        self.typingAttributes = attribute
        return self
    }
    
    @discardableResult func setChatMessageContainerInsets(_ insets: UIEdgeInsets) -> Node {
        self.textContainerInset = insets
        return self
    }
    
    @discardableResult func cursorColor(_ color: UIColor) -> Node {
        self.tintColor = color
        return self
    }
    
    override public func didLoad() {
        super.didLoad()
        self.textView.showsVerticalScrollIndicator = false
        self.textView.showsHorizontalScrollIndicator = false
    }
}

extension GTChatMessageInputBoxNode {
    static var defaultPlaceholdereAttributes: [String: Any] {
        return [NSForegroundColorAttributeName: UIColor.lightGray,
                NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)]
    }
    
    static var defaultTypingAttributes: [String: Any] {
        return [NSForegroundColorAttributeName: UIColor.darkGray,
                NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)]
    }
}
