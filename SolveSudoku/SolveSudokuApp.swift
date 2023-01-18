//
//  SolveSudokuApp.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-15.
//

import SwiftUI

@main
struct SolveSudokuApp: App
{
    @UIApplicationDelegateAdaptor( AppDelegate.self ) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate
{
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
        return AppDelegate.orientationLock
    }
}
