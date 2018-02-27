//
//  SendFeedbackViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 07/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit
import IBAnimatable
import FirebaseDatabase

class SendFeedbackViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var feedbackMessage: AnimatableTextView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    /*Send to DATABASE*/
    @IBAction func sendBugFeedback(_ sender: Any)
    {
        let valid = validate()
        if valid.isValidEmail(testStr: emailTextfield.text!) && feedbackMessage.text != ""
        {
            var ref: DatabaseReference!
            
            ref = Database.database().reference()
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd-hh-mm-ss"
            let currentTime = format.string(from: Date())
                print("connect to backend")
            ref.child("Feedback").childByAutoId().setValue(["Timestamp":currentTime,"email":self.emailTextfield.text! ,"feedback":self.feedbackMessage.text!])
                let alert = UIAlertController(title: "Thank you", message: "We have received your feedback, we will contact you if needed!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }else
        {
            let alert = UIAlertController(title: "Ooops", message: "Please recheck your email or check if you have type in correct message.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
