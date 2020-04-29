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
    @IBOutlet weak var dummyTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dummyBottomContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    override func viewDidAppear(_ animated: Bool) {
//        dummyBottomContraint.constant = 400
        
        print("UIView's frame.self: \(self.view.frame.self)")
        print("UIView's safeAreaInsets: \(self.view.safeAreaInsets)")
        print("UIScreen.main.bounds.maxY: \(UIScreen.main.bounds.maxY)")
        print("scrollView.frame.self: \(scrollView.frame.self)")
        print("contentView.frame.self: \(contentView.frame.self)")
//        print("scrollView.frame.height: \(scrollView.frame.height)")
//        print("self.view.frame.height: \(self.view.frame.height)")
//        print("Safe Area height: \(getSafeAreaHeight())")
//        print("self.view.safeAreaLayoutGuide.layoutFrame.height: \(self.view.safeAreaLayoutGuide.layoutFrame.height)")
        print("======")
                        
        label.center.y = 718//UIScreen.main.bounds.maxY
        
        print("scrollView.frame.self: \(scrollView.frame.self)")
        print("scrollView.frame.minY: \(scrollView.frame.minY)")
        print("scrollView.frame.maxY: \(scrollView.frame.maxY)")
        print("contentView.frame.self: \(contentView.frame.self)")
        print("label.frame.maxY: \(label.frame.maxY)")
        print("label.frame.midY: \(label.frame.midY)")
        print("label.frame.origin.y: \(label.frame.origin.y)")
        print("label.bounds.midY: \(label.bounds.midY)")
        print("label.bounds.origin.y: \(label.bounds.origin.y)")
        print("label.frame.self: \(label.frame.self)")
        
        let realBottomOfDummy = scrollView.frame.height - dummyTopConstraint.constant
        print("realBottomOfDummy: \(realBottomOfDummy)")
        print("Before modified dummyBottomContraint.constant: \(dummyBottomContraint.constant)")
        
        if label.frame.maxY > scrollView.frame.height {
            print("Longer!")
            dummyBottomContraint.constant = label.frame.maxY - dummyTopConstraint.constant
            print("After modified dummyBottomContraint.constant: \(dummyBottomContraint.constant)")
            
            viewDidLayoutSubviews()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("~~~~~~\ncontentView.frame.self: \(contentView.frame.self)")
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

