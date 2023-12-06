//
//  PostMomentProgressIndicatorManager.swift
//  PawPal
//
//  Created by Yitian Guo on 12/5/23.
//

import Foundation

extension PostMomentViewController:ProgressSpinnerDelegate{
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
