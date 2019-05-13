//
//  AppDelegate.swift
//  Twitter
//
//  Created by CHEN SINYU on 2019/05/07.
//  Copyright © 2019 CHEN SINYU. All rights reserved.
//

import UIKit
import Alamofire
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let consumerKey = "Paste Your Key "
        let consumerSecret = "Paste Your Secret"
        let credentialsString = "\(consumerKey):\(consumerSecret)"
        let credentialsData = credentialsString.data(using: .utf8)
        let base64String = credentialsData!.base64EncodedString()
        let headers = ["Authorization": "Basic \(base64String)",
                       "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
                      ]
        let params: [String : AnyObject] = ["grant_type": "client_credentials" as AnyObject]
        Alamofire.request("https://api.twitter.com/oauth2/token", method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers)
            .responseJSON { response in switch response.result {
            case .success(let JSON):
                
                let response = JSON as! NSDictionary
                let token = response.value(forKeyPath:"access_token" ) as! String
                UserDefaults.standard.set(token,forKey:"Token")
                UserDefaults.standard.synchronize()
                
                
            case .failure(let error):
                
                print("Request failed with error: \(error)")
                
                }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

