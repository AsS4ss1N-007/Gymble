//
//  TabBarController.swift
//  Gymble
//
//  Created by Sachin's Macbook Pro on 19/08/20.
//  Copyright © 2020 Sachin's Macbook Pro. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        view.backgroundColor = .black
        self.tabBarController?.modalPresentationStyle = .fullScreen
    }
    
    func configureTabBarController(){
        tabBar.isHidden = false
        UITabBar.appearance().barTintColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
        UITabBar.appearance().tintColor = Colors.mainOrange
        
        tabBar.isTranslucent = false
        viewControllers = [setupHomeVC(), setupScheduleVC(), setupTimelineVC()]
    }
    
    func checkIfUserIsLoggedIn(){
        if Auth.auth().currentUser?.uid == nil{
            tabBar.isHidden = true
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }else{
            //             print("User is logged in with the id \(Auth.auth().currentUser?.uid)")
            configureTabBarController()
        }
    }
    
    func setupHomeVC() -> UINavigationController{
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem.title = "Home"
        homeVC.tabBarItem.image = #imageLiteral(resourceName: "Home")
        return homeVC
    }
    
    func setupScheduleVC() -> UINavigationController{
        let scheduleVC = UINavigationController(rootViewController: ScheduleViewController())
        scheduleVC.tabBarItem.title = "Schedule"
        scheduleVC.tabBarItem.image = #imageLiteral(resourceName: "Schedule")
        return scheduleVC
    }
    
    func setupTimelineVC() -> UINavigationController{
        let timelineVC = UINavigationController(rootViewController: TimelineViewController())
        timelineVC.tabBarItem.title = "Timeline"
        timelineVC.tabBarItem.image = #imageLiteral(resourceName: "Timeline_Selected")
        return timelineVC
    }
    
    @objc func showLoginController(){
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.navigationBar.isHidden = true
            nav.navigationItem.hidesBackButton = true
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}
