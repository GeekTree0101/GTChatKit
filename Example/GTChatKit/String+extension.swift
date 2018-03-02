//
//  String+extension.swift
//  GTChatKit_Example
//
//  Created by Vingle on 2018. 3. 2..
//  Copyright © 2018년 CocoaPods. All rights reserved.
//

import Foundation

extension String {
    
    static var randomMessage: String {
        let list = ["Hello World",
                    "How are you today?",
                    "하하하하하하",
                    "I LOVE Texture",
                    "在Vingle招聘iOS开发者!",
                    "Vingle is hiring senior iOS developers"]
        let index = Int(arc4random_uniform(UInt32(list.count)))
        return list[index]
    }
    
    static var gfriend: String {
        let gfriends = ["eumji", "eunha", "sowon", "yelin", "yuju", "sinbi"]
        let randIndex = Int(arc4random_uniform(UInt32(gfriends.count)))
        return gfriends[randIndex]
    }
}
