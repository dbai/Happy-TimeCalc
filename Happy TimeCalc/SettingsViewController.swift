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
    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        soundSwitch.setOn(appDelegate.soundSetting, animated: false)
//        supportDarkModeSwitch.setOn(appDelegate.supportDarkMode, animated: false)
        soundSwitch.setOn(sceneDelegate!.soundSetting, animated: false)
        supportDarkModeSwitch.setOn(sceneDelegate!.supportDarkMode, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

//        appDelegate.soundSetting = soundSwitch.isOn
//        appDelegate.supportDarkMode = supportDarkModeSwitch.isOn
        sceneDelegate!.soundSetting = soundSwitch.isOn
        sceneDelegate!.supportDarkMode = supportDarkModeSwitch.isOn
    }
    
    @IBAction func switchSound(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "sound")
    }
    
    @IBAction func switchSupportDarkMode(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "supportDarkMode")
        
        if !sender.isOn {
            print("Off")
            if #available(iOS 13.0, *) {
//                appDelegate.window?.overrideUserInterfaceStyle = .light
                sceneDelegate!.window?.overrideUserInterfaceStyle = .light
//                window.overrideUserInterfaceStyle = .light
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
                sceneDelegate!.window?.overrideUserInterfaceStyle = .unspecified
//                self.overrideUserInterfaceStyle = .unspecified
            } else {
                
            }
        }
    }
            
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let button = sender as? UIButton {
    //            let mainPage = segue.destination as? Page1ViewController
    //            mainPage?.soundSetting = soundSwitch.isOn
    //        }
    //    }
}
