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
import YPImagePicker

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
    @IBOutlet weak var cameraButtonOutlet: UIButton!
    @IBOutlet weak var centerInformationView: UIView!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    // Variables to store percentage informations
    private var healthPercentage = 0.0
    private var vegetablePercentage = 0.0
    private var dairyPercentage = 0.0
    private var fruitPercentage = 0.0
    private var proteinPercentage = 0.0
    private var grainPercentage = 0.0
    
    // General Variables
    private var images: [UIImage] = [] // Storing Images
    private var fileName: [String] = [] // Storing the names of the images to get images
    private var currentNames: [String] = []
    private var notes: [String] = [] // Storing notes
    private var messageCounter = 0
    private var messageToUsers = ["You just poked my face, don't do that","My face is not a button. Tapping it does abosolutely nothing except irritate me","I know I conditioned you to tap my face in my counterpart apps, but I'm really serious: it doesn't do anything this time","Yet you're still poking my face","There are lots of other fun things you could be doing with this app right now instead of poking my face.","You could go seeing your recent foods, for example","But apparently poking my face is more enjoyable","Please stop - you'll make my face dirty","When's the last time you washed your hands, anyhow?","Why don't you go wash your hand?","You didn't take my advice, I can tell","Tapping my face isn't anywhere near as amusing as you think it is","You see, I have a great sense of humor"]
    private var showStartingMessageToNewUsers = false
    
    private var Standard = [0.0,0.0,0.0,0.0,0.0]
    
    // Access Data
    private var dataHandler = CoreDataHandler()
    let defaults = UserDefaultsHandler()
    
    // For tutorial walkthrough
    let coachMarksController = CoachMarksController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        centerInformationArea.alpha = 0
        if defaults.getHomepageTutorialStatus() == true
        {
            /*Existing user, watched tutorial already*/
        }else
        {
            /*New User*/
            self.coachMarksController.dataSource = self
            self.coachMarksController.start(on: self)
            self.coachMarksController.overlay.allowTap = true
            let skipView = CoachMarkSkipDefaultView()
            skipView.setTitle("Skip", for: .normal)
            self.coachMarksController.skipView = skipView
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.coachMarksController.stop(immediately: true)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        // Present data and slider only when have data in database
        fileName = dataHandler.getImageFilename()
        let planStandard = UserDefaultsHandler().getPlanStandard() as? [Double]
        //Existing User
        if fileName.count > 0
        {
            if fileName.count == 1 && showStartingMessageToNewUsers == false
            {
                showStartingMessageToNewUsers = true
                SCLAlertMessage(title: "Congrats!", message:  "You've just initialize the indicator, keep recording everyday to get higher balance rates!").showMessage()
                self.centerFaceArea.alpha = 0
                self.centerInformationArea.alpha = 1
                UIView.animate(withDuration: 0.5, delay: 10, options: .curveEaseIn, animations: {
                    self.centerFaceArea.alpha = 1
                    self.centerInformationArea.alpha = 0
                })
            }
            // If some new data is recorded
            if fileName.count != currentNames.count || Standard != planStandard!
            {
                //Update standard
                Standard = planStandard!
                
                currentNames = fileName
                
                // update value via healthpercentagecalculator
                let nutritionDic = dataHandler.get5nList()
                var healthData = HealthPercentageCalculator(fileNames: fileName,nutritionDic: nutritionDic)
                
                // update percentage
                updatePercentageData(totalBalancePercentage: healthData.getLastSevenDaysPercentage(), eachElementPercentage: healthData.getLastSevenDaysEachElementPercentage())
                
                // text below the slider
                informationLabel.text = "7-Days Balance: \(round(healthData.getLastSevenDaysPercentage()*100)/100)%"
                
                // Present the nutrition elements that users needs to intake today
                presentTodayInformation(todayCount: healthData.getTodayEachElementData(), Standard: Standard, dataDate: healthData.getTrimmedDate()[healthData.getTrimmedDate().count - 1])
                
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
            informationLabel.text = "No data yet"
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
        "\(dateOnly)\nVege : \(vegetableInfo)\nProtein : \(proteinInfo)\nGrain : \(grainInfo)\nFruit : \(fruitInfo)\n Dairy : \(dairyInfo)"
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
        "Today Info\nVege : \(vegetableInfo)\nProtein : \(proteinInfo)\nGrain : \(grainInfo)\nFruit : \(fruitInfo)\n Dairy : \(dairyInfo)"
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
        print("----------")
        print(valueP)
        var value = valueP
        if slider != circularSlider
        {
            // The maximum percentage of each element is 20.0
            value *= 5
        }
        print(slider)
        print(value)
        var sliderController = circularSliderDeterminer.init(value: value)
        value = sliderController.getSliderValue()
        print(value)
        slider.animate(toAngle: value, duration: 1.5, completion: nil)
        slider.set(colors: sliderController.getSliderColour())
        print(sliderController.getSliderValue())
        slider.trackColor = sliderController.getSliderTrackColour()
        
        /*
        if value == 0.0 && slider == circularSlider
        {
            slider.set(colors: UIColor(red:0.99, green:0.82, blue:0.39, alpha:1.0))
            slider.trackColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:0.2)
            if slider == circularSlider {centerFace.setImage(UIImage(named: "Face_Yellow.png"), for: .normal)}
        }else
        {
            if value > 0 && value <= 75
            {
                slider.set(colors: UIColor(red:0.99, green:0.44, blue:0.39, alpha:1.0))
                slider.trackColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:0.2)
                if slider == circularSlider
                {centerFace.setImage(UIImage(named: "Face_Sad.png"), for: .normal);print("I am slider : \(slider)")}
            }// Yellow -- Neutral
            else if value > 75 && value <= 225
            {
                slider.set(colors: UIColor(red:0.99, green:0.82, blue:0.39, alpha:1.0))
                slider.trackColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:0.2)
                if slider == circularSlider {centerFace.setImage(UIImage(named: "Face_Yellow.png"), for: .normal)}
            }
                // Blue -- Good
            else if value > 225 && value <= 300
            {
                slider.set(colors:UIColor(red:0.39, green:0.82, blue:0.99, alpha:1.0))
                slider.trackColor = UIColor(red:0.39, green:0.82, blue:0.99, alpha:0.2)
                if slider == circularSlider {centerFace.setImage(UIImage(named: "Face_Happy.png"), for: .normal)}
            }else if value > 300 && value <= 360
            {
                slider.set(colors: UIColor(red:0.60, green:0.80, blue:0.29, alpha:1.0))
                slider.trackColor = UIColor(red:0.60, green:0.80, blue:0.29, alpha:0.2)
                if slider == circularSlider {centerFace.setImage(UIImage(named: "Face_Smile.png"), for: .normal)}
            }
        }*/
    }
    
    func sendPhoto()
    {
        print("SEND!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: "confirmPhotoSegue", sender: self)
        }
    }
    
    
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
        let appearance = SCLAlertView.SCLAppearance(
            //kCircleIconHeight: 55.0
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
}

// MARK: - Protocol Conformance | CoachMarksControllerDataSource
extension homepageViewController: CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        switch(index) {
        case 0:
            coachViews.bodyView.hintLabel.text = "Check your indicator to know how balanced your overall diet was"
            coachViews.bodyView.nextLabel.text = "Next"
        case 1:
            coachViews.bodyView.hintLabel.text = "Swipe up to get diet information / recommendation for today."
            coachViews.bodyView.nextLabel.text = "Next"
        case 2:
            coachViews.bodyView.hintLabel.text = "Tap on each of the 5 food groups to find out individual balance"
            coachViews.bodyView.nextLabel.text = "Next"
        case 3:
            coachViews.bodyView.hintLabel.text = "Explore more by adding your food now!"
            coachViews.bodyView.nextLabel.text = "Start!"
        default: break
        }
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch(index)
        {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: self.circularSlider)
        case 1:
            self.centerFaceArea.alpha = 0
            self.centerInformationArea.alpha = 1
            return coachMarksController.helper.makeCoachMark(for: self.centerFaceArea)
        case 2:
            self.centerFaceArea.alpha = 1
            self.centerInformationArea.alpha = 0
            return coachMarksController.helper.makeCoachMark(for: self.foodgroupsStackView)
        case 3:
            UserDefaultsHandler().setHomepageTutorialStatus(status: true)
            return coachMarksController.helper.makeCoachMark(for: self.cameraButtonOutlet)
        default:
            return coachMarksController.helper.makeCoachMark()
        }
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 4
    }
}

