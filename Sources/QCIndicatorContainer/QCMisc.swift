//
//  QCMisc.swift
//  QCIndicatorExample
//
//  Created by Qurious Click on 03/05/22.
//

import UIKit

extension QCIndicatorContainer {

    internal func removeIndicator(at index:Int) {
        tempWindows.remove(at: index)
        accessNames.remove(at: index)
        vcRefrences.remove(at: index)
    }
}
