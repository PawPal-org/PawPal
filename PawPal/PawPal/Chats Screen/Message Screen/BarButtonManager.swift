//
//  BarButtonManager.swift
//  PawPal
//
//  Created by Yitian Guo on 11/28/23.
//

import Foundation
import UIKit
import FirebaseAuth

extension MessageViewController{
    
    func setupRightBarButton() {
        let barIcon = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(onRightBarButtonTapped)
        )
        navigationItem.rightBarButtonItems = [barIcon]
    }
    
    @objc func onRightBarButtonTapped(){
        return
    }
    
}
