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
    static var gfriend: UIImage {
        let gfriends = ["eumji", "eunha", "sowon", "yelin", "yuju", "sinbi"]
        let randIndex = Int(arc4random_uniform(UInt32(gfriends.count)))
        return UIImage(named: gfriends[randIndex])!
    }
}
