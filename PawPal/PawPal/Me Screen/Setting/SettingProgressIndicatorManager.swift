//
//  SettingProgressIndicatorManager.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/4/23.
//


import Foundation

extension SettingViewController:ProgressSpinnerDelegate{
    func showActivityIndicator(){
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }
    
    func hideActivityIndicator(){
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}
