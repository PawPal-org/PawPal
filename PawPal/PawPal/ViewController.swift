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
        addTabBarBackground()
    }
    
    func setUpTabBarController() {
        //MARK: resize custom image to match standard tab bar item size
        let discoverImage = resizeImage(image: UIImage(named: "Discover")!, targetSize: CGSize(width: 50, height: 50))
        let discoverSelectedImage = resizeImage(image: UIImage(named: "Discover")!, targetSize: CGSize(width: 50, height: 50))
        
        let beFriendsImage = resizeImage(image: UIImage(named: "BeFriends")!, targetSize: CGSize(width: 50, height: 50))
        let beFriendsSelectedImage = resizeImage(image: UIImage(named: "BeFriends")!, targetSize: CGSize(width: 50, height: 50))
        
        let momentsImage = resizeImage(image: UIImage(named: "Moments")!, targetSize: CGSize(width: 50, height: 50))
        let momentsSelectedImage = resizeImage(image: UIImage(named: "Moments")!, targetSize: CGSize(width: 50, height: 50))
        
        let chatsImage = resizeImage(image: UIImage(named: "Chats")!, targetSize: CGSize(width: 50, height: 50))
        let chatsSelectedImage = resizeImage(image: UIImage(named: "Chats")!, targetSize: CGSize(width: 50, height: 50))
        
        let meImage = resizeImage(image: UIImage(named: "Me")!, targetSize: CGSize(width: 50, height: 50))
        let meSelectedImage = resizeImage(image: UIImage(named: "Me")!, targetSize: CGSize(width: 50, height: 50))
        
        //MARK: setting up Discover tab bar...
        let tabDiscover = UINavigationController(rootViewController: DiscoverViewController())
        let tabDiscoverBarItem = UITabBarItem(
            title: "Discover",
            image: discoverImage.withRenderingMode(.alwaysTemplate),
            selectedImage: discoverSelectedImage.withRenderingMode(.alwaysTemplate)
        )
        tabDiscover.tabBarItem = tabDiscoverBarItem
        tabDiscover.title = "Discover"
        
        //MARK: setting up BeFriends tab bar...
        let tabFriends = UINavigationController(rootViewController: FriendsViewController())
        let tabFriendsBarItem = UITabBarItem(
            title: "Friends",
            image: beFriendsImage.withRenderingMode(.alwaysTemplate),
            selectedImage: beFriendsSelectedImage.withRenderingMode(.alwaysTemplate)
        )
        tabFriends.tabBarItem = tabFriendsBarItem
        tabFriends.title = "Friends"
        
        //MARK: setting up Moments tab bar...
        let tabMoments = UINavigationController(rootViewController: MomentsViewController())
        let tabMomentsBarItem = UITabBarItem(
            title: "Moments",
            image: momentsImage.withRenderingMode(.alwaysTemplate),
            selectedImage: momentsSelectedImage.withRenderingMode(.alwaysTemplate)
        )
        tabMoments.tabBarItem = tabMomentsBarItem
        tabMoments.title = "Moments"
        
        //MARK: setting up Chats tab bar...
        let tabChats = UINavigationController(rootViewController: ChatsViewController())
        let tabChatsBarItem = UITabBarItem(
            title: "Chats",
            image: chatsImage.withRenderingMode(.alwaysTemplate),
            selectedImage: chatsSelectedImage.withRenderingMode(.alwaysTemplate)
        )
        tabChats.tabBarItem = tabChatsBarItem
        tabChats.title = "Chats"
        
        //MARK: setting up Me tab bar...
        let tabMe = UINavigationController(rootViewController: MeViewController())
        let tabMeBarItem = UITabBarItem(
            title: "Me",
            image: meImage.withRenderingMode(.alwaysTemplate),
            selectedImage: meSelectedImage.withRenderingMode(.alwaysTemplate)
        )
        tabMe.tabBarItem = tabMeBarItem
        tabMe.title = "Me"
        
        //MARK: setting up this view controller as the Tab Bar Controller...
        self.viewControllers = [tabDiscover, tabFriends, tabMoments, tabChats, tabMe]
        
        // Apply tintColor for tab items
        self.tabBar.tintColor = UIColor.systemBlue
        self.tabBar.unselectedItemTintColor = UIColor.lightGray
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func addTabBarBackground() {
        let tabBarBackgroundView = UIView()
        tabBarBackgroundView.backgroundColor = lighterBackgroundColorBeige
        tabBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.tabBar.addSubview(tabBarBackgroundView)
        self.tabBar.insertSubview(tabBarBackgroundView, at: 0)

        NSLayoutConstraint.activate([
            tabBarBackgroundView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -5),
            tabBarBackgroundView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
            tabBarBackgroundView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            tabBarBackgroundView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor)
        ])
    }

}

