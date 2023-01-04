//
//  AppDelegate.swift
//  iOS Getting Started
//
//  Created by Satej Sahu on 04/01/23.
//

import Foundation
import UIKit

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // initialize Amplify
    let _ = Backend.initialize()

    return true
}
