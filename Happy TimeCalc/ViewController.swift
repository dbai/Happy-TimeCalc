//
//  ViewController.swift
//  Happy TimeCalc
//
//  Created by David Pai on 2020/4/29.
//  Copyright © 2020 Pai Bros. All rights reserved.
//

import UIKit
import AVFoundation

extension UIWindow {
    static var isPortrait: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isPortrait ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isPortrait
        }
    }
}

class ViewController: UIViewController {

    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var leftMargin: UIView!

    @IBOutlet weak var hrTotal: UILabel!
    @IBOutlet weak var minTotal: UILabel!
    @IBOutlet weak var secTotal: UILabel!
    
    @IBOutlet weak var keyboard: UIView!
    @IBOutlet weak var smallKeyboard: UIImageView!
    var keyboardPosition: [CGPoint?] = [nil, nil] // [position in Portrait mode, position in Landscape mode]
    
    var safeArea: SafeArea!

    @IBOutlet weak var totalTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalBottomConstraint: NSLayoutConstraint!
//    @IBOutlet weak var timeLabelAspectRatio: NSLayoutConstraint!
    
    @IBOutlet weak var addRowButton: UIButton!
    @IBOutlet weak var separatorView: SeparatorView!
    
    var removeRowButtons = [UIButton]() // 刪列按鈕
    var operatorButtons = [UIButton]() // 時間列前的 + 和 - 按鈕
    var operators = [Bool]() // 每列選到的運算元，true for +, false for -
    var timeRows = [[UILabel]]()    
    var focusedLabel: UILabel?

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

    var isAppIniting = true
    var shouldChangeLayout = false
    var shouldChangeStars = false
    var numberOfStarsInLastRound = 0
    var numberOfAnimationFinishedStars = 0
    
//    var timeLabelWidth: CGFloat = 54
//    var timeLabelHeight: CGFloat = 34
    var rowSpacing: CGFloat = 75
    var firstRowOriginY: CGFloat = 15
    var firstOpertorRowOriginY: CGFloat = 57
    var operatorButtonSideLength: CGFloat = 25
    var focusedBackgroundColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1.0)
    var focusedBackgroundColorInDarkMode = UIColor(red: 130 / 255.0, green: 130 / 255.0, blue: 130 / 255.0, alpha: 1.0)
    var timeLabelBorderColor = UIColor.lightGray.cgColor
    var btnBorderColor = UIColor.blue.cgColor

    var audioPlayer = AVAudioPlayer()
    var audioPlayer2 = AVAudioPlayer()
    
    let userDefault = UserDefaults()
    
    var stars = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 鍵盤
        let keyboardGesture = UILongPressGestureRecognizer(target: self, action: #selector(panKeyboard))
        keyboardGesture.minimumPressDuration = 0.2
        keyboardGesture.allowableMovement = CGFloat.infinity
        keyboard.addGestureRecognizer(keyboardGesture)
        keyboard.isUserInteractionEnabled = true
//        view.bringSubviewToFront(keyboard)
        smallKeyboard.isHidden = true
        
        // 記得鍵盤上一次移動的位置，以及重刷動畫
        NotificationCenter.default.addObserver(self, selector: #selector(restoreActions), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // iPad 的旋轉，不會改變 Safe Area，所以不能只靠呼叫 viewSafeAreaInsetsDidChange 來重繪畫面，必須要手動偵測旋轉及重繪
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        // 音效
        guard let _ = try? AVAudioSession.sharedInstance().setCategory(.ambient) else {
            print("Failed to set AVAudioSession catergory.")
            return
        }
        guard let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "/Sounds/click", ofType: "m4a")!)) else {
            print("Failed to initialize AVAudioPlayer for click sound.")
            return
        }
        guard let player2 = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "/Sounds/ding", ofType: "m4a")!)) else {
            print("Failed to initialize AVAudioPlayer for ding sound.")
            return
        }
        audioPlayer = player
        audioPlayer2 = player2
        audioPlayer.prepareToPlay()
        audioPlayer2.prepareToPlay()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
                        
        safeArea = SafeArea(safeAreaInsets: self.view.safeAreaInsets)
