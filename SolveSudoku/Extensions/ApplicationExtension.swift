//
//  WindowExtension.swift
//  NodeConnectr
//
//  Created by Development on 07/12/2022.
//  Copyright © 2022 Syrinx Industrial Electronics. All rights reserved.
//

import Foundation
import UIKit
//#
//############################################################################
//# UIApplication
//#
extension UIApplication {
    var mainKeyWindow: UIWindow? {
        get {
            if #available(iOS 13, *) {
                return connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }
            } else {
                return keyWindow
            }
        }
    }
    //------------------------------------------------------------------------
    var rootView: UIViewController? {
        guard let keyWindow = mainKeyWindow else {
            return nil
        }
        var rootViewController = keyWindow.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        return rootViewController
    }
}
//#
//# UIApplication
//############################################################################
//#
