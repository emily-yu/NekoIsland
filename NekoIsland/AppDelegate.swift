//
//  AppDelegate.swift
//  NekoIsland
//
//  Created by VC on 7/15/16.
//  Copyright © 2016 Makeschool. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation
import GameKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

        
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        NSNotificationCenter.defaultCenter().postNotificationName("pauseGameScene", object: self)

        SKTAudio.sharedInstance().pauseBackgroundMusic() // Pause the music
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        NSNotificationCenter.defaultCenter().postNotificationName("pauseGameScene", object: self)
        
        SKTAudio.sharedInstance().pauseBackgroundMusic() // Pause the music

    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        NSNotificationCenter.defaultCenter().postNotificationName("pauseGameScene", object: self)
        SKTAudio.sharedInstance().resumeBackgroundMusic() // Resume the music
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        SKTAudio.sharedInstance().playBackgroundMusic("bensound-acousticbreeze.mp3")
        
        NSNotificationCenter.defaultCenter().postNotificationName("pauseGameScene", object: self)
        highScore = NSUserDefaults.standardUserDefaults().integerForKey("High Score")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        SKTAudio.sharedInstance().pauseBackgroundMusic() // Pause the music
        
        NSUserDefaults.standardUserDefaults().setInteger(highScore, forKey: "High Score")
        NSUserDefaults.standardUserDefaults().synchronize()
    }


}

