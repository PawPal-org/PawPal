//
//  ViewController.swift
//  PawPal
//
//  Created by Schromeo on 11/17/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarController()
    }
    
    func setUpTabBarController() {
        //MARK: setting up Discover tab bar...
        let tabDiscover = UINavigationController(rootViewController: DiscoverViewController())
        let tabDiscoverBarItem = UITabBarItem(
            title: "Discover",
            image: UIImage(systemName: "d.square")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(systemName: "d.square.fill")
        )
        tabDiscover.tabBarItem = tabDiscoverBarItem
        tabDiscover.title = "Discover"
        
        //MARK: setting up BeFriends tab bar...
        let tabBeFriends = UINavigationController(rootViewController: BeFriendsViewController())
        let tabBeFriendsBarItem = UITabBarItem(
            title: "BeFriends",
            image: UIImage(systemName: "b.square")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(systemName: "b.square.fill")
        )
        tabBeFriends.tabBarItem = tabBeFriendsBarItem
        tabBeFriends.title = "BeFriends"
        
        //MARK: setting up Moments tab bar...
        let tabMoments = UINavigationController(rootViewController: MomentsViewController())
        let tabMomentsBarItem = UITabBarItem(
            title: "Moments",
            image: UIImage(systemName: "m.square")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(systemName: "m.square.fill")
        )
        tabMoments.tabBarItem = tabMomentsBarItem
        tabMoments.title = "Moments"
        
        //MARK: setting up Chats tab bar...
        let tabChats = UINavigationController(rootViewController: ChatsViewController())
        let tabChatsBarItem = UITabBarItem(
            title: "Chats",
            image: UIImage(systemName: "c.square")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(systemName: "c.square.fill")
        )
        tabChats.tabBarItem = tabChatsBarItem
        tabChats.title = "Chats"
        
        //MARK: setting up Me tab bar...
        let tabMe = UINavigationController(rootViewController: MeViewController())
        let tabMeBarItem = UITabBarItem(
            title: "Me",
            image: UIImage(systemName: "m.square")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(systemName: "m.square.fill")
        )
        tabMe.tabBarItem = tabMeBarItem
        tabMe.title = "Me"
        
        //MARK: setting up this view controller as the Tab Bar Controller...
        self.viewControllers = [tabDiscover, tabBeFriends, tabMoments, tabChats, tabMe]
    }

}

