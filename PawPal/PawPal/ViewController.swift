//
//  ViewController.swift
//  PawPal
//
//  Created by Schromeo on 11/17/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {
    
    let mainScreen = MainScreenView()
    
    //authentication state change listenser
    var handleAuth: AuthStateDidChangeListenerHandle?
    //keep an instance of the current signed-in Firebase user
    var currentUser:FirebaseAuth.User?
    
    override func loadView() {
        view = mainScreen
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: handling if the Authentication state is changed (sign in, sign out, register)...
        handleAuth = Auth.auth().addStateDidChangeListener{ auth, user in
            if user == nil{
                //MARK: not signed in...
                // go to Login Screen
                
                
            }else{
                //MARK: signed in...
                self.currentUser = user
                // showing the tab bar of 5 freatures
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main Screen" // so what about this screen to be?
        
        //MARK: Make the titles look large...
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
    }


}

