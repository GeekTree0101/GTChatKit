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
    
    func chatNode(_ chatNode: ASCollectionNode,
                  willBeginAppendBatchFetchWith context: ASBatchContext)
    func chatNode(_ chatNode: ASCollectionNode,
                  willBeginPrependBatchFetchWith context: ASBatchContext)
}

public protocol GTChatNodeDataSource: ASCollectionDataSource {
    
}

open class GTChatNodeController: ASViewController<ASDisplayNode> {
    public enum BatchFetchDirection: UInt {
        case append
        case prepend
        case none
    }
    
    public enum PaginationStatus {
        case initial
        case appending
        case prepending
        case some
        
        var isLoading: Bool {
            switch self {
            case .appending, .prepending:
                return true
            default:
                return false
            }
        }
    }
    
    open var leadingScreensForBatching: CGFloat {
        get {
            return self.chatNode.leadingScreensForBatching
        }
        set(newValue) {
            self.chatNode.leadingScreensForBatching = newValue
        }
    }
    
    // debug logging printer control property
    open var shouldPrintLog: Bool = true
    open let chatNode: ASCollectionNode
    
    // If you want force handling btchFetchingContext, set property as False
    open var isPagingStatusEnable: Bool = true
    open var pagingStatus: PaginationStatus = .initial
    open var hasNextPrependItem: Bool = true
    open var hasNextAppendItems: Bool = true
    open var keyboardVisibleHeight: CGFloat = 0.0
    
    fileprivate lazy var batchFetchingContext = ASBatchContext()
    
    convenience public init() {
        let layout = GTChatNodeFlowLayout()
        self.init(layout: layout)
    }
    
    required public init(layout: UICollectionViewFlowLayout) {
        chatNode = ASCollectionNode(frame: .zero,
                                    collectionViewLayout: layout)
        super.init(node: ASDisplayNode())
        self.node.automaticallyManagesSubnodes = true
        self.setupChatRangeTuningParameters()
        
        self.node.layoutSpecBlock = { (_, constrainedSize) -> ASLayoutSpec in
            return self.layoutSpecThatFits(constrainedSize, chatNode: self.chatNode)
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.chatNode.delegate = nil
        self.chatNode.dataSource = nil
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
    }
    
    // override
    open func setupChatRangeTuningParameters() {
        self.chatNode.setTuningParameters(ASRangeTuningParameters(leadingBufferScreenfuls: 1.5,
                                                              trailingBufferScreenfuls: 1.5),
                                      for: .full,
                                      rangeType: .display)
        self.chatNode.setTuningParameters(ASRangeTuningParameters(leadingBufferScreenfuls: 2,
                                                              trailingBufferScreenfuls: 2),
                                      for: .full,
                                      rangeType: .preload)
    }
    
    // override
    open func layoutSpecThatFits(_ constrainedSize: ASSizeRange,
                                 chatNode: ASCollectionNode) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: self.chatNode)
    }
    
    @objc private func keyboardWillAppear(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardVisibleHeight = keyboardRectangle.height
            self.node.setNeedsLayout()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.keyboardVisibleHeight = 0.0
        self.node.setNeedsLayout()
    }
}

// Update Pagination Status
extension GTChatNodeController {
    open func completeBatchFetching(_ complated: Bool, endDirection: BatchFetchDirection) {
        guard isPagingStatusEnable else {
            print("[CAUTION] PagingStaute Disabled!")
            return
        }
        
        switch endDirection {
        case .append:
            self.hasNextAppendItems = false
        case .prepend:
            self.hasNextPrependItem = false
        default:
            break
        }
        
        switch self.pagingStatus {
        case .appending, .prepending:
            self.pagingStatus = .some
        default: break
        }
        
        self.batchFetchingContext.completeBatchFetching(complated)
    }
}

// Batch Fetch Handling
extension GTChatNodeController: UIScrollViewDelegate {
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) { }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let chatDelegate = self.chatNode.delegate as? GTChatNodeDelegate, ASInterfaceStateIncludesVisible(self.interfaceState) else { return }
        self.chatNode.updateCurrentRange(with: .full)
        self.beginChatNodeBatch(scrollView, chatDelegate: chatDelegate)
    }
    
    private func beginChatNodeBatch(_ scrollView: UIScrollView,
                                    chatDelegate: GTChatNodeDelegate) {
        guard !self.pagingStatus.isLoading else { return }
        
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
            guard chatDelegate.shouldAppendBatchFetch(for: self.chatNode),
                self.hasNextAppendItems else {
                return
            }
            self.batchFetchingContext.beginBatchFetching()
            if shouldPrintLog {
                print("[DEBUG] GTChat:\(Date().timeIntervalSinceReferenceDate) beging append fetching")
            }
            
            if isPagingStatusEnable {
                self.pagingStatus = .appending
            }
            chatDelegate.chatNode(self.chatNode, willBeginAppendBatchFetchWith: self.batchFetchingContext)
        case .prepend:
            guard chatDelegate.shouldPrependBatchFetch(for: self.chatNode),
                self.hasNextPrependItem else {
                return
            }
            if shouldPrintLog {
                print("[DEBUG] GTChat:\(Date().timeIntervalSinceReferenceDate) beging prepend fetching")
            }
            self.batchFetchingContext.beginBatchFetching()
            
            if isPagingStatusEnable {
                self.pagingStatus = .prepending
            }
            chatDelegate.chatNode(self.chatNode, willBeginPrependBatchFetchWith: self.batchFetchingContext)
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
        let leadingScreens: CGFloat = self.chatNode.leadingScreensForBatching
        
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
