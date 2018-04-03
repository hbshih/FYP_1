//
//  DayViewDiaryViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 31/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import UIKit

class DayViewDiaryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var checkTodayDiary: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var grainLabel: UILabel!
    @IBOutlet weak var ProteinLabel: UILabel!
    @IBOutlet weak var FruitLabel: UILabel!
    @IBOutlet weak var VegetableLabel: UILabel!
    @IBOutlet weak var DairyLabel: UILabel!
    @IBOutlet weak var emotionFace: UIImageView!
    @IBOutlet weak var recentTableView: UITableView!
    private var dataHandler = CoreDataHandler()
    private let userDefault = UserDefaultsHandler()
    private var nutriCalculation: HealthPercentageCalculator?
    private let showDayDetail = ""
    private var lookingDate = ""
    
    private var Standard = [0.0,0.0,0.0,0.0,0.0]
    private var todayCount = [0.0,0.0,0.0,0.0,0.0]
    private var eachDayPercentage: [Double] = []
    
    private var dateSaved: [String] = []
    
    // Nutrition Info Variables
    var dairyList: [Double] = []
    var vegetableList: [Double] = []
    var proteinList: [Double] = []
    var fruitList: [Double] = []
    var grainList: [Double] = []
    
    private var todayHasRecord = 0
    
    private var loadListcount = 0
    
    
    let format = DateFormatter()
    private var notes: [String] = [] // Storing notes
    private var dates: [Date] = [] // Storing dates
    private var id: [String] = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        recentTableView.delegate = self
        recentTableView.dataSource = self
        dates = dataHandler.getTimestamp()
        notes = dataHandler.getNote()
        id = dataHandler.getId()
        
        if id.count > 0
        {
            let nutritionDic = dataHandler.get5nList()
            nutriCalculation = HealthPercentageCalculator(nutritionDic: nutritionDic, timestamp: dataHandler.getTimestamp())
            let dayNutritionList = nutriCalculation?.getEachDayCount()
            
            dairyList = dayNutritionList!["Dairy"]!
            vegetableList = dayNutritionList!["Vegetable"]!
            proteinList = dayNutritionList!["Protein"]!
            fruitList = dayNutritionList!["Fruit"]!
            grainList = dayNutritionList!["Grain"]!
            eachDayPercentage = nutriCalculation!.getDayBalancePercentage()
            dateSaved = (nutriCalculation?.getDateOfRecord())!
            
            Standard = userDefault.getPlanStandard() as! [Double]
            
            //-- to display the most up to date items first
            dates = dates.reversed()
            dateSaved = dateSaved.reversed()
            notes = notes.reversed()
            id = id.reversed()
            fruitList = fruitList.reversed()
            dairyList = dairyList.reversed()
            vegetableList = vegetableList.reversed()
            proteinList = proteinList.reversed()
            grainList = grainList.reversed()
            eachDayPercentage = eachDayPercentage.reversed()
            
            format.dateFormat = "yyyy-MM-dd"
            if format.string(from: dates[0]) == format.string(from: Date())
            {
                todayHasRecord = 1
            }
            // Main Function
            todayDiary()
            loadListcount = id.count
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        dates = dataHandler.getTimestamp()
        notes = dataHandler.getNote()
        id = dataHandler.getId()
        
        
        if id.count > 0 && id.count != loadListcount
        {
            let nutritionDic = dataHandler.get5nList()
            nutriCalculation = HealthPercentageCalculator(nutritionDic: nutritionDic, timestamp: dataHandler.getTimestamp())
            let dayNutritionList = nutriCalculation?.getEachDayCount()
            
            dairyList = dayNutritionList!["Dairy"]!
            vegetableList = dayNutritionList!["Vegetable"]!
            proteinList = dayNutritionList!["Protein"]!
            fruitList = dayNutritionList!["Fruit"]!
            grainList = dayNutritionList!["Grain"]!
            eachDayPercentage = nutriCalculation!.getDayBalancePercentage()
            dateSaved = (nutriCalculation?.getDateOfRecord())!
            
            Standard = userDefault.getPlanStandard() as! [Double]
            
            //-- to display the most up to date items first
            dates = dates.reversed()
            dateSaved = dateSaved.reversed()
            notes = notes.reversed()
            id = id.reversed()
            fruitList = fruitList.reversed()
            dairyList = dairyList.reversed()
            vegetableList = vegetableList.reversed()
            proteinList = proteinList.reversed()
            grainList = grainList.reversed()
            eachDayPercentage = eachDayPercentage.reversed()
            
            format.dateFormat = "yyyy-MM-dd"
            if format.string(from: dates[0]) == format.string(from: Date())
            {
                todayHasRecord = 1
            }
            // Main Function
            todayDiary()
            recentTableView.reloadData()
        }
    }
    
    func todayDiary()
    {
        if todayHasRecord == 1
        {
            let todayPercentage = eachDayPercentage[0]
            todayCount = nutriCalculation!.getTodayEachElementData()
            balanceLabel.text = "\(todayPercentage)% " + "Balance"
            grainLabel.text = "\(todayCount[0]) / \(Standard[0]) " + "Grain"
            VegetableLabel.text = "\(todayCount[1]) / \(Standard[1]) " + "Vegetable"
            FruitLabel.text = "\(todayCount[2]) / \(Standard[3]) " + "Fruit"
            DairyLabel.text = "\(todayCount[3]) / \(Standard[4]) " + "Dairy"
            ProteinLabel.text = "\(todayCount[4]) / \(Standard[2]) " + "Protein"
            
            if todayPercentage < 20.0
            {
                emotionFace.image = #imageLiteral(resourceName: "Face_Red")
            }else if todayPercentage >= 20.0 && todayPercentage < 60.0
            {
                emotionFace.image = #imageLiteral(resourceName: "Face_Yellow")
            }else if todayPercentage >= 60.0 && todayPercentage < 80.0
            {
                emotionFace.image = #imageLiteral(resourceName: "Face_Green")
            }else
            {
                emotionFace.image = #imageLiteral(resourceName: "Face_Orange")
            }
            
        }else
        {
            balanceLabel.text = "No Entry Yet!"
            grainLabel.text = "0 / \(Standard[0]) " + "Grain"
            VegetableLabel.text = "0 / \(Standard[1]) " + "Vegetable"
            FruitLabel.text = "0 / \(Standard[3]) " + "Fruit"
            DairyLabel.text = "0 / \(Standard[4]) " + "Dairy"
            ProteinLabel.text = "0 / \(Standard[2]) " + "Protein"
            emotionFace.image = #imageLiteral(resourceName: "Face_Sleep")
        }
    }
    @IBAction func todayTapped(_ sender: Any)
    {
        if todayHasRecord == 1
        {
            format.dateFormat = "yyyy-MM-dd"
            lookingDate = format.string(from: Date())
            performSegue(withIdentifier: "diarySegue", sender: nil)
        }else
        {
            SCLAlertMessage(title: "Oops", message: "You don't have any records today").showMessage()
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("Number of row")
        print(dateSaved.count - todayHasRecord)
        return dateSaved.count - todayHasRecord
    }
    
    @IBAction func checkAllDetailTapped(_ sender: Any)
    {
        lookingDate = "All"
        performSegue(withIdentifier: "diarySegue", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DayViewDairyTableViewCell

        print("table")
        print(dateSaved)
        print(todayHasRecord)
        if dateSaved.count > todayHasRecord
        {
            if (eachDayPercentage[indexPath.row + todayHasRecord] < 60)
            {
                cell?.metalPrize.alpha = 0
            }
            cell?.dateAndTime.text = "\(dateSaved[indexPath.row + todayHasRecord])"
            cell?.balance.text = "\(eachDayPercentage[indexPath.row + todayHasRecord])% " + "Balance"
            cell?.grainInfo.text = "\(grainList[indexPath.row + todayHasRecord]) / \(Standard[0])"
            cell?.vegetableInfo.text = "\(vegetableList[indexPath.row + todayHasRecord]) / \(Standard[1])"
            cell?.proteinInfo.text = "\(proteinList[indexPath.row + todayHasRecord]) / \(Standard[2])"
            cell?.fruitInfo.text = "\(fruitList[indexPath.row + todayHasRecord]) / \(Standard[3])"
            cell?.dairyInfo.text = "\(dairyList[indexPath.row + todayHasRecord]) / \(Standard[4])"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        lookingDate = dateSaved[indexPath.row + todayHasRecord]
        performSegue(withIdentifier: "diarySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "diarySegue"
        {
            if let vc = segue.destination as? DiaryTableViewController
            {
                vc.showRecord = lookingDate
            }
        }
    }
}
