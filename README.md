# GTChatKit: iOS ChatKit built on Texture

[![CI Status](http://img.shields.io/travis/Geektree0101/GTChatKit.svg?style=flat)](https://travis-ci.org/GeekTree0101/GTChatKit)
[![Version](https://img.shields.io/cocoapods/v/GTChatKit.svg?style=flat)](http://cocoapods.org/pods/GTChatKit)
[![License](https://img.shields.io/cocoapods/l/GTChatKit.svg?style=flat)](http://cocoapods.org/pods/GTChatKit)
[![Platform](https://img.shields.io/cocoapods/p/GTChatKit.svg?style=flat)](http://cocoapods.org/pods/GTChatKit)

GTChatKit is build on Texture for easy building iOS Message Application. 
Also it support Bi-directional Paging CollectionView

Why? Texture
Texture is an iOS framework built on top of UIKit that keeps even the most complex user interfaces smooth and responsive. more information [Here](http://texturegroup.org/)


<table>
  <tr>
    <td align="center">Appending</td>
    <td align="center">Prepending</td>
  </tr>
  <tr>
    <th rowspan="9"><img src="https://github.com/GeekTree0101/GTChatKit/blob/master/resource/append.gif"></th>
    <th rowspan="9"><img src="https://github.com/GeekTree0101/GTChatKit/blob/master/resource/prepend.gif"></th>
  </tr>
  <tr>
</table>

## Usage
[example source](https://github.com/GeekTree0101/GTChatKit/tree/master/Example)

### 1. Create GTChatNodeController subclass

``` swift
class ChatNodeController: GTChatNodeController { ... }
```
> and you can create subclass instance 
``` swift
let viewController = ChatNodeController()
```
> if you want custom collection flow layout follow it
``` swift
let customFlowLayout = YOURCUSTOMCollectionFlowLayout()
let viewController = GTChatNodeController(layout: customFlowLayout)
```

> you can access chatNode and node(backgroundNode)
``` swift
class ChatNodeController: GTChatNodeController {

    ...

    func foo() {

        let collectionView = self.chatNode // chatNode is equal to UICollectionView
        let backgroundView = self.node // self.node is equal to backgroundView(UIView)
    }

}
```

### 2. GTChatNodeDelegate implementation
```swift
extension ChatNodeController: GTChatNodeDelegate {
    func shouldAppendBatchFetch(for chatNode: ASCollectionNode) -> Bool {
        // Should Append Batch Fetch
        return true
    }
    
    func shouldPrependBatchFetch(for chatNode: ASCollectionNode) -> Bool {
        // Should Prepend Batch Fetch
        return true
    }

    func chatNode(_ chatNode: ASCollectionNode, willBeginAppendBatchFetchWith context: ASBatchContext) {
        // Network Call Handling
        // If Network Call Completed then context should be completed
        // required example
        // eg) self.completeBatchFetching(true, endDirection: .none)
    }

    func chatNode(_ chatNode: ASCollectionNode, willBeginPrependBatchFetchWith context: ASBatchContext) {
        ...
    }
}
```

### 3. completeBatchFetching

``` swift
    func completeBatchFetching(_ complated: Bool, endDirection: BatchFetchDirection) { ... }

    endDirection: automatically block append or prepend batch fetching
    self.completeBatchFetching(true, endDirection: .append) -> no more append doesn't work
    self.completeBatchFetching(true, endDirection: .prepend) -> no more prepend doesn't work
```

### 4. pagingStatus property

you can see 4 steps paging status
1. initial
2. appending
3. prepending
4. some

(2), (3) is Loading status
(4: some) is means networking is finished and got new items
you do not need to be aware of (1: initial status) existence

### 5. If you need attach message input node then override layoutSpecThatFits method on subclass

> Also, when keyboard is activated, you can get keyboard height from keyboardVisibleHeight property
``` swift
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange, chatNode: ASCollectionNode) -> ASLayoutSpec {
        let messageInsets: UIEdgeInsets = .init(top: .infinity,
                                                left: 0.0,
                                                bottom: self.keyboardVisibleHeight,
                                                right: 0.0)

        let messageLayout = ASInsetLayoutSpec(insets: messageInsets,
                                              child: self.messageNode)

        // overlay message input box onto chatNode
        let messageOverlayedLayout = ASOverlayLayoutSpec(child: chatNode,
                                                         overlay: messageLayout)

        return ASInsetLayoutSpec(insets: .zero, child: messageOverlayedLayout)
    }
```

### 6. overriding setupChatRangeTuningParameters method
> If you deal with the tuning parameters for range type on your scrolling node 
> More Information [Here](http://texturegroup.org/docs/intelligent-preloading.html)

``` swift
    // default
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
```

## Requirements
- Xcode <~ 9.0
- iOS <~ 9.x
- Swift <~ 3.x, 4.0

## Installation

GTChatKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GTChatKit'
```

## Author

Geektree0101, h2s1880@gmail.com

## License

GTChatKit is available under the MIT license. See the LICENSE file for more info.
