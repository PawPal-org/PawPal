//
//  ChatsViewController.swift
//  PawPal
//
//  Created by Yitian Guo on 11/19/23.
//

import UIKit

class ChatsViewController: UIViewController {

    let chatsView = ChatsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Chats"
    }

}