//        print("viewSafeAreaInsetsDidChange, safe area top: \(safeArea.top), left: \(safeArea.left), bottom: \(safeArea.bottom), right: \(safeArea.right)")
        
        shouldChangeLayout = true

        if isAppIniting {
            shouldChangeStars = false
            isAppIniting = false
        }
        else {
            shouldChangeStars = true
        }
    }
    
    @objc func deviceDidRotated() {
        shouldChangeLayout = true
        shouldChangeStars = true
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print("viewDidLayoutSubviews")

        contentView.layoutIfNeeded()
                        
//        separatorView.frame.origin.x = hrTotal.frame.minX - 5
//        separatorView.frame.size.width = secTotal.frame.maxX - separatorView.frame.origin.x + 5

//        if hrTotal.frame.maxY <= scrollView.frame.height {
//            totalBottomConstraint.constant = scrollView.frame.height - totalTopConstraint.constant - hrTotal.frame.height
//        }
//        else {
//            totalBottomConstraint.constant = 0
//        }
        
        if shouldChangeLayout {
            separatorView.frame.origin.x = hrTotal.frame.minX - 5
            separatorView.frame.size.width = secTotal.frame.maxX - separatorView.frame.origin.x + 5
            
            if hrTotal.frame.maxY <= scrollView.frame.height {
                totalBottomConstraint.constant = scrollView.frame.height - totalTopConstraint.constant - hrTotal.frame.height
            }
            else {
                totalBottomConstraint.constant = 0
            }
            
            if (timeRows.count > 0) {
                for i in 0...timeRows.count - 1 {
                    timeRows[i][0].center.x = hrTotal.center.x
                    timeRows[i][1].center.x = minTotal.center.x
                    timeRows[i][2].center.x = secTotal.center.x
                }
            }
            
            if operatorButtons.count > 0 {
                for i in 0...operatorButtons.count - 1 {
                    if i % 2 == 0 {
                        operatorButtons[i].center.x = minTotal.frame.minX
                    }
                    else {
                        operatorButtons[i].center.x = minTotal.frame.maxX
                    }
                }
            }
            
            if removeRowButtons.count > 0 {
                for i in 0...removeRowButtons.count - 1 {
                    removeRowButtons[i].center.x = addRowButton.center.x
                    removeRowButtons[i].center.y = timeRows[i + 1][2].center.y
                }
            }
        }
        shouldChangeLayout = false
        
        if (shouldChangeStars) {
            shuffleStars()
        }
        shouldChangeStars = false
        
        // 下面這行目的是，避免每次有更動 Result 欄位（如按等於和清除鍵），鍵盤就會跳回初始位置
        guard let pos = UIWindow.isPortrait ? keyboardPosition[0] : keyboardPosition[1] else { return }
        keyboard.center = pos
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addRow(UIButton())
        focusedLabel = timeRows[0][0]
        timeRows[0][0].backgroundColor = getFocusedBackgroundColor()
        addRow(UIButton())

        // For testing purpose only
//        addMultipleRows(numberOfRows: 8)
        
        // 動畫
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.view.layoutIfNeeded()
        }

        // 星星
        shuffleStars()
        
