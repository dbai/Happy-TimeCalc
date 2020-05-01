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
    
    @IBOutlet weak var keyboard: UIView!
    @IBOutlet weak var smallKeyboard: UIImageView!
    var keyboardPosition: CGPoint?
    
    var safeArea: SafeArea!
    
    @IBOutlet weak var leftMarginWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var dummyTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dummyBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var resultTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let keyboardGesture = UILongPressGestureRecognizer(target: self, action: #selector(panKeyboard))
        keyboardGesture.minimumPressDuration = 0.2
        keyboardGesture.allowableMovement = CGFloat.infinity
        keyboard.addGestureRecognizer(keyboardGesture)
        keyboard.isUserInteractionEnabled = true
        view.bringSubviewToFront(keyboard)        
        smallKeyboard.isHidden = true
        
        // 記得鍵盤上一次移動的位置
        NotificationCenter.default.addObserver(self, selector: #selector(restoreKeyboardPosition), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        print("In viewDidAppear, UIView's safeAreaInsets: \(self.view.safeAreaInsets)")
//        print("scrollView.frame.width: \(scrollView.frame.width)")
        leftMarginWidthConstraint.constant = scrollView.frame.width * 0.1
        
        label.center.y = scrollView.frame.height
//        print("scrollView.frame.height: \(scrollView.frame.height)")
//        print("label.frame.maxY: \(label.frame.maxY)")
        
//        print("dummyTopConstraint.constant: \(dummyTopConstraint.constant)")
        if label.frame.maxY > scrollView.frame.height {
            dummyBottomContraint.constant = label.frame.maxY - dummyTopConstraint.constant
        }
//        print("dummyBottomContraint.constant: \(dummyBottomContraint.constant)")
        
//        print("UIView's frame.self: \(self.view.frame.self)")
//        print("UIScreen.main.bounds: \(UIScreen.main.bounds)")
//        print("UIView's safeAreaInsets: \(self.view.safeAreaInsets)")
//        print("scrollView.frame.self: \(scrollView.frame.self)")

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        safeArea = SafeArea(safeAreaInsets: self.view.safeAreaInsets)
//        print("safeArea's top: \(safeArea.top), left: \(safeArea.left), bottom: \(safeArea.bottom), right: \(safeArea.right)")
    }

    @objc func panKeyboard(recognizer: UILongPressGestureRecognizer) {
        let touchPoint = recognizer.location(in: self.view)

        switch recognizer.state {
        case .changed:
            UIView.animate(withDuration: 0.2, animations: {
                self.keyboard.alpha = 0
                self.smallKeyboard.center = touchPoint
                self.smallKeyboard.isHidden = false
            })
        
        case .ended:
            self.keyboard.center = touchPoint

            if keyboard.center.x - (keyboard.frame.width / 2) <= UIScreen.main.bounds.minX + safeArea.left {
                keyboard.center.x = UIScreen.main.bounds.minX + safeArea.left + (keyboard.frame.width / 2)
            }
            
            if keyboard.center.x + (keyboard.frame.width / 2) >= UIScreen.main.bounds.maxX - safeArea.right {
                keyboard.center.x = UIScreen.main.bounds.maxX - safeArea.right - (keyboard.frame.width / 2)
            }
            
            if keyboard.center.y - (keyboard.frame.height / 2) <= scrollView.frame.minY {
                keyboard.center.y = scrollView.frame.minY + (keyboard.frame.height / 2)
            }
            
            if keyboard.center.y + (keyboard.frame.height / 2) >= scrollView.frame.maxY {
                keyboard.center.y = scrollView.frame.maxY - (keyboard.frame.height / 2)
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.smallKeyboard.isHidden = true
                self.keyboard.alpha = 0.8
            })
            
            keyboardPosition = keyboard.center
            
        default: break
        }
    }
    
    @objc func restoreKeyboardPosition() {
        guard let pos = keyboardPosition else {
            return
        }
        
        keyboard.center = pos
    }
}

