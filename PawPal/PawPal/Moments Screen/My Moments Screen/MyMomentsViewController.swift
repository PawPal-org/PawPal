//
//  MyMomentsViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/22/23.
//

import UIKit

class MyMomentsViewController: UIViewController {
    
    let myMomentsView = MyMomentsView()
    var myMoments = [Moment]()
    var userEmail: String?
    var userName: String?
    var latestMomentTimestamp: Date?
    
    override func loadView() {
        view = myMomentsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}
