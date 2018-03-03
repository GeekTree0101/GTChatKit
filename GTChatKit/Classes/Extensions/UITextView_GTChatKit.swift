//
//  UITextView_GTChatKit.swift
//  GTChatKit
//
//  Created by Geektree0101 on 18/03/02.
//  Copyright © 2018 Geektree0101 All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    var numberOfLines: Int {
        guard !text.isEmpty else { return 1 }
        
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var index = 0
        var lines = 0
        
        while (index < numberOfGlyphs) {
            var lineRange = NSRange(location: NSNotFound, length: 0)
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            
            guard lineRange.location != NSNotFound else { break }
            index = NSMaxRange(lineRange)
            lines += 1
        }
        
        return lines
    }
}