//        print(timeLabelAspectRatio.multiplier)
    }
    
    func shuffleStars() {
        if sceneDelegate!.starCount == 0 {
            if stars.count != 0 { // 這條件發生在原本有星星，但設定上限為零後返回主畫面時
                let leftMarginIndex = view.subviews.firstIndex(of: leftMargin)
                for i in 0...leftMarginIndex! - 1 {
                    stars[i].removeFromSuperview()
                }
                stars = [UIImageView]()
            }
            return
        }

        if view.subviews[0] == leftMargin {
            let numberOfStars = Int.random(in: 1..<sceneDelegate!.starCount)
            numberOfStarsInLastRound = numberOfStars
            
            for _ in 0...numberOfStars - 1 {
                let star = UIImageView(image: UIImage(named: "Star"))
                let randomX = Int(Float.random(in: 0..<Float(view.frame.width)))
                let randomY = Int(Float.random(in: 0..<Float(view.frame.height)))
                star.frame.size = CGSize(width: 30, height: 30)
                star.center = CGPoint(x: randomX, y: randomY)
                star.alpha = CGFloat(Float.random(in: 0.1..<0.4))
                stars.append(star)
                view.insertSubview(star, at: 0)
            }
            animateStars()
        }
        else {
            let leftMarginIndex = view.subviews.firstIndex(of: leftMargin)
            for i in 0...leftMarginIndex! - 1 {
                stars[i].removeFromSuperview()
            }
            stars = [UIImageView]()
            DispatchQueue.global().async {
                while true {
//                    if self.numberOfAnimationFinishedStars == self.numberOfStarsInLastRound {
                    if self.numberOfAnimationFinishedStars != 0 {
                        DispatchQueue.main.sync {
                            self.shuffleStars()
                        }
                        break
                    }
                }
            }
        }
        print("Star count: ", stars.count)
    }
    
    func animateStars() {
        if stars.count == 0  {
            return
        }
        numberOfAnimationFinishedStars = 0
        let options: UIView.AnimationOptions = [.curveEaseInOut, .repeat, .autoreverse]
        for i in 0...stars.count - 1 {
            let randomDuration = Int.random(in: 2..<20)
            let randomDelay = Int.random(in: 2..<20)
        
            UIView.animate(withDuration: TimeInterval(randomDuration), delay: TimeInterval(randomDelay), options: options, animations: { [weak self] in
                self?.stars[i].alpha = 0.0
            }, completion: { _ in
                self.numberOfAnimationFinishedStars += 1
                print("in completion")
            })
        }
    }
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        focusedLabel?.backgroundColor = getFocusedBackgroundColor()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
       if motion == .motionShake {
            shouldChangeStars = true
            viewDidLayoutSubviews()
       }
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
            
            if (UIWindow.isPortrait) {
                keyboardPosition[0] = keyboard.center
            } else {
                keyboardPosition[1] = keyboard.center
            }
            
        default: break
        }
    }
    
    @objc func restoreActions() {
        guard let pos = UIWindow.isPortrait ? keyboardPosition[0] : keyboardPosition[1] else { return }
        keyboard.center = pos
        
        shuffleStars()
    }
    
    @IBAction func addRow(_ sender: UIButton) {
        // 若有元件的 x, y 設為 0，則之後會在 viewDidLayoutSubviews() 中動態決定實際的值
                
        // 增加 + 和 - 按鈕
        if timeRows.count != 0 {
            let operatorRow: [UIButton] = [UIButton(type: .custom), UIButton(type: .custom)]

            if (self.operatorButtons.count == 0) {
                operatorRow[0].frame = CGRect(x: 0, y: firstOpertorRowOriginY, width: operatorButtonSideLength, height: operatorButtonSideLength) //+
                operatorRow[1].frame = CGRect(x: 0, y: firstOpertorRowOriginY, width: operatorButtonSideLength, height: operatorButtonSideLength) //-
            }
            else {
                operatorRow[0].frame = CGRect(x: 0, y: self.operatorButtons[self.operatorButtons.count - 2].frame.origin.y + rowSpacing, width: operatorButtonSideLength, height: operatorButtonSideLength) //+
                operatorRow[0].center.x = minTotal.frame.minX
                operatorRow[1].frame = CGRect(x: 0, y: self.operatorButtons[self.operatorButtons.count - 1].frame.origin.y + rowSpacing, width: operatorButtonSideLength, height: operatorButtonSideLength) //-
                operatorRow[1].center.x = minTotal.frame.maxX
            }

            // 加進 operatorButtons 陣列以及畫面上
            for (i, button) in operatorRow.enumerated() {
                button.setImage(UIImage(named: i == 0 ? "+" : "-"), for: .normal)
                button.layer.borderWidth = i == 0 ? 1 : 0
                button.layer.borderColor = btnBorderColor
                button.tag = operatorButtons.count
                button.addTarget(self, action: #selector(addOrSubstract(_:)), for: .touchUpInside)
                operatorButtons.append(button)
                contentView.addSubview(button)
            }
            operators.append(true)
        }
        
        // 增加時間欄位列
        let lastRowY = timeRows.count == 0 ? firstRowOriginY : timeRows[self.timeRows.count - 1][2].frame.origin.y + rowSpacing
        let row: [UILabel] = [UILabel(), UILabel(), UILabel()]
        var timeLabelWidth = scrollView.frame.width * 0.144
        var timeLabelHeight = timeLabelWidth / 1.64//timeLabelAspectRatio.multiplier
        print("算完的欄位長寬：\(timeLabelWidth), \(timeLabelHeight)")
        row[0].frame = CGRect(x: 0, y: lastRowY, width: timeLabelWidth, height: timeLabelHeight)
        row[1].frame = CGRect(x: 0, y: lastRowY, width: timeLabelWidth, height: timeLabelHeight)
        row[2].frame = CGRect(x: 0, y: lastRowY, width: timeLabelWidth, height: timeLabelHeight)
        
        // 加進 timeRows 陣列以及畫面上
        for (i, label) in row.enumerated() {
            if #available(iOS 13.0, *) {
                label.textColor = .label
            } else {
                label.textColor = .systemGray
            }
            label.text = "00"
            label.font = .systemFont(ofSize: 30)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.45
            label.autoresizingMask = .flexibleWidth
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
        if timeRows.count > 1 {
            let removeButton = UIButton(type: .system)
            removeButton.setTitle("⤴︎", for: .normal)
            removeButton.setTitleColor(.systemBlue, for: .normal)
            removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            removeButton.frame = CGRect(x: 0, y: 0/*removeRowButtons.count == 0 ? 155 : self.removeRowButtons[self.removeRowButtons.count - 1].frame.origin.y + rowSpacing*/, width: addRowButton.frame.size.width, height: addRowButton.frame.size.height)
            removeButton.tag = self.removeRowButtons.count
            removeButton.addTarget(self, action: #selector(removeRow(_:)), for: .touchUpInside)
            removeButton.addTarget(self, action: #selector(btnTouchedDown(_:)), for: .touchDown)
            removeButton.addTarget(self, action: #selector(btnTouchedUp(btn:playSound:)), for: .touchCancel)
            removeButton.addTarget(self, action: #selector(btnTouchedUp(btn:playSound:)), for: .touchDragOutside)
            contentView.addSubview(removeButton)
            self.removeRowButtons.append(removeButton)
        }

        // 調整結果列
        adjustSeparatorAndResultLabels(isAppend: true)

        btnTouchedUp(btn: sender, playSound: true)
    }
    
    @objc func removeRow(_ sender: UIButton) {
        let n = sender.tag
        
        // 判斷欲刪之列是不是最後一列，如果不是，就要把刪除之列後面的列往上移
        var shouldMoveUpRemainingRows = false
        if n + 1 < self.timeRows.count - 1 {
            shouldMoveUpRemainingRows = true
        }
        
        // 刪除時間欄位
        for (_, label) in self.timeRows[n + 1].enumerated() {
            label.removeFromSuperview()
        }
        self.timeRows.remove(at: n + 1)
        // 重新照順序排定時間欄位的 tag
        
        // 刪除 + 和 - 按鈕
        self.operatorButtons[n * 2 + 1].removeFromSuperview()
        self.operatorButtons[n * 2].removeFromSuperview()
        self.operatorButtons.remove(at: n * 2 + 1)
        self.operatorButtons.remove(at: n * 2)
        // 重新照順序排定每列所選運算元按鈕的 tag
        for (i, operatorButton) in self.operatorButtons.enumerated() {
            operatorButton.tag = i
        }
        self.operators.remove(at: n)
        
        // 刪除減列按鈕
        self.removeRowButtons[n].removeFromSuperview()
        self.removeRowButtons.remove(at: n)
        // 重新照順序排定減列按鈕的 tag
        for (i, removeRowButton) in self.removeRowButtons.enumerated() {
            removeRowButton.tag = i
        }

        //若刪的是中間的列，則下面的列要往上移
        if shouldMoveUpRemainingRows {
            for i in n + 1...self.timeRows.count - 1 {
                self.operatorButtons[(i - 1) * 2].frame.origin.y -= 75
                self.operatorButtons[(i - 1) * 2 + 1].frame.origin.y -= 75

                self.timeRows[i][0].frame.origin.y -= 75
                self.timeRows[i][1].frame.origin.y -= 75
                self.timeRows[i][2].frame.origin.y -= 75
                self.timeRows[i][0].tag = timeRows[i - 1][0].tag + 3
                self.timeRows[i][1].tag = timeRows[i - 1][1].tag + 3
                self.timeRows[i][2].tag = timeRows[i - 1][2].tag + 3

                self.removeRowButtons[i - 1].frame.origin.y -= 75
            }
        }

        // 調整結果列
        adjustSeparatorAndResultLabels(isAppend: false)
        
        // 檢查 focusedLabel 是否在要被移除的列中，如果是就把 focusedLabel 往上移一列
        for i in (n + 1) * 3...(n + 1) * 3 + 2 {
            if i == focusedLabel?.tag {
                if n == timeRows.count - 1 { // 是最後一列
                    focusedLabel = timeRows[n][i % 3]
                    focusedLabel?.backgroundColor = getFocusedBackgroundColor()
                    break
                }
                else {
                    focusedLabel = timeRows[n + 1][i % 3]
                    focusedLabel?.backgroundColor = getFocusedBackgroundColor()
                    break
                }
            }
        }

        btnTouchedUp(btn: sender, playSound: true)
    }
    
    @objc func addOrSubstract(_ sender: UIButton) {
        playSound(player: audioPlayer, soundOn: sceneDelegate!.soundSetting)
        
        if sender.tag % 2 == 0 {
            self.operatorButtons[sender.tag].layer.borderWidth = 1
            self.operatorButtons[sender.tag].layer.borderColor = btnBorderColor
            self.operatorButtons[sender.tag + 1].layer.borderWidth = 0
            self.operators[sender.tag / 2] = true
        }
        else {
            self.operatorButtons[sender.tag - 1].layer.borderWidth = 0
            self.operatorButtons[sender.tag].layer.borderWidth = 1
            self.operatorButtons[sender.tag].layer.borderColor = btnBorderColor
            self.operators[sender.tag / 2] = false
        }
    }
    
    func adjustSeparatorAndResultLabels(isAppend: Bool) {
        if timeRows.count >= 2 {
            if isAppend {
                separatorView.frame.origin.y += rowSpacing
                totalTopConstraint.constant += rowSpacing
            }
            else {
                separatorView.frame.origin.y -= rowSpacing
                totalTopConstraint.constant -= rowSpacing
            }
        }
                
        // 更新減列按鈕出現與否
        if removeRowButtons.count <= 1 {
            for (i, _) in removeRowButtons.enumerated() {
                removeRowButtons[i].isHidden = true
            }
        }
        else {
            for (i, _) in removeRowButtons.enumerated() {
                removeRowButtons[i].isHidden = false
            }
        }
                
        shouldChangeLayout = true
        viewDidLayoutSubviews()        
    }
    
    @objc func focus(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        
        playSound(player: audioPlayer, soundOn: sceneDelegate!.soundSetting)
        
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
    
    @IBAction func moveFocus(_ sender: UIButton) {
        btnTouchedUp(btn: sender, playSound: true)
        
        if sender.tag == 0 {
            if self.focusedLabel!.tag > 0 {
                var tmp: UILabel?
                outerLoop: for i in timeRows {
                    for j in i {
                        if j.tag + 1 == self.focusedLabel!.tag { // the new focused label
                            j.backgroundColor = getFocusedBackgroundColor()
                            tmp = j
                        }
                        else if j.tag == self.focusedLabel!.tag { // the previous focused label
                            if #available(iOS 13.0, *) {
                                j.backgroundColor = .systemBackground
                            } else {
                                j.backgroundColor = contentView.backgroundColor
                            }
                            self.focusedLabel = tmp
                            break outerLoop
                        }
                    }
                }
            }
        }
        else {
            var noOfLabel = 0
            for i in timeRows {
                for _ in i {
                    noOfLabel += 1
                }
            }
            if self.focusedLabel!.tag < noOfLabel - 1 {
                outerLoop: for i in timeRows {
                    for j in i {
                        if j.tag == self.focusedLabel!.tag { // the previous focused label
                            if #available(iOS 13.0, *) {
                                j.backgroundColor = .systemBackground
                            } else {
                                j.backgroundColor = contentView.backgroundColor
                            }
                        }
                        else if j.tag == self.focusedLabel!.tag + 1 { // the new focused label
                            self.focusedLabel = j
                            j.backgroundColor = getFocusedBackgroundColor()
                            break outerLoop
                        }
                    }
                }
            }
        }
        
        validate(number: focusedLabel!.text!)
    }
    
    func getFocusedBackgroundColor() -> UIColor {
        if #available(iOS 13.0, *) {
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
    
    @IBAction func inputDigit(_ sender: UIButton) {
        btnTouchedUp(btn: sender, playSound: true)
        
        if self.focusedLabel?.text! == "00" {
            self.focusedLabel?.text = ""
        }
        self.focusedLabel?.text! += (sender.titleLabel?.text!)!
        
        self.validate(number: focusedLabel!.text!)
    }

    @IBAction func backspace(_ sender: UIButton) {
        btnTouchedUp(btn: sender, playSound: true)
        
        if (self.focusedLabel?.text!.count)! > 0 && Int((self.focusedLabel?.text!)!)! != 0 {
            self.focusedLabel?.text!.removeLast()
        }
        
        if (self.focusedLabel?.text!.count)! == 0 {
            self.focusedLabel?.text = "00"
        }
        
        self.validate(number: focusedLabel!.text!)
    }
    
    @IBAction func clear(_ sender: UIButton) {
        btnTouchedUp(btn: sender, playSound: true)
        
        for i in timeRows {
            for j in i {
                j.text = "00"
                j.layer.borderColor = timeLabelBorderColor
            }
        }
        
        self.validate(number: focusedLabel!.text!)
        
        hrTotal.text! = "00"
        minTotal.text! = "00"
        secTotal.text! = "00"
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
    
    @IBAction func calculate(_ sender: UIButton) {
        playSound(player: audioPlayer2, soundOn: sceneDelegate!.soundSetting)

        var totalSec = 0
        var totalSecN = 0

        for (i, row) in self.timeRows.enumerated() {
            let hrN = Int(row[0].text!)!
            let minN = Int(row[1].text!)!
            let secN = Int(row[2].text!)!

            totalSecN = hrN * 3600 + minN * 60 + secN

            if i == 0 {
                totalSec = totalSecN
            }
            else {
                if operators[i - 1] {
                    totalSec = totalSec + totalSecN
                }
                else {
                    totalSec = totalSec - totalSecN
                }
            }
        }

        let hrResult = totalSec / 3600
        let minResult = (totalSec % 3600) / 60
        let secResult = (totalSec % 3600) % 60

        self.hrTotal.text = String(format: "%02d", hrResult)
        self.minTotal.text = String(format: "%02d", minResult)
        self.secTotal.text = String(format: "%02d", secResult)

        btnTouchedUp(btn: sender, playSound: false)
    }
    
    @IBAction func btnTouchedDown(_ sender: UIButton) {
        sender.layer.borderWidth = 1
        sender.layer.borderColor = btnBorderColor
    }
    
    @IBAction func btnTouchedUp(btn: UIButton, playSound: Bool) {
        btn.layer.borderWidth = 0
        btn.layer.borderColor = nil
        
        if playSound {
            self.playSound(player: audioPlayer, soundOn: sceneDelegate!.soundSetting)
        }
    }
    
    func playSound(player: AVAudioPlayer, soundOn: Bool) {
        if soundOn {
            player.play()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as? UIButton {
            btnTouchedUp(btn: button, playSound: true)
        }
    }
    
    @IBAction func backFromSettingsPage(segue: UIStoryboardSegue) {
//        let source = segue.source as? SettingsViewController
    }
    
    func addMultipleRows(numberOfRows: Int) {
        if numberOfRows <= 0 {
            return
        }
        
        for _ in 0...numberOfRows - 1 {
            addRow(UIButton())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Received memory warning!!!")
    }
}
