//
//  Extensions.swift
//  Container test
//
//  Created by Qurious Click on 28/04/22.
//

import UIKit

public extension UIEdgeInsets {
    init(value:CGFloat) {
        self.init()
        self.top = value
        self.bottom = value
        self.left = value
        self.right = value
    }
}
