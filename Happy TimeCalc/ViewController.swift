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
    
//    @IBOutlet weak var hrLabel: UILabel!
//    @IBOutlet weak var minLabel: UILabel!
//    @IBOutlet weak var secLabel: UILabel!
    
    @IBOutlet weak var hrResult: UILabel!
    @IBOutlet weak var minResult: UILabel!
    @IBOutlet weak var secResult: UILabel!
    
    @IBOutlet weak var keyboard: UIView!
    @IBOutlet weak var smallKeyboard: UIImageView!
    var keyboardPosition: CGPoint?
    
    var safeArea: SafeArea!
    var isSafeAreaChanged = false

    @IBOutlet weak var dummyTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dummyBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var resultTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addRowButton: UIButton!
    @IBOutlet weak var separatorView: SeparatorView!
    @IBOutlet weak var calculateButton: UIButton!
    
    var removeRowButtons = [UIButton]() // 刪列按鈕
    var operatorButtons = [UIButton]() // 時間列前的 + 和 - 按鈕
    var operators = [Bool]() // 每列選到的運算元，true for +, false for -
    var timeRows = [[UILabel]]()    
    var focusedLabel: UILabel?

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btnBackspace: UIButton!

    var timeLabelWidth: CGFloat = 54
    var timeLabelHeight: CGFloat = 34
    var firstRowOriginY: CGFloat = 15
    var rowSpacing: CGFloat = 75
    var focusedBackgroundColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1.0)
    var focusedBackgroundColorInDarkMode = UIColor(red: 130 / 255.0, green: 130 / 255.0, blue: 130 / 255.0, alpha: 1.0)
    var timeLabelBorderColor = UIColor.lightGray.cgColor
    var btnBorderColor = UIColor.blue.cgColor
        
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
        
        addRow(UIButton())
        focusedLabel = timeRows[0][0]
        timeRows[0][0].backgroundColor = getFocusedBackgroundColor()
        addRow(UIButton())
                        
        // For testing purpose only
//        addMultipleRows(numberOfRows: 6)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        print("In viewDidAppear, UIView's safeAreaInsets: \(self.view.safeAreaInsets)")
//        print("scrollView.frame.width: \(scrollView.frame.width)")
//        leftMarginWidthConstraint.constant = scrollView.frame.width * 0.1
        
        label.center.y = scrollView.frame.height
        
//        print("scrollView.frame.height: \(scrollView.frame.height)")
//        print("label.frame.maxY: \(label.frame.maxY)")
        
//        print("dummyTopConstraint.constant: \(dummyTopConstraint.constant)")
        
        if label.frame.maxY > scrollView.frame.height {
            dummyBottomContraint.constant = label.frame.maxY - dummyTopConstraint.constant
        }
        contentView.setNeedsLayout() // 不加這行好像也沒差
        
//        print("dummyBottomContraint.constant: \(dummyBottomContraint.constant)")
        
//        print("UIView's frame.self: \(self.view.frame.self)")
//        print("UIScreen.main.bounds: \(UIScreen.main.bounds)")
//        print("UIView's safeAreaInsets: \(self.view.safeAreaInsets)")
//        print("In viewDidAppear, scrollView.frame.self: \(scrollView.frame.self)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
                
        contentView.layoutIfNeeded()
        
        separatorView.frame.origin.x = hrResult.frame.minX - 5
        separatorView.frame.size.width = secResult.frame.maxX - separatorView.frame.origin.x + 5
        print("viewDidLayoutSubviews is called")
        
        print("isSafeAreaChanged: \(isSafeAreaChanged)")
        if isSafeAreaChanged {
            for i in 0...timeRows.count - 1 {
                timeRows[i][0].center.x = hrResult.center.x
                timeRows[i][1].center.x = minResult.center.x
                timeRows[i][2].center.x = secResult.center.x
            }
        }
        isSafeAreaChanged = false
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        safeArea = SafeArea(safeAreaInsets: self.view.safeAreaInsets)
//        print("safeArea's top: \(safeArea.top), left: \(safeArea.left), bottom: \(safeArea.bottom), right: \(safeArea.right)")
        
        isSafeAreaChanged = true
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
    
    @IBAction func addRow(_ sender: UIButton) {
        // 增加 + 和 - 按鈕
//        if timeRows.count != 0 {
//            let operatorRow: [UIButton] = [UIButton(type: .custom), UIButton(type: .custom)]
//
//            if (self.operatorButtons.count == 0) {
//                operatorRow[0].frame = CGRect(x: 0, y: 121, width: 25, height: 25) //+
//                operatorRow[0].center.x = minLabel.frame.minX
//                operatorRow[1].frame = CGRect(x: 0, y: 121, width: 25, height: 25) //-
//                operatorRow[1].center.x = minLabel.frame.maxX
//            }
//            else {
//                operatorRow[0].frame = CGRect(x: 0, y: self.operatorButtons[self.operatorButtons.count - 2].frame.origin.y + rowSpacing, width: 25, height: 25) //+
//                operatorRow[0].center.x = minLabel.frame.minX
//                operatorRow[1].frame = CGRect(x: 0, y: self.operatorButtons[self.operatorButtons.count - 1].frame.origin.y + rowSpacing, width: 25, height: 25) //-
//                operatorRow[1].center.x = minLabel.frame.maxX
//            }
//
//            // 加進 operatorButtons 陣列以及畫面上
//            for (i, button) in operatorRow.enumerated() {
//                button.setImage(UIImage(named: i == 0 ? "+" : "-"), for: .normal)
//                button.layer.borderWidth = i == 0 ? 1 : 0
//                button.layer.borderColor = btnBorderColor
//                button.tag = operatorButtons.count
//                button.addTarget(self, action: #selector(addOrSubstract(_:)), for: .touchUpInside)
//                operatorButtons.append(button)
//                contentView.addSubview(button)
//            }
//            operators.append(true)
//        }
        
        // 增加時間欄位列
        let lastRowY = timeRows.count == 0 ? firstRowOriginY : timeRows[self.timeRows.count - 1][2].frame.origin.y + rowSpacing
        let row: [UILabel] = [UILabel(), UILabel(), UILabel()]
        row[0].frame = CGRect(x: hrResult.frame.origin.x, y: lastRowY, width: timeLabelWidth, height: timeLabelHeight)
        row[0].center.x = hrResult.center.x
        row[1].frame = CGRect(x: minResult.frame.origin.x, y: lastRowY, width: timeLabelWidth, height: timeLabelHeight)
        row[1].center.x = minResult.center.x
        row[2].frame = CGRect(x: secResult.frame.origin.x, y: lastRowY, width: timeLabelWidth, height: timeLabelHeight)
        row[2].center.x = secResult.center.x
        
        // 加進 timeRows 陣列以及畫面上
        for (i, label) in row.enumerated() {
            if #available(iOS 13.0, *) {
                label.textColor = .label
            } else {
                label.textColor = .systemGray
            }
            label.text = "00"
            label.font = .systemFont(ofSize: 20)
            label.layer.borderWidth = 1
            label.layer.borderColor = timeLabelBorderColor
            label.textAlignment = .center
            label.tag = timeRows.count * 3 + i
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(focus(_:))))
            label.isUserInteractionEnabled = true
            contentView.addSubview(label)
        }
        timeRows.append(row)
        
        // 增加減列按鈕
