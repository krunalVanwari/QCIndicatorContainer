//
//  AnimationHandler.swift
//  QCIndicatorExample
//
//  Created by Qurious Click on 03/05/22.
//

import UIKit

extension QCIndicatorContainer {
    
    internal func animateVu(view vu:UIView,hide:Bool,margins:UIEdgeInsets?=nil,completion:(() -> Void)?=nil) {
        
        switch animation {
        case .fade:
            performFadeAnimation(to: vu,hide: hide,completion: completion)
        case .zoom:
            performZoomAnimation(to: vu, hide: hide, completion: completion)
        case .slide:
            performSlideAnimation(to: vu, hide: hide,margins: margins!, completion: completion)
        }
    }
    
    private func performFadeAnimation(to vu:UIView,hide:Bool,completion:(() -> Void)?=nil) {
        
        vu.alpha = hide ? 1 : 0
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseInOut) {
            vu.alpha = hide ? 0 : 1
        } completion: { _ in
            completion?()
        }
        
    }
    
    private func performZoomAnimation(to vu:UIView,hide:Bool,completion:(() -> Void)?=nil) {
        
        let scale:CGFloat = hide ? 1.0 : 1.5
        
        vu.transform = CGAffineTransform(scaleX: scale, y: scale)
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: .curveEaseInOut) {
            vu.transform = hide ? CGAffineTransform(scaleX: 0.01, y: 0.01) : .identity
        } completion: { _ in
            completion?()
        }
        
    }
    
    private func performSlideAnimation(to vu:UIView,hide:Bool,margins:UIEdgeInsets,completion:(() -> Void)?=nil) {
                
        var x:CGFloat
        var y:CGFloat
        
        switch verticalPosition {
        case .top:
            x = 0.0
            y = -(vu.frame.height + margins.top)
        case .center:
            x = 0.0
            y = 0.0
        case .bottom:
            x = 0.0
            y = (vu.frame.height + margins.bottom)
        }
        
        switch horizontalPosition {
        case .left:
            x = -(vu.frame.width + margins.left)
            y = 0.0
        case .center:
            break
        case .right:
            x = (vu.frame.width + margins.right)
            y = 0.0
        }
        
        let affine:CGAffineTransform
        if horizontalPosition == .center && verticalPosition == .center {
            affine = CGAffineTransform(scaleX: 0.01, y: 0.01)
        } else {
            affine = CGAffineTransform(translationX: x, y: y)
        }
                
        vu.transform = hide ? .identity : affine

        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut) {
            vu.transform = hide ? affine : .identity
        } completion: { _ in
            completion?()
        }

    }
    
    
    
}
