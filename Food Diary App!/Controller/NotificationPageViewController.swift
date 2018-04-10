//
//  NotificationPageViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 10/04/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AllowTapped(_ sender: Any)
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
            }
        }
        
    }
}
