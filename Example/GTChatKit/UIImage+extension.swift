//
//  UIImage+extension.swift
//  GTChatKit_Example
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static var randomURL: URL {
        let baseURL = "https://github.com/GeekTree0101/GTChatKit/blob/master/resources"
        let gfriends = ["eumji", "eunha", "sowon", "yelin", "yuju", "sinbi"]
        let randIndex = Int(arc4random_uniform(UInt32(gfriends.count)))
        
        return URL(string: baseURL + gfriends[randIndex] + ".jpg") ??
            URL(string: "https://avatars1.githubusercontent.com/u/19504988?s=460&v=4")!
    }
}
