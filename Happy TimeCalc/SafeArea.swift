//
//  SafeArea.swift
//  Happy TimeCalc
//
//  Created by David Pai on 2020/5/1.
//  Copyright © 2020 Pai Bros. All rights reserved.
//

import UIKit

class SafeArea: NSObject {
    private var safeArea: UIEdgeInsets
    var top: CGFloat
    var left: CGFloat
    var bottom: CGFloat
    var right: CGFloat
    
    required init(safeAreaInsets: UIEdgeInsets) {
        safeArea = safeAreaInsets
        top = safeArea.top
        left = safeArea.left
        bottom = safeArea.bottom
        right = safeAreaInsets.right
    }
}
