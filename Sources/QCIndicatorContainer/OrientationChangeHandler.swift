//
//  OrientationChangeHandler.swift
//  Container test
//
//  Created by Qurious Click on 28/04/22.
//

import UIKit

extension QCIndicatorContainer {
    
    internal func observeOrientationChange() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    internal func removeOrientationObserver() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func orientationChanged() {
        switch UIDevice.current.orientation {
        case .portrait,.landscapeLeft,.landscapeRight:
            for (id,window) in tempWindows.enumerated() {
                for view in window.subviews {
                    if view.accessibilityLabel == viewID {
                        changePosition(of: view, for: vcRefrences[id])
                    }
                }
            }
        default:
            break
        }
    }
    
    
}
