# GTChatKit: iOS ChatKit built on Texture

[![CI Status](http://img.shields.io/travis/Geektree0101/GTChatKit.svg?style=flat)](https://travis-ci.org/GeekTree0101/GTChatKit)
[![Version](https://img.shields.io/cocoapods/v/GTChatKit.svg?style=flat)](http://cocoapods.org/pods/GTChatKit)
[![License](https://img.shields.io/cocoapods/l/GTChatKit.svg?style=flat)](http://cocoapods.org/pods/GTChatKit)
[![Platform](https://img.shields.io/cocoapods/p/GTChatKit.svg?style=flat)](http://cocoapods.org/pods/GTChatKit)

GTChatKit is build on Texture for easy building iOS Message Application. 
Also it support Bi-directional Paging CollectionView

Why? Texture
Texture is an iOS framework built on top of UIKit that keeps even the most complex user interfaces smooth and responsive. more information [Here](http://texturegroup.org/)

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

    func chatNode(_ cahtNode: ASCollectionNode, willBeginAppendBatchFetchWith context: ASBatchContext) {
        // Network Call Handling
        // If Network Call Completed then context should be completed
        // required example
        // eg) self.completeBatchFetching(true, endDirection: .none)
    }

    func chatNode(_ cahtNode: ASCollectionNode, willBeginPrependBatchFetchWith context: ASBatchContext) {
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
