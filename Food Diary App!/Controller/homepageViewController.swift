//
//  homepageViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 13/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import SCLAlertView
import FirebaseDatabase
import CoreData
import FirebaseAnalytics
import Instructions
import FanMenu
import Macaw
import AVFoundation
import UserNotifications

class homepageViewController: UIViewController {
    
    /* Outlets to story board */
    
    // outlets for showing average percentage
    @IBOutlet weak var informationLabel: UILabel!
    // elements small slider area
    @IBOutlet weak var foodgroupsStackView: UIStackView!
    @IBOutlet weak var dairyCircularSlider: KDCircularProgress!
    @IBOutlet weak var fruitCircularSlider: KDCircularProgress!
    @IBOutlet weak var proteinCircularSlider: KDCircularProgress!
    @IBOutlet weak var grainCircularSlider: KDCircularProgress!
    @IBOutlet weak var vegetableCircularSlider: KDCircularProgress!
    // Main slider
    @IBOutlet weak var circularSlider: KDCircularProgress!
    // Center area outlets
    @IBOutlet weak var centerFace: UIButton!
    @IBOutlet weak var centerInformationArea: UILabel!
    @IBOutlet weak var centerFaceArea: UIButton!
   // @IBOutlet weak var cameraButtonOutlet: UIButton!
    @IBOutlet weak var centerInformationView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var fanMenu: FanMenu!
    @IBOutlet weak var coverView: UIView!
   // @IBOutlet weak var cameraButton: UIButton
    
    // Variables to store percentage informations
    private var healthPercentage = 0.0
    private var vegetablePercentage = 0.0
    private var dairyPercentage = 0.0
    private var fruitPercentage = 0.0
    private var proteinPercentage = 0.0
    private var grainPercentage = 0.0
    
    // General Variables
    private var timestamp: [Date] = []// Date
    private var notes: [String] = [] // Storing notes
    private var recordCount = 0 // How many record the user has
    private var recentCount = 0 //
    private var messageCounter = 0
    private var messageToUsers: [String] = []
    private var showStartingMessageToNewUsers = false
    
    var objPlayer: AVAudioPlayer?
    
    private var Standard = [0.0,0.0,0.0,0.0,0.0]
    
    private var n_List = ["grainList":[0.0],"vegetableList":[0.0],"proteinList":[0.0],"dairyList":[0.0],"fruitList":[0.0]]
    
    // Access Data
    private var dataHandler = CoreDataHandler()
    let defaults = UserDefaultsHandler()
    
    // For tutorial walkthrough
    let coachMarksController = CoachMarksController()
    var coachversion = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getInteractionMessages()
        centerInformationArea.alpha = 0
        if defaults.getHomepageTutorialStatus() == true
        {
            /*Existing user, watched tutorial already*/
        }else
        {
            coachversion = 1
            /*New User*/
            self.coachMarksController.dataSource = self
            self.coachMarksController.start(on: self)
            self.coachMarksController.overlay.allowTap = true
            let skipView = CoachMarkSkipDefaultView()
            skipView.setTitle("Skip", for: .normal)
            self.coachMarksController.skipView = skipView
            
        }
        
        fanMenu.button = FanMenuButton(id: "main", image: "Icon_AddNew", color: Color(val: 0xADADAD))
        
        fanMenu.items = [
            FanMenuButton(
                id: "camAdd",
                image: "icon_camAdd",
                color: Color(val: 0xCECBCB)
            ),
            FanMenuButton(
                id: "noteAdd",
                image: "icon_noteAdd",
                color: Color(val: 0xCECBCB)
            ),
        ]
        
        fanMenu.menuRadius = 90.0
        fanMenu.duration = 0.2
        fanMenu.interval = (Double.pi + Double.pi/4, Double.pi + 3 * Double.pi/4)
        fanMenu.radius = 25.0
        fanMenu.delay = 0.0
        
        fanMenu.onItemWillClick = { button in
            self.showView()
        }
        
