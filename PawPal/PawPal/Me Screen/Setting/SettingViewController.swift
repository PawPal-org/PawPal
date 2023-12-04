//
//  SettingViewController.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/3/23.
//

import UIKit

class SettingViewController: UIViewController {
    
    //MARK: creating instance of DisplayView
    let settingScreen = SettingView()

    //MARK: patch the view of the controller to the DisplayView
    override func loadView() {
        view = settingScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Account Information"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit, target: self,
            action: #selector(onEditBarButtonTapped)
        )
    
        settingScreen.labelEmail.text = "Email"
        settingScreen.labelName.text = "Name"
        settingScreen.labelPassword.text = "Password"
    }
    
    @objc func onEditBarButtonTapped(){
        let settingEditController = SettingEditViewController()
        navigationController?.pushViewController(settingEditController, animated: true)
    }

}

