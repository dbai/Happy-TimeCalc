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
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        soundSwitch.setOn(sceneDelegate!.soundSetting, animated: false)
        supportDarkModeSwitch.setOn(sceneDelegate!.supportDarkMode, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

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
                sceneDelegate!.window?.overrideUserInterfaceStyle = .light
            } else {
                // Fallback on earlier versions
            }
        }
        else {
            if #available(iOS 13.0, *) {
                sceneDelegate!.window?.overrideUserInterfaceStyle = .unspecified
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
