//
//  QCIndicatorSize.swift
//  Container test
//
//  Created by Qurious Click on 28/04/22.
//

import UIKit

extension QCIndicatorContainer {

    /// called first time for giving position
    internal func givePosition(to view:UIView,for size:CGSize,margins:UIEdgeInsets) {
        let screenBounds = UIScreen.main.bounds
        var point:CGPoint = .zero
        
        switch verticalPosition {
        case .top:
            point.y = margins.top
        case .center:
            point.y = screenBounds.midY - (size.height / 2)
        case .bottom:
            point.y = screenBounds.height - size.height - margins.bottom
        }
        
        switch horizontalPosition {
        case .left:
            point.x = margins.left
        case .center:
            point.x = screenBounds.midX - (size.width / 2)
        case .right:
            point.x = screenBounds.width - size.width - margins.right
        }
        
        view.frame = CGRect(origin: point, size: size)
        
    }
    
    /// called when the orientation is changed
    internal func changePosition(of view:UIView,for vc:UIViewController) {
        givePosition(to: view, for: view.bounds.size, margins: margins(vc))
    }
    
    /// givs center position of main screen
    internal func giveScreenCenter() -> CGPoint {
        return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
    }
    
    ///give edgeInsert of screen for screen margins
    internal func margins(_ vc:UIViewController) -> UIEdgeInsets {
        
        if padding != .zero {
            return padding
        }
        
        if !shouldUseMargins {
            return .zero
        }
        
        if #available(iOS 11.0, *) {
            return vc.view.safeAreaInsets
        } else {
            return UIEdgeInsets(top: vc.topLayoutGuide.length, left: 0.0, bottom: vc.bottomLayoutGuide.length, right: 0.0)
        }
    }
    
}
