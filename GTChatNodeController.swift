//
//  GTChatFlowLayout.swift
//  GTChatKit
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import Foundation
import AsyncDisplayKit

public protocol GTChatNodeDelegate: ASCollectionDelegate {
    
    func shouldAppendBatchFetch(for chatNode: ASCollectionNode) -> Bool
    func shouldPrependBatchFetch(for chatNode: ASCollectionNode) -> Bool
    
    func chatNode(_ cahtNode: ASCollectionNode,
                  willBeginAppendBatchFetchWith context: ASBatchContext)
    func chatNode(_ cahtNode: ASCollectionNode,
                  willBeginPrependBatchFetchWith context: ASBatchContext)
}

public protocol GTChatNodeDataSource: ASCollectionDataSource {
    
}

open class GTChatNodeController: ASViewController<ASCollectionNode> {
    
    enum BatchFetchDirection {
        case append
        case prepend
        case none
    }
    
    open var shouldPrintLog: Bool = true
    
    fileprivate lazy var batchFetchingContext = ASBatchContext()
    
    open var onPrependBatchFetch: (() -> Void)? = nil
    open var onAppendBatchFetch: (() -> Void)? = nil
    
    required public init(layout: UICollectionViewFlowLayout) {
        let collectionNode = ASCollectionNode(frame: .zero,
                                              collectionViewLayout: layout)
        super.init(node: collectionNode)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GTChatNodeController: UIScrollViewDelegate {
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let chatDelegate = self.node.delegate as? GTChatNodeDelegate, ASInterfaceStateIncludesVisible(self.interfaceState) else { return }
        self.node.updateCurrentRange(with: .full)
        
        if scrollView.isDragging, scrollView.isTracking {
            return
        }
        
        let scrollVelocity = scrollView.panGestureRecognizer.velocity(in: super.view)
        
        let scope = shouldFetchBatch(for: scrollView,
                                     offset: scrollView.contentOffset.y,
                                     scrollDirection: scrollDirection(scrollVelocity),
                                     velocity: scrollVelocity)
        
        switch scope {
        case .append:
            guard chatDelegate.shouldAppendBatchFetch(for: self.node) else {
                return
            }
            self.batchFetchingContext.beginBatchFetching()
            if shouldPrintLog {
                print("[DEBUG] GTChat:\(Date().timeIntervalSinceReferenceDate) beging append fetching")
            }
            chatDelegate.chatNode(self.node, willBeginAppendBatchFetchWith: self.batchFetchingContext)
        case .prepend:
            guard chatDelegate.shouldPrependBatchFetch(for: self.node) else {
                return
            }
            if shouldPrintLog {
                print("[DEBUG] GTChat:\(Date().timeIntervalSinceReferenceDate) beging prepend fetching")
            }
            self.batchFetchingContext.beginBatchFetching()
            chatDelegate.chatNode(self.node, willBeginPrependBatchFetchWith: self.batchFetchingContext)
        case .none:
            break
        }
    }
    
    private func scrollDirection(_ scrollVelocity: CGPoint) -> ASScrollDirection {
        if scrollVelocity.y < 0.0 {
            return .down
        } else if scrollVelocity.y > 0.0 {
            return .up
        } else {
            return ASScrollDirection(rawValue: 0)
        }
    }
    
    private func shouldFetchBatch(for scrollView: UIScrollView,
                                  offset: CGFloat,
                                  scrollDirection: ASScrollDirection,
                                  velocity: CGPoint) -> BatchFetchDirection {
        guard !self.batchFetchingContext.isFetching(), scrollView.window != nil else {
            return .none
        }
        
        let bounds: CGRect = scrollView.bounds
        let leadingScreens: CGFloat = self.node.leadingScreensForBatching
        
        guard leadingScreens > 0.0, !bounds.isEmpty else {
            return .none
        }
        
        let contentSize: CGSize = scrollView.contentSize
        let viewLength = bounds.size.height
        let contentLength = contentSize.height
        
        // has small content
        if contentLength < viewLength {
            switch scrollDirection {
            case .down: return .prepend
            case .up: return .append
            default: return .none
            }
        }
        
        let triggerDistance = viewLength * leadingScreens
        let remainingDistance = contentLength - viewLength - offset
        
        switch scrollDirection {
        case .down:
            return remainingDistance <= triggerDistance ? .append: .none
        case .up:
            return offset < triggerDistance ? .prepend: .none
        default:
            return .none
        }
    }
}
