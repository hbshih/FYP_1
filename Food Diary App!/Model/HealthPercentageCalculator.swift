//
//  HealthPercentageCalculator.swift
//  Food Diary App!
//
//  Created by Ben Shih on 30/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation

struct HealthPercentageCalculator
{
    // General Variables
    private var fileName: [String] = [] // Storing the names of the images to get images
    
    // Nutrition Info Variables
    var dairyList: [Double] = []
    var vegetableList: [Double] = []
    var proteinList: [Double] = []
    var fruitList: [Double] = []
    var grainList: [Double] = []
    
    // The daily food balance standard
    private var userPlan: [Double] = []
    private var vegetableStandard = 4.0
    private var fruitStandard = 3.0
    private var grainStandard = 6.0
    private var dairyStandard = 3.0
    private var proteinStandard = 3.0
    
    //Save the date the user record on
    private var dateSaved: [String] = []
    //The total count of each nutrition element in each day.
    private var dayCountVegetable: [Double] = []
    private var dayCountProtein: [Double] = []
    private var dayCountFruit: [Double] = []
    private var dayCountGrain: [Double] = []
    private var dayCountDairy: [Double] = []
    private var dayBalancePercentage: [Double] = []
    
    private var averageHealth: Double = 0.0
    private var averageVegetable = 0.0
    private var averageGrain = 0.0
    private var averageProtein = 0.0
    private var averageFruit = 0.0
    private var averageDairy = 0.0
    
    
    
    init(fileNames: [String], nutritionDic:[String:[Double]])
    {
        /*
         * Access user defaults
         */
        var defaults = UserDefaultsHandler()
        let userPlan = defaults.getPlanStandard() as! [Double]
        
        //-- Set Standard
        grainStandard = userPlan[0]
        vegetableStandard = userPlan[1]
        fruitStandard = userPlan[2]
        dairyStandard = userPlan[3]
        proteinStandard = userPlan [4]
        
        self.fileName = getTrimmedDate(Name: fileNames)
        if fileName.count > 0
        {
            dairyList = nutritionDic["dairyList"]!
            vegetableList = nutritionDic["vegetableList"]!
            proteinList = nutritionDic["proteinList"]!
            fruitList = nutritionDic["fruitList"]!
            grainList = nutritionDic["grainList"]!
            calculateOverallHealthRate()
        }else
        {
            print("Nothing is inside")
        }
    }
    
    private mutating func calculateOverallHealthRate()
    {
        calculateEachElementDailyTotalCount()
        convertDailyCountIntoBalancePercentage()
        getAverageOfEachElement()
    }
    
    private mutating func calculateEachElementDailyTotalCount()
    {
        var v = 0.0
        var d = 0.0
        var g = 0.0
        var p = 0.0
        var f = 0.0
        
        for i in 0 ..< fileName.count - 1
        {
            if fileName[i] == fileName[i + 1]
            {
                v += vegetableList[i]
                p += proteinList [i]
                d += dairyList [i]
                f += fruitList [i]
                g += grainList [i]
                if i + 1 == fileName.count - 1
                {
                    v += vegetableList[i+1]
                    p += proteinList [i+1]
                    d += dairyList [i+1]
                    f += fruitList [i+1]
                    g += grainList [i+1]
                    dateSaved.append(fileName[i])
                    dayCountVegetable.append(Double(v))
                    dayCountGrain.append(Double(g))
                    dayCountFruit.append(Double(f))
                    dayCountProtein.append(Double(p))
                    dayCountDairy.append(Double(d))
                }
            }else
            {
                v += vegetableList [i]
                p += proteinList [i]
                d += dairyList [i]
                f += fruitList [i]
                g += grainList [i]
                dateSaved.append(fileName[i])
                dayCountVegetable.append(Double(v))
                dayCountGrain.append(Double(g))
                dayCountFruit.append(Double(f))
                dayCountProtein.append(Double(p))
                dayCountDairy.append(Double(d))
                v = 0
                d = 0
                p = 0
                f = 0
                g = 0
                if i + 1 == fileName.count - 1
                {
                    v += vegetableList[i+1]
                    p += proteinList [i+1]
                    d += dairyList [i+1]
                    f += fruitList [i+1]
                    g += grainList [i+1]
                    dateSaved.append(fileName[i + 1])
                    dayCountVegetable.append(Double(v))
                    dayCountGrain.append(Double(g))
                    dayCountFruit.append(Double(f))
                    dayCountProtein.append(Double(p))
                    dayCountDairy.append(Double(d))
                }
            }
        }
        print("Date: \(dateSaved)")
        print("DaycountOfVege: \(dayCountVegetable)")
        print("DaycountOfVege: \(dayCountGrain)")
        print("DaycountOfVege: \(dayCountProtein)")
        print("DaycountOfVege: \(dayCountFruit)")
        print("DaycountOfVege: \(dayCountDairy)")
    }
    
