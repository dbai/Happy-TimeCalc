//
//  ViewController.swift
//  Happy TimeCalc
//
//  Created by David Pai on 2020/4/29.
//  Copyright © 2020 Pai Bros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var leftMarginWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dummyTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dummyBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var resultTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        leftMarginWidthConstraint.constant = scrollView.frame.width * 0.1
        
        label.center.y = scrollView.frame.height
//        print("scrollView.frame.height: \(scrollView.frame.height)")
//        print("label.frame.maxY: \(label.frame.maxY)")
        
//        print("dummyTopConstraint.constant: \(dummyTopConstraint.constant)")
        if label.frame.maxY > scrollView.frame.height {
            dummyBottomContraint.constant = label.frame.maxY - dummyTopConstraint.constant
        }
//        print("dummyBottomContraint.constant: \(dummyBottomContraint.constant)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    /*func getSafeAreaHeight() -> CGFloat {
        let verticalSafeAreaInset: CGFloat
        if #available(iOS 11.0, *) {
            verticalSafeAreaInset = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
            print("self.view.safeAreaInsets.bottom: \(self.view.safeAreaInsets.bottom),  self.view.safeAreaInsets.top: \(self.view.safeAreaInsets.top)")
        } else {
            verticalSafeAreaInset = 0.0
        }
        let safeAreaHeight = self.view.frame.height - verticalSafeAreaInset

        return safeAreaHeight
    }*/
}