//        if timeRows.count > 1 {
//            let removeButton = UIButton(type: .system)
//            removeButton.setTitle("⤴︎", for: .normal)
//            removeButton.setTitleColor(.systemBlue, for: .normal)
//            removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
//            removeButton.frame = CGRect(x: addRowButton.frame.origin.x, y: removeRowButtons.count == 0 ? 155 : self.removeRowButtons[self.removeRowButtons.count - 1].frame.origin.y + rowSpacing, width: addRowButton.frame.size.width, height: addRowButton.frame.size.height)
//            removeButton.tag = self.removeRowButtons.count
//            removeButton.addTarget(self, action: #selector(removeRow(_:)), for: .touchUpInside)
//            removeButton.addTarget(self, action: #selector(btnTouchedDown(_:)), for: .touchDown)
//            removeButton.addTarget(self, action: #selector(btnTouchedUp(btn:playSound:)), for: .touchCancel)
//            removeButton.addTarget(self, action: #selector(btnTouchedUp(btn:playSound:)), for: .touchDragOutside)
//            contentView.addSubview(removeButton)
//            self.removeRowButtons.append(removeButton)
//        }
//
//        // 調整結果列
        adjustSeparatorAndResultLabels(isAppend: true)
//        refeshRemoveButtons()
//
//        btnTouchedUp(btn: sender, playSound: true)
    }
    
    func adjustSeparatorAndResultLabels(isAppend: Bool) {
        print("separatorView.frame.origin.y: \(separatorView.frame.origin.y)")
        if timeRows.count >= 2 {
            if isAppend {
                separatorView.frame.origin.y += rowSpacing
                hrResult.frame.origin.y = separatorView.frame.origin.y + 45
                minResult.frame.origin.y = separatorView.frame.origin.y + 45
                secResult.frame.origin.y = separatorView.frame.origin.y + 45
            }
            else {
                separatorView.frame.origin.y -= rowSpacing
                hrResult.frame.origin.y = separatorView.frame.origin.y + 45
                minResult.frame.origin.y = separatorView.frame.origin.y + 45
                secResult.frame.origin.y = separatorView.frame.origin.y + 45
            }
        }
        
        // 調整計算與加列按鈕位置
        calculateButton.center.y = separatorView.center.y + 2
        
        print("Prepared to call viewDidLayoutSubviews")
//        viewDidLayoutSubviews()
        contentView.setNeedsLayout() // 不加這行好像也沒差
    }
    
    @objc func focus(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        
//        playSound(player: audioPlayer, soundOn: appDelegate.soundSetting)
        
        if label.tag != focusedLabel?.tag {
            for i in self.timeRows {
                for j in i {
                    if j.tag == label.tag {
                        if #available(iOS 13.0, *) {
                            self.focusedLabel?.backgroundColor = .systemBackground
                        } else {
                            self.focusedLabel?.backgroundColor = contentView.backgroundColor
                        }  // Change background color of the previous focused label to default
                        label.backgroundColor = getFocusedBackgroundColor()
                        self.focusedLabel = label
                    }
                }
            }
        }
        
        validate(number: focusedLabel!.text!)
    }
    
    func getFocusedBackgroundColor() -> UIColor {
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                return focusedBackgroundColorInDarkMode
            }
            else {
                return focusedBackgroundColor
            }
        } else {
            return focusedBackgroundColor
        }
    }
    
    func validate(number: String) {
        btn1.isEnabled = number.count < 3 ? true : false
        btn2.isEnabled = number.count < 3 ? true : false
        btn3.isEnabled = number.count < 3 ? true : false
        btn4.isEnabled = number.count < 3 ? true : false
        btn5.isEnabled = number.count < 3 ? true : false
        btn6.isEnabled = number.count < 3 ? true : false
        btn7.isEnabled = number.count < 3 ? true : false
        btn8.isEnabled = number.count < 3 ? true : false
        btn9.isEnabled = number.count < 3 ? true : false
        btn0.isEnabled = number.count < 3 ? true : false
    }
}
