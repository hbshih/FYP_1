//
//  TableViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 02/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import UserNotifications

class SettingTableViewController: UITableViewController
{
    @IBOutlet weak var notificationSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func smartNotificationSwitch(_ sender: Any)
    {
        if (notificationSwitch.isOn)
        {
            SCLAlertMessage(title: "Love you 💕", message: "I will remind you when you should improve your balance diet").showMessage()
            
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Title"
            notificationContent.body = "Body Message"
            
            var date = DateComponents()
            date.hour = 15
            date.minute = 44
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
            let notificationRequest = UNNotificationRequest(identifier: "\(NSDate().timeIntervalSince1970)", content: notificationContent, trigger: notificationTrigger)
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error
                {
                    let errorString = String(format: NSLocalizedString("Unable to Add Notification Request %@, %@", comment: ""), error as CVarArg, error.localizedDescription)
                    print(errorString)
                }else
                {
                    print("Notification Added succesful!")
                }
            }
        }else
        {
            SCLAlertMessage(title: "Awwwww", message: "I will not bother you when you are eating imbalance, but don't forget to keep recording your food diary with me").showMessage()
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (request) in
                print(request)
            })
            print("Push Cancelled")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (request) in
                print(request)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Showing all settings options
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(indexPath.row)
        if indexPath.row == 1
        {
            performSegue(withIdentifier: "nutritionSettings", sender: nil)
        }else if indexPath.row == 2
        {
            performSegue(withIdentifier: "dataSettingsSegue", sender: nil)
        }else if indexPath.row == 3
        {
            performSegue(withIdentifier: "conditionSegue", sender: nil)
        }else if indexPath.row == 4
        {
            performSegue(withIdentifier: "privacySegue", sender: nil)
        }else if indexPath.row == 5
        {
            performSegue(withIdentifier: "reportABugSegue", sender: nil)
        }else if indexPath.row == 6
        {
            performSegue(withIdentifier: "licenseSegue", sender: nil)
        }else
        {
            //Do nothing
        }
    }

}