    private mutating func convertDailyCountIntoBalancePercentage()
    {
        for i in 0 ..< dateSaved.count
        {
            dayCountVegetable[i] = ((dayCountVegetable[i] / vegetableStandard)*100).rounded()
            if dayCountVegetable[i] > 20.0
            {
                dayCountVegetable[i] = 20.0
            }
            dayCountDairy[i] = ((dayCountDairy[i] / dairyStandard)*100).rounded()
            if dayCountDairy[i] > 20
            {
                dayCountDairy[i] = 20
            }
            dayCountProtein[i] = ((dayCountProtein[i] / proteinStandard)*100).rounded()
            if dayCountProtein[i] > 20
            {
                dayCountProtein[i] = 20
            }
            dayCountFruit[i] = ((dayCountFruit[i] / fruitStandard)*100).rounded()
            if dayCountFruit[i] > 20
            {
                dayCountFruit[i] = 20
            }
            dayCountGrain[i] = ((dayCountGrain[i] / grainStandard)*100).rounded()
            if dayCountGrain[i] > 20
            {
                dayCountGrain[i] = 20
            }
            dayBalancePercentage.append((dayCountGrain[i] + dayCountFruit[i] + dayCountProtein[i] + dayCountDairy[i] + dayCountVegetable[i]))
        }
        print("###")
        print("DaycountOfVege: \(dayCountVegetable)")
        print("DaycountOfG: \(dayCountGrain)")
        print("DaycountOfP: \(dayCountProtein)")
        print("DaycountOfF: \(dayCountFruit)")
        print("DaycountOfD: \(dayCountDairy)")
        print("Average: \(dayBalancePercentage)")
    }
    
    private mutating func getAverageOfEachElement()
    {
        var sum = 0.0
        var sumv = 0.0
        var sumg = 0.0
        var sump = 0.0
        var sumf = 0.0
        var sumd = 0.0
        
        for i in 0 ..< dayBalancePercentage.count
        {
            sum += dayBalancePercentage[i]
            sumv += dayCountVegetable[i]
            sumd += dayCountDairy[i]
            sump += dayCountProtein[i]
            sumf += dayCountFruit[i]
            sumg += dayCountGrain[i]
        }
        
        averageHealth = sum / Double(dayBalancePercentage.count)
        averageVegetable = sumv / Double(dayBalancePercentage.count)
        averageDairy = sumd / Double(dayBalancePercentage.count)
        averageFruit = sumf / Double(dayBalancePercentage.count)
        averageProtein = sump / Double(dayBalancePercentage.count)
        averageGrain = sumg / Double(dayBalancePercentage.count)
    }
    
    mutating func getTrimmedDate(Name: [String]) -> [String]
    {
        if Name.count > 0
        {
        var newFileName: [String] = []
        for i in 0 ..< Name.count
        {
            let str = Name[i].prefix(13)
            let date = str.suffix(10)
            newFileName.append(String(date))
        }
        return newFileName
        }else
        {
            return []
        }
    }
    
    mutating func getTrimmedDate() -> [String]
    {
        return dateSaved
    }
    
    mutating func getDayBalancePercentage() -> [Double]
    {
        return dayBalancePercentage
    }
    
    mutating func getElementPercentage() -> [String:Double]
    {
        return ["Vegetable":averageVegetable,"Grain":averageGrain,"Protein":averageProtein,"Fruit":averageFruit,"Dairy":averageDairy]
    }
    
    mutating func getAverageHealth() -> Double
    {
        return averageHealth
    }
    
    mutating func getEachNutritionHealthAverage() -> [String: Double]
    {
        return ["averageVegetable": averageVegetable, "averageGrain": averageGrain, "averageProtein": averageProtein, "averageFruit": averageFruit,"averageDairy": averageDairy]
    }
}