        fanMenu.onItemDidClick = { button in
            print("ItemWillClick: \(button.id)")
            if button.id == "camAdd"
            {
                if UserDefaultsHandler().getCameraTip() != true
                {
                    let appearance = SCLAlertView.SCLAppearance(
                        //kCircleIconHeight: 55.0
                        kTitleFont: UIFont(name: "HelveticaNeue-Medium", size: 18)!,
                        kTextFont: UIFont(name: "HelveticaNeue", size: 16)!,
                        kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 18)!,
                        showCloseButton: false
                    )
                    let alert = SCLAlertView(appearance: appearance)
                    let icon = UIImage(named:"Alert_Yellow.png")
                    let color = UIColor.orange
                    alert.addButton(NSLocalizedString("Take a snap!", comment: ""), target: self, selector: #selector(self.segueToCamera))
                    _ = alert.showCustom(NSLocalizedString("Tip", comment: ""), subTitle: NSLocalizedString("Take a snap of your recent food or import one from your photo library", comment: ""), color: color, icon: icon!)
                    UserDefaultsHandler().setCameraTip(status: true)
                }else
                {
                    self.segueToCamera()
                }
            }else if button.id == "noteAdd"
            {
                
                Analytics.logEvent("Add_WithNote", parameters: nil)
                self.performSegue(withIdentifier: "addNoteSegue", sender: nil)
            }
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
            }
        }
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
        
    }
    
    @IBAction func albumTapped(_ sender: Any)
    {
        localNotification(title: "Test", message: "Test").push()
    }
    
    @objc func segueToCamera()
    {
        Analytics.logEvent("Add_WithCam", parameters: nil)
        self.performSegue(withIdentifier: "showCameraSegue", sender: nil)
    }
    
    func showView() {
        print(coverView.alpha)
        let newValue: CGFloat = coverView.alpha == 0.0 ? 0.75 : 0.0
        UIView.animate(withDuration: 0.35, animations: {
            self.coverView.alpha = newValue
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }
    /*
     var DatabaseCalled = false
     func fetchDatabaseMessage()
     {
     if defaults.getMessageSeen() == false
     {
     var titleOfMessage = ""
     var messageToPresent = ""
     let connectedRef = Database.database().reference(withPath: ".info/connected")
     connectedRef.observe(.value, with: { snapshot in
     if snapshot.value as? Bool ?? false {
     var ref = Database.database().reference()
     ref.child("FaceTappedMessages").observeSingleEvent(of: .value, with:
     { (snapshot) in
     DispatchQueue.main.async
     {
     if !self.DatabaseCalled
     {
     if let value = snapshot.value as? [String:Any]
     {
     if let t = value["title"] as? String
     {
     if t != ""
     {
     titleOfMessage = t
     }
     
     }
     if var m = value["message"] as? String
     {
     if m != ""
     {
     messageToPresent = m
     }
     }
     }
     self.DatabaseCalled = true
     }
     if titleOfMessage != "" && messageToPresent != ""
     {
     SCLAlertMessage(title: titleOfMessage, message: messageToPresent).showMessage()
     }
     self.defaults.setMessageSeen(seen: true)
     }
     }) { (error) in
     print("Error on")
     print(error.localizedDescription)
     }
     } else {
     print("Not connected")
     }
     })
     }
     }*/
    
    func getInteractionMessages()
    {
        messageToUsers.removeAll()
        let mesGenerator = messageGenerator(nList: [self.vegetablePercentage,self.proteinPercentage,self.grainPercentage,self.fruitPercentage,self.dairyPercentage], count: self.recordCount)
        self.messageToUsers += mesGenerator.getMessage()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // Present data and slider only when have data in database
        timestamp = dataHandler.getTimestamp()
        recordCount = timestamp.count
        let recent5nList = dataHandler.get5nList()
        let planStandard = UserDefaultsHandler().getPlanStandard() as? [Double]
        //Existing User
        if recordCount > 0
        {
            if recordCount == 1 && defaults.getHomepageSecondTutorialStatus() == false
            {
                coachversion = 2
                self.coachMarksController.dataSource = self
                self.coachMarksController.start(on: self)
                self.coachMarksController.overlay.allowTap = true
                showStartingMessageToNewUsers = true
            }
            
            if recordCount == 1 && showStartingMessageToNewUsers == false
            {
                showStartingMessageToNewUsers = true
                SCLAlertMessage(title: "Congrats!".localized(), message:  "You've just initialize the indicator, keep recording everyday to get higher balance rates!".localized()).showMessage()
                self.centerFaceArea.alpha = 0
                self.centerInformationArea.alpha = 1
                UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseIn, animations:
                    {
                        self.centerFaceArea.alpha = 1
                        self.centerInformationArea.alpha = 0
                })
            }
            
            
            
            // If some new data is recorded or the user has change their plan
            if recordCount != recentCount || Standard != planStandard! || n_List["grainList"]! != recent5nList["grainList"]! || n_List["vegetableList"]! != recent5nList["vegetableList"]! || n_List["proteinList"]! != recent5nList["proteinList"]! || n_List["dairyList"]! != recent5nList["dairyList"]! || n_List["fruitList"]! != recent5nList["fruitList"]!
            {
                //Update standard
                Standard = planStandard!
                recentCount = recordCount
                // update value via healthpercentagecalculator
                n_List = recent5nList
                var healthData = HealthPercentageCalculator(nutritionDic: n_List, timestamp: timestamp)
                
                // update percentage
                updatePercentageData(totalBalancePercentage: healthData.getLastSevenDaysPercentage(), eachElementPercentage: healthData.getLastSevenDaysEachElementPercentage())
                
                // text below the slider
                informationLabel.text = "Recent Balance: ".localized() + "\(round(healthData.getLastSevenDaysPercentage()*100)/100)%"
                
                // Present the nutrition elements that users needs to intake today
                presentTodayInformation(todayCount: healthData.getTodayEachElementData(), Standard: Standard, dataDate: healthData.getTrimmedDate()[healthData.getTrimmedDate().count - 1])
                
                getInteractionMessages()
                notifyStatus(todayCount: healthData.getTodayEachElementData(), Standard: Standard)
                
                // Present the slider
                showCircularSliderData()
                shake(layer: self.centerFace.layer)
            }
        }else
        {
            // New user
            healthPercentage = 0
            vegetablePercentage = 0
            grainPercentage = 0
            proteinPercentage = 0
            fruitPercentage = 0
            dairyPercentage = 0
            showCircularSliderData()
            presentTodayInformation(Standard: planStandard!)
            informationLabel.text = "No data yet".localized()
        }
    }
    
    func updatePercentageData(totalBalancePercentage: Double, eachElementPercentage: [String:Double])
    {
        healthPercentage = totalBalancePercentage
        vegetablePercentage = eachElementPercentage["V"]!
        grainPercentage = eachElementPercentage["G"]!
        proteinPercentage = eachElementPercentage["P"]!
        fruitPercentage = eachElementPercentage["F"]!
        dairyPercentage = eachElementPercentage["D"]!
    }
    
    @IBAction func handleSwipeup(recognizer:UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.centerFaceArea.alpha = 0
            self.centerInformationArea.alpha = 1
        })
        
    }
    
    @IBAction func handleSwipedown(recognizer:UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self.centerFaceArea.alpha = 1
            self.centerInformationArea.alpha = 0
        })
    }
    
    private func presentTodayInformation(Standard: [Double])
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        let dateOnly = formatter.string(from: date)
        var grainInfo = ""
        var vegetableInfo = ""
        var fruitInfo = ""
        var dairyInfo = ""
        var proteinInfo = ""
        grainInfo = "0.0 / \(Standard[0])"
        vegetableInfo = "0.0 / \(Standard[1])"
        fruitInfo = "0.0 / \(Standard[3])"
        dairyInfo = "0.0 / \(Standard[4])"
        proteinInfo = "0.0 / \(Standard[2])"
        centerInformationArea.text =
            String.localizedStringWithFormat(NSLocalizedString("Today Info\nVege : %@\nProtein : %@\nGrain : %@\nFruit : %@\n Dairy : %@".localized(), comment: ""),"\(vegetableInfo)","\(proteinInfo)","\(grainInfo)","\(fruitInfo)","\(dairyInfo)")
    }
    
    private func presentTodayInformation(todayCount:[Double],Standard:[Double],dataDate:String)
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.string(from: date)
        var grainInfo = ""
        var vegetableInfo = ""
        var fruitInfo = ""
        var dairyInfo = ""
        var proteinInfo = ""
        if dataDate == todayDate
        {
            grainInfo = "\(todayCount[0]) / \(Standard[0])"
            vegetableInfo = "\(todayCount[1]) / \(Standard[1])"
            fruitInfo = "\(todayCount[2]) / \(Standard[3])"
            dairyInfo = "\(todayCount[3]) / \(Standard[4])"
            proteinInfo = "\(todayCount[4]) / \(Standard[2])"
        }else
        {
            grainInfo = "0.0 / \(Standard[0])"
            vegetableInfo = "0.0 / \(Standard[1])"
            fruitInfo = "0.0 / \(Standard[3])"
            dairyInfo = "0.0 / \(Standard[4])"
            proteinInfo = "0.0 / \(Standard[2])"
        }
        
        centerInformationArea.text =
            String.localizedStringWithFormat(NSLocalizedString("Today Info\nVege : %@\nProtein : %@\nGrain : %@\nFruit : %@\n Dairy : %@".localized(), comment: ""),"\(vegetableInfo)","\(proteinInfo)","\(grainInfo)","\(fruitInfo)","\(dairyInfo)")
    }
    
    private func notifyStatus(todayCount:[Double],Standard:[Double])
    {
        var overConsume = ""
        var lackConsume = ""
        var rightPortion = ""
        
        if todayCount[0] >= Standard[0] && todayCount[0] <= Standard[0] + 1.0
        {
            rightPortion = "grain"
        }else if todayCount[1] >= Standard[1] && todayCount[1] <= Standard[1] + 1.0
        {
            rightPortion = "vegetable"
        }else if todayCount[4] >= Standard[2] && todayCount[4] <= Standard[2] + 1.0
        {
            rightPortion = "protein"
        }else if todayCount[2] >= Standard[3] && todayCount[2] <= Standard[3] + 1.0
        {
            rightPortion = "fruit"
        }else if todayCount[3] >= Standard[4] && todayCount[3] <= Standard[4] + 1.0
        {
            rightPortion = "dairy"
        }
        
        if todayCount[0] > Standard[0] + 1.0
        {
            overConsume = "grain"
        }else if todayCount[1] > Standard[1] + 1.0
        {
            overConsume = "vegetable"
        }else if todayCount[4] > Standard[2] + 1.0
        {
            overConsume = "protein"
        }else if todayCount[2] > Standard[3] + 1.0
        {
            overConsume = "fruit"
        }else if todayCount[3] > Standard[4] + 1.0
        {
            overConsume = "dairy"
        }
        
        let overConsumeMessage =
        ["You have hit your target! Well done on eating \(rightPortion)s today!",]
        
        localNotification(title: "Wow", message: overConsumeMessage[0]).push()
    }
    
    func showCircularSliderData()
    {
        setSliderColor(valueP: vegetablePercentage, slider: vegetableCircularSlider)
        setSliderColor(valueP: proteinPercentage, slider: proteinCircularSlider)
        setSliderColor(valueP: grainPercentage, slider: grainCircularSlider)
        setSliderColor(valueP: dairyPercentage, slider: dairyCircularSlider)
        setSliderColor(valueP: fruitPercentage, slider: fruitCircularSlider)
        setSliderColor(valueP: healthPercentage, slider: circularSlider)
    }
    
    func setSliderColor(valueP: Double, slider: KDCircularProgress)
    {
        var value = valueP
        if slider != circularSlider
        {
            // The maximum percentage of each element is 20.0
            value *= 5
        }
        var sliderController = circularSliderDeterminer.init(value: value)
        value = sliderController.getSliderValue()
        slider.animate(toAngle: value, duration: 1.5, completion: nil)
        slider.set(colors: sliderController.getSliderColour())
        slider.trackColor = sliderController.getSliderTrackColour()
        centerFace.setImage(sliderController.getFace(), for: .normal)
    }
    
    /*
     func sendPhoto()
     {
     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
     self.performSegue(withIdentifier: "confirmPhotoSegue", sender: self)
     }
     }
     */
    
    func shake(layer: CALayer)
    {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    @IBAction func faceTapped(_ sender: Any)
    {
        Analytics.logEvent("FaceTapped", parameters: nil)
        playSound()
        if !(messageCounter == messageToUsers.count)
        {
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue-Medium", size: 18)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 16)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 18)!,
                showCloseButton: true
            )
            let alert = SCLAlertView(appearance: appearance)
            let icon = UIImage(named:"Alert_Yellow.png")
            let color = UIColor.orange
            _ = alert.showCustom("FOODY FACE", subTitle: messageToUsers[messageCounter % messageToUsers.count], color: color, icon: icon!)
            messageCounter += 1
        }
        
        if messageCounter == messageToUsers.count
        {
            centerFace.setImage(#imageLiteral(resourceName: "Face_Anonyed"), for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "vegetableDashSegue"
        {
            if let vegeVC = segue.destination as? DashboardViewController
            {
                vegeVC.dashboardType = "Vegetable"
            }
        }else if segue.identifier == "grainDashSegue"
        {
            if let vegeVC = segue.destination as? DashboardViewController
            {
                vegeVC.dashboardType = "Grain"
            }
        }else if segue.identifier == "proteinDashSegue"
        {
            if let vegeVC = segue.destination as? DashboardViewController
            {
                vegeVC.dashboardType = "Protein"
            }
        }else if segue.identifier == "fruitDashSegue"
        {
            if let vegeVC = segue.destination as? DashboardViewController
            {
                vegeVC.dashboardType = "Fruit"
            }
        }else if segue.identifier == "dairyDashSegue"
        {
            if let vegeVC = segue.destination as? DashboardViewController
            {
                vegeVC.dashboardType = "Dairy"
            }
        }else
        {
        }
    }
    
    func playSound()
    {
        guard let url = Bundle.main.url(forResource: "popSound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            
            // For iOS 11
            if #available(iOS 11.0, *)
            {
                objPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            }
            else{
                // For iOS versions < 11
                
                objPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            }
            
            guard let aPlayer = objPlayer else { return }
            aPlayer.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension homepageViewController: CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        if coachversion == 1
        {
            switch(index) {
            case 0:
                coachViews.bodyView.hintLabel.text = "Start to use the app by adding your recent food now!".localized()
                coachViews.bodyView.nextLabel.text = "Start!".localized()
            default: break
            }
            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        }else
        {
            // update value via healthpercentagecalculator
            let nutritionDic = dataHandler.get5nList()
            var healthData = HealthPercentageCalculator(nutritionDic: nutritionDic, timestamp: timestamp)
            let todayCount = healthData.getTodayEachElementData()
            switch(index) {
            case 0:
                // coachViews.bodyView.hintLabel.text = "Check your indicator to know how balanced your overall diet was".localized()
                
                coachViews.bodyView.hintLabel.text = String.localizedStringWithFormat(NSLocalizedString("You still need to eat %@ grains, %@ vegetables, %@ fruits, %@ dairies and %@ proteins to get 100 percent today".localized(), comment: ""),"\(Standard[0] - todayCount[0])","\(Standard[1] - todayCount[1])","\(Standard[3] - todayCount[2])","\(Standard[4] - todayCount[3])","\(Standard[2] - todayCount[4])")
                coachViews.bodyView.nextLabel.text = "Next".localized()
            case 1:
                coachViews.bodyView.hintLabel.text = "The face's emotion has 4 states, indicates Bad, Good, Happy, and Great. Tap on it for some surprise".localized()
                coachViews.bodyView.nextLabel.text = "Next".localized()
            case 2:
                coachViews.bodyView.hintLabel.text = "Swipe up to get diet information for today".localized()
                coachViews.bodyView.nextLabel.text = "Next".localized()
            case 3:
                coachViews.bodyView.hintLabel.text = "Tap on each of the icons to find out more about that group!".localized()
                coachViews.bodyView.nextLabel.text = "OK".localized()
            default: break
            }
            return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        }
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        if coachversion == 1
        {
            switch(index)
            {
            case 0:
                defaults.setHomepageTutorialStatus(status: true)
                return coachMarksController.helper.makeCoachMark(for: self.fanMenu)
            default:
                return coachMarksController.helper.makeCoachMark()
            }
        }else
        {
            switch(index)
            {
            case 0:
                return coachMarksController.helper.makeCoachMark(for: self.circularSlider)
            case 1:
                self.centerFaceArea.alpha = 1
                self.centerInformationArea.alpha = 0
                return coachMarksController.helper.makeCoachMark(for: self.centerFaceArea)
            case 2:
                self.centerFaceArea.alpha = 0
                self.centerInformationArea.alpha = 1
                return coachMarksController.helper.makeCoachMark(for: self.centerFaceArea)
            case 3:
                self.centerFaceArea.alpha = 1
                self.centerInformationArea.alpha = 0
                defaults.setHomepageSecondTutorialStatus(status: true)
                showStartingMessageToNewUsers = false
                return coachMarksController.helper.makeCoachMark(for: self.foodgroupsStackView)
            default:
                return coachMarksController.helper.makeCoachMark()
            }
        }
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        
        if coachversion == 1
        {
            return 1
        }else
        {
            return 4
        }
    }
}

