//
//  OnTapAction.swift
//  QCIndicatorExample
//
//  Created by Qurious Click on 04/05/22.
//

import UIKit

extension QCIndicatorContainer:UIGestureRecognizerDelegate {
    
    internal func insertTapGesture(to vu:UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tap.delegate = self
        vu.addGestureRecognizer(tap)
    }
    
    @objc private func viewTapped(_ gesture:UITapGestureRecognizer) {
        onTapAction?()
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
