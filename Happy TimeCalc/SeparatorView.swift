//
//  SeparatorView.swift
//  Happy TimeCalc
//
//  Created by David Pai on 2020/5/2.
//  Copyright © 2020 Pai Bros. All rights reserved.
//

import UIKit

class SeparatorView: UIView {

    override func draw(_ rect: CGRect) {
        self.backgroundColor =  UIColor().withAlphaComponent(0.1)// .alpha = 0.2
        let path = UIBezierPath()
        
        if #available(iOS 13.0, *) {
            UIColor.label.set()
        } else {
            UIColor.systemGray.set()
        }
        
        path.move(to: CGPoint(x: 0, y: 10))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: 10))
        path.move(to: CGPoint(x: 0, y: 15))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: 15))
        path.stroke()
    }
}
