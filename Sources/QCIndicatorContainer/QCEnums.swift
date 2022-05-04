//
//  QCEnums.swift
//  QCIndicatorExample
//
//  Created by Qurious Click on 03/05/22.
//

import UIKit

extension QCIndicatorContainer {
    
    /// position of view on x-axis
    public enum Horizontal {
        case left
        case center
        case right
    }
    /// position of view on y-axis
    public enum Vertical {
        case top
        case center
        case bottom
    }
    
    public enum Animation {
        case fade
        case zoom
        case slide
    }
}
