//
//  UIColor+extension.swift
//  GTChatKit_Example
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func rand() -> UIColor {
        let list: [UIColor] = [.red, .blue, .darkGray, .orange, .green]
        let index = Int(arc4random_uniform(UInt32(list.count)))
        
        return list[index]
    }
}
