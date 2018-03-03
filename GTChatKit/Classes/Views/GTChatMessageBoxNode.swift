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
    public typealias Node = GTChatMessageBoxNode
    public typealias ButtonGroupHandler = ([GTChatMessageButtonNode]) -> Void
    
    @objc lazy open var messageNode = GTChatMessageInputBoxNode()
    open var messageBoxInsets: UIEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
    fileprivate var leftButtonGroups: [GTChatMessageButtonNode] = []
    fileprivate var leftButtonGroupSpacing: CGFloat = 10.0
    
    fileprivate var rightButtonGroups: [GTChatMessageButtonNode] = []
    fileprivate var rightButtonGroupSpacing: CGFloat = 10.0
    
    fileprivate var minimumMessageBoxHeight: CGFloat = 50.0
    fileprivate var maximumVisibleMessageNumberOfLines: Int = 6
    
    override public init() {
        super.init()
        self.backgroundColor = .chatKitDefaultColor
        self.automaticallyManagesSubnodes = true
        self.messageNode.delegate = self
    }
    
    deinit {
        self.messageNode.delegate = nil
    }
    
    @discardableResult public func setupDefaultMessageBox() -> Node {
        let cameraButton = GTChatMessageButtonNode()
            .setChatButtonSize(.init(width: 24.0, height: 24.0))
            .setChatButtonImage(#imageLiteral(resourceName: "photo"), color: .white, for: .normal)
            .setChatButtonImage(#imageLiteral(resourceName: "photo"), color: UIColor.white.withAlphaComponent(0.5), for: .disabled)
        
        let sendButton = GTChatMessageButtonNode()
            .setChatButtonSize(.init(width: 24.0, height: 24.0))
            .setChatButtonImage(#imageLiteral(resourceName: "send"), color: .white, for: .normal)
            .setChatButtonImage(#imageLiteral(resourceName: "send"), color: UIColor.white.withAlphaComponent(0.5), for: .disabled)
        
        self.messageNode.setChatMessageContainerInsets(UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0))
        
        self.setChatLeftButtons([cameraButton], spacing: 10.0)
            .setChatRightButtons([sendButton], spacing: 10.0)
            .setChatMessageBoxHeight(50.0, maxiumNumberOfLine: 6, isRounded: true)
        return self
    }
    
    @discardableResult public func setChatMessageBoxHeight(_ minimumHeight: CGFloat,
                                                           maxiumNumberOfLine: Int,
                                                           isRounded: Bool) -> Node {
        self.style.height = .init(unit: .points, value: minimumHeight)
        self.minimumMessageBoxHeight = minimumHeight
        self.maximumVisibleMessageNumberOfLines = maxiumNumberOfLine
        
        guard isRounded else { return self }
        self.messageNode.clipsToBounds = true
        let messageNodeSize = self.messageNode.calculateSizeThatFits(UIScreen.main.bounds.size)
        self.messageNode.cornerRadius = messageNodeSize.height / 2
        return self
    }
    
    @discardableResult public func setChatLeftButtons(_ buttons: [GTChatMessageButtonNode],
                                                      spacing: CGFloat) -> Node {
        self.leftButtonGroupSpacing = spacing
        self.leftButtonGroups = buttons
        return self
    }
    
    @discardableResult public func setChatRightButtons(_ buttons: [GTChatMessageButtonNode],
                                                       spacing: CGFloat) -> Node {
        self.rightButtonGroupSpacing = spacing
        self.rightButtonGroups = buttons
        return self
    }
    
    public func dismissMessageInput() {
        self.messageNode.resignFirstResponder()
    }
    
    override public func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var messageBoxElements: [ASLayoutElement] = []
        
        if let leftButtonGroupLayout = self.leftButtonGroupLayoutSpec() {
            let leftButtonRelativeLayout = ASRelativeLayoutSpec(horizontalPosition: .end,
                                                                verticalPosition: .end,
                                                                sizingOption: [],
                                                                child: leftButtonGroupLayout)
            leftButtonRelativeLayout.style.spacingAfter = leftButtonGroupSpacing
            messageBoxElements.append(leftButtonRelativeLayout)
        }
        
        messageBoxElements.append(messageNode)
        
        if let rightButtonGroupLayout = self.rightButtonGroupLayoutSpec() {
            let rightButtonRelativeLayout = ASRelativeLayoutSpec(horizontalPosition: .end,
                                                                 verticalPosition: .end,
                                                                 sizingOption: [],
                                                                 child: rightButtonGroupLayout)
            rightButtonRelativeLayout.style.spacingBefore = rightButtonGroupSpacing
            messageBoxElements.append(rightButtonRelativeLayout)
        }
        
        let messageStackLayout = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 0.0,
                                                   justifyContent: .spaceBetween,
                                                   alignItems: .stretch,
                                                   children: messageBoxElements)
        
        return ASInsetLayoutSpec(insets: self.messageBoxInsets,
                                 child: messageStackLayout)
    }
    
    private func rightButtonGroupLayoutSpec() -> ASLayoutElement? {
        guard self.rightButtonGroups.count > 1 else {
            guard let rightButtonNode = self.rightButtonGroups.first else {
                return nil
            }
            return rightButtonNode
        }
        
        let stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: self.rightButtonGroupSpacing,
                                            justifyContent: .start,
                                            alignItems: .center,
                                            children: self.rightButtonGroups)
        return stackLayout
    }
    
    private func leftButtonGroupLayoutSpec() -> ASLayoutElement? {
        guard self.leftButtonGroups.count > 1 else {
            guard let leftButtonNode = self.leftButtonGroups.first else {
                return nil
            }
            return leftButtonNode
        }
        
        let stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: self.leftButtonGroupSpacing,
                                            justifyContent: .start,
                                            alignItems: .center,
                                            children: self.leftButtonGroups)
        return stackLayout
    }
}

extension GTChatMessageBoxNode: ASEditableTextNodeDelegate {
    public func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
        let placeholderIsVisible = editableTextNode.isDisplayingPlaceholder()
        let targetLeftButtons = self.leftButtonGroups.filter { $0.autoInActive }
        let targetRightButtons = self.rightButtonGroups.filter { $0.autoInActive }
        
        for button in targetLeftButtons {
            button.isEnabled = !placeholderIsVisible
        }
        
        for button in targetRightButtons {
            button.isEnabled = !placeholderIsVisible
        }
        
        let numberOflines = min(self.maximumVisibleMessageNumberOfLines,
                                editableTextNode.textView.numberOfLines)
        
        let fontSize = editableTextNode.textView.font?.pointSize ?? 0.0
        var calcultedHeight = CGFloat(max(0, numberOflines - 1)) * fontSize
        calcultedHeight += minimumMessageBoxHeight
        self.style.height = .init(unit: .points,
                                  value: calcultedHeight)
        self.setNeedsLayout()
    }
}
