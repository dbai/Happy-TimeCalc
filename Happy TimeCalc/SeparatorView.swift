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
//        self.backgroundColor =  UIColor.systemBackground.withAlphaComponent(0.0)//*/.alpha = 0.2
        let path = UIBezierPath()
//        path.stroke(with: .normal, alpha: 1.0)
//        path.lineWidth = 2
        
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
