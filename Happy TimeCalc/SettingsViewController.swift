//
//  SettingsViewController.swift
//  Happy TimeCalc
//
//  Created by David Pai on 2020/5/4.
//  Copyright © 2020 Pai Bros. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var supportDarkModeSwitch: UISwitch!
    
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window = UIWindow()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        window = SceneDelegate.shared?.window as! UIWindow
//        appDelegate = self.view.window?.windowScene?.delegate
//        soundSwitch.setOn(appDelegate.soundSetting, animated: false)
//        supportDarkModeSwitch.setOn(appDelegate.supportDarkMode, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

//        appDelegate.soundSetting = soundSwitch.isOn
//        appDelegate.supportDarkMode = supportDarkModeSwitch.isOn
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let button = sender as? UIButton {
//            let mainPage = segue.destination as? Page1ViewController
//            mainPage?.soundSetting = soundSwitch.isOn
//        }
//    }
    
    @IBAction func switchSound(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "sound")
    }
    
    @IBAction func switchSupportDarkMode(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "supportDarkMode")
        
        if !sender.isOn {
            print("Off")
            if #available(iOS 13.0, *) {
//                appDelegate.window?.overrideUserInterfaceStyle = .light
                window.overrideUserInterfaceStyle = .light
//                self.overrideUserInterfaceStyle = .light
                print("應該要打亮")
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            print("On")
            if #available(iOS 13.0, *) {
//                appDelegate.window?.overrideUserInterfaceStyle = .unspecified
                window.overrideUserInterfaceStyle = .unspecified
            } else {
                
            }
        }
    }
}
