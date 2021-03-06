//
//  AppDelegate.swift
//  MemeMate
//
//  Created by Andrew H. Yi on 4/11/15.
//  Copyright (c) 2015 AndrewHYi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController?
    var savedMemes: [Meme] = []

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var fakeMeme = Meme(topText: "Top Text", bottomText: "Bottom Text", image: UIImage(named: "tableViewIcon")!, memedImage: UIImage(named: "tableViewIcon")!)
        let tableViewController = MemeTableViewController()
        tableViewController.tabBarItem = UITabBarItem(title: "table", image: UIImage(named: "tableViewIcon"), tag: 1)
        
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(80, 80)
        let collectionViewController = MemeCollectionViewController(collectionViewLayout: flowLayout)
        collectionViewController.tabBarItem = UITabBarItem(title: "gallery", image: UIImage(named: "collectionViewIcon"), tag: 2)
        
        let tableNavController = UINavigationController(rootViewController: tableViewController)
        let collectionNavController = UINavigationController(rootViewController: collectionViewController)
        
        tabBarController = UITabBarController()
        tabBarController?.setViewControllers([tableNavController, collectionNavController], animated: true)
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

