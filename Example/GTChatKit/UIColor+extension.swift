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
    
    static var myChat: UIColor {
        return UIColor(red: 20/255, green: 111/255, blue: 249/255, alpha: 1.0)
    }
    
    static var frameColor: UIColor {
        return UIColor(red: 226/255, green: 253/255, blue: 255/255, alpha: 1.0)
    }
    
    static var navigationBarColor: UIColor {
        return UIColor(red: 0/255, green: 214/255, blue: 238/255, alpha: 1.0)
    }
    
    static var otherChat: UIColor {
        return UIColor(red: 14/255, green: 169/255, blue: 245/255, alpha: 1.0)
    }
    

}
