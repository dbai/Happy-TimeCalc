//
//  SettingsViewController.swift
//  Happy TimeCalc
//
//  Created by David Pai on 2020/5/4.
//  Copyright © 2020 Pai Bros. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var supportDarkModeSwitch: UISwitch!
    @IBOutlet weak var starCountSlider: UISlider!
    
    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presentationController?.delegate = self
        
        soundSwitch.setOn(sceneDelegate!.soundSetting, animated: false)
        supportDarkModeSwitch.setOn(sceneDelegate!.supportDarkMode, animated: false)
        starCountSlider.setValue(Float(sceneDelegate!.starCount), animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        sceneDelegate!.soundSetting = soundSwitch.isOn
        sceneDelegate!.supportDarkMode = supportDarkModeSwitch.isOn
        sceneDelegate!.starCount = Int(starCountSlider.value)
    }
    
    @IBAction func toggleSound(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "sound")
    }
    
    @IBAction func toggleSupportDarkMode(_ sender: UISwitch) {
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
            
    @IBAction func setStarCount(_ sender: UISlider) {
        UserDefaults.standard.set(sender.value, forKey: "starCount")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainVC = segue.destination as? ViewController
        mainVC?.shouldChangeStars = true
        mainVC?.viewDidLayoutSubviews()
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        let mainVC = presentationController.presentingViewController as? ViewController
        mainVC?.shouldChangeStars = true
        mainVC?.viewDidLayoutSubviews()
    }
}
