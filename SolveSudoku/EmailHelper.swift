//
//  EmailHelper.swift
//  SolveSudoku
//
//  Created by Wiljo de Ruiter on 2023-01-21.
//

import Foundation
import MessageUI

class EmailHelper: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailHelper()
    private override init() {
        //
    }
    
    func sendEmail(subject:String, body:String, to:String){
        if !MFMailComposeViewController.canSendMail() {
            print("No mail account found")
            // Todo: Add a way to show banner to user about no mail app found or configured
            // Utilities.showErrorBanner(title: "No mail account found", subtitle: "Please setup a mail account")
            return //EXIT
        }
        
        let picker = MFMailComposeViewController()
        
        picker.setSubject(subject)
        picker.setMessageBody(body, isHTML: true)
        picker.setToRecipients([to])
        picker.mailComposeDelegate = self
        
        if let rootView = UIApplication.shared.rootView {
            rootView.present(picker, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let rootView = UIApplication.shared.rootView {
            rootView.dismiss(animated: true, completion: nil)
        }
    }
    
//    static func getRootViewController() -> UIViewController? {
//        //(UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController
//
//        // OR If you use SwiftUI 2.0 based WindowGroup try this one
//        UIApplication.rootView
//        //shared.windows.first?.rootViewController
//        //UIWindowScene.windows.first?.rootViewController
//    }
}
