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
    @IBOutlet weak var dummyTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dummyBottomContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    override func viewDidAppear(_ animated: Bool) {
//        dummyBottomContraint.constant = 400
        
        print("UIScreen.main.bounds.maxY: \(UIScreen.main.bounds.maxY)")
//        print("ScrollView's bottom: \(scrollView.frame.maxY)")
        print("scrollView.frame.height: \(scrollView.frame.height)")
        print("self.view.frame.height: \(self.view.frame.height)")
        print("Safe Area height: \(getSafeAreaHeight())")
        print("self.view.safeAreaLayoutGuide.layoutFrame.height: \(self.view.safeAreaLayoutGuide.layoutFrame.height)")
        
        label.center.y = 0//UIScreen.main.bounds.maxY
        print("label.bounds.midY: \(label.bounds.midY)")
        
        let realBottomOfDummy = scrollView.frame.height - dummyTopConstraint.constant
        print("dummyBottomContraint.constant: \(dummyBottomContraint.constant)")
        
        if dummyBottomContraint.constant >= realBottomOfDummy {
            dummyBottomContraint.constant = realBottomOfDummy
            print("Modified dummyBottomContraint.constant: \(dummyBottomContraint.constant)")
        }
    }

    func getSafeAreaHeight() -> CGFloat {
        let verticalSafeAreaInset: CGFloat
        if #available(iOS 11.0, *) {
            verticalSafeAreaInset = self.view.safeAreaInsets.bottom + self.view.safeAreaInsets.top
            print("self.view.safeAreaInsets.bottom: \(self.view.safeAreaInsets.bottom),  self.view.safeAreaInsets.top: \(self.view.safeAreaInsets.top)")
        } else {
            verticalSafeAreaInset = 0.0
            print("2")
        }
        let safeAreaHeight = self.view.frame.height - verticalSafeAreaInset
        
//        let safeAreaHeight = self.view.frame.height - self.topLayoutGuide.length - self.bottomLayoutGuide.length
        
//        let safeAreaHeight = self.view.safeAreaLayoutGuide.

        return safeAreaHeight
    }
    
}

