//
//  CustomizedPlanSettingViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 20/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//
import UIKit
import Former
import SCLAlertView

class CustomizedPlanSettingViewController: FormViewController {
    
    var age: Int = 0
    var weight: Int = 0
    var height: Int = 0
    var gender: Int = 0
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locale = NSLocale.current.languageCode
        if (locale! == "zh")
        {
            doneButton.setImage(#imageLiteral(resourceName: "zh_Button_Donne"), for: .normal)
        }
        
        if let personaldata = UserDefaultsHandler().getPersonalData() as? [String: Int]
        {
            gender = personaldata["Gender"]!
            weight = personaldata["Weight"]!
            height = personaldata["Height"]!
            age = personaldata["Age"]!
            print(personaldata)
        }else
        {
        }
        
        let sexSegmented = SegmentedRowFormer<FormSegmentedCell>()
        {
            $0.titleLabel.text = "Gender".localized()
            }.configure { row in
                row.segmentTitles = ["Female".localized(), "Male".localized()]
                row.selectedIndex = gender
                
            }.onSegmentSelected { (item, sex) in
                self.gender = item
        }
        
        let agePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            $0.titleLabel.text = "Age".localized()
            }.configure {
                $0.pickerItems = [InlinePickerItem(
                    title: "Not set".localized(),
                    displayTitle: NSAttributedString(string: "\(age)"),
                    value: nil)]
                    + (14...140).map { InlinePickerItem(title: "\($0)", displayTitle: NSAttributedString(string: "\($0)"), value: Int($0)) }
            }.onValueChanged { item in
                if let age = item.value
                {
                    self.age = age
                }
        }
        
        let heightPickerRow = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            $0.titleLabel.text = "Height".localized()
            }.configure {
                $0.pickerItems = [InlinePickerItem(
                    title: "Not set".localized(),
                    displayTitle: NSAttributedString(string: "\(height) cm"),
                    value: nil)]
                    + (140...240).map { InlinePickerItem(title: "\($0) cm", displayTitle: NSAttributedString(string: "\($0) cm"), value: Int($0)) }
            }.onValueChanged { item in
                if let height = item.value
                {
                    self.height = height
                }
        }
        let weightPickerRow = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            $0.titleLabel.text = "Weight".localized()
            }.configure {
                $0.pickerItems = [InlinePickerItem(
                    title: "Not set".localized(),
                    displayTitle: NSAttributedString(string: "\(weight) kg"),
                    value: nil)]
                    + (30...150).map { InlinePickerItem(title: "\($0) kg", displayTitle: NSAttributedString(string: "\($0)"), value: Int($0)) }
            }.onValueChanged { item in
                if let weight = item.value
                {
                    self.weight = weight
                }
        }
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        
        let section = SectionFormer(rowFormer: sexSegmented, agePickerRow,heightPickerRow,weightPickerRow)
            .set(headerViewFormer: createHeader("Personal Information for plan setting".localized()))
        former.append(sectionFormer: section)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if(age == 0 || weight == 0 || height == 0)
        {
            SCLAlertMessage(title: "One of your information might be wrong".localized(), message: "Please go back to the page to check your information again. Your information is not recorded".localized()).showMessage()
        }
        else
        {
            saveInformation()
        }
    }
    
    func saveInformation()
    {
        var g = "Female"
        if gender == 1
        {
            g = "Male"
        }
        let calorie = calorieDeterminer(sex: g, age: Double(age), weight: Double(weight), height: Double(height)).getCalculateCalorie()
        let planCalculator = personalisePlanCalculator(calorie: calorie)
        let plan = planCalculator.getPlan()
        UserDefaultsHandler().setPlanStandard(value: plan)
        UserDefaultsHandler().setPersonalData(value: ["Gender": gender, "Age":age,"Weight":weight,"Height": height])
        if !fromOnboarding
        {
//            SCLAlertMessage(title: "Plan Set", message: "According to your information, your plan will be taking \(plan[0]) portions of grain, \(plan[1]) portions of vegetable, \(plan[2]) portions of protein, \(plan[3]) portions of fruit, \(plan[4]) portions of dairy").showMessage()
            SCLAlertMessage(title: "Plan Set".localized(), message: String.localizedStringWithFormat(NSLocalizedString("According to your information, your plan will be taking \n%@ portions of grain,\n%@ portions of vegetable,\n%@ portions of protein,\n%@ portions of fruit,\n%@ portions of dairy", comment: ""),"\(plan[0])","\(plan[1])","\(plan[2])","\(plan[3])","\(plan[4])")).showMessage()
        }else
        {
            if !infoShown
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
            alert.addButton("Ready to explore".localized(), target: self, selector: #selector(self.showHome))
            _ = alert.showCustom("Plan Set".localized(), subTitle: String.localizedStringWithFormat(NSLocalizedString("According to your information, your plan will be taking \n%@ portions of grain,\n%@ portions of vegetable,\n%@ portions of protein,\n%@ portions of fruit,\n%@ portions of dairy", comment: ""),"\(plan[0])","\(plan[1])","\(plan[2])","\(plan[3])","\(plan[4])"), color: color, icon: icon!)
                infoShown = true
            }
        }
        
    }
    
    var fromOnboarding = false
    var infoShown = false
    
    @IBAction func doneTapped(_ sender: Any)
    {
        fromOnboarding = true
        if(age == 0)
        {
            SCLAlertMessage(title: "Oops".localized(), message: "Please recheck if your age is correct".localized()).showMessage()
        }else if (weight == 0)
        {
            SCLAlertMessage(title: "Oops".localized(), message: "Please recheck if your weight is correct".localized()).showMessage()
        }else if (height == 0)
        {
            SCLAlertMessage(title: "Oops".localized(), message: "Please recheck if your height is correct".localized()).showMessage()
        }else
        {
            UserDefaultsHandler().setOnboardingStatus(status: true)
            saveInformation()
        }
    }
    
    @objc func showHome()
    {
        performSegue(withIdentifier: "showHomeSegue", sender: nil)
    }
    
}

