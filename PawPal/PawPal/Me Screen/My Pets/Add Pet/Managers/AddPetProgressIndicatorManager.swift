//
//  AddPetProgressIndicatorManager.swift
//  PawPal
//
//  Created by Cynthia Zhang on 12/7/23.
//

import Foundation

extension AddPetViewController:ProgressSpinnerDelegate{
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
