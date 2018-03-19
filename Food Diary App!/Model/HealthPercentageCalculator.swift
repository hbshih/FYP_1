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
    private var vegetableStandard : Double
    private var fruitStandard : Double
    private var grainStandard : Double
    private var dairyStandard : Double
    private var proteinStandard : Double
    
    //Save the date the user record on
    private var dateSaved: [String] = []
    //The total count of each nutrition element in each day.
    private var dayCountVegetable: [Double] = []
    private var dayCountProtein: [Double] = []
    private var dayCountFruit: [Double] = []
    private var dayCountGrain: [Double] = []
    private var dayCountDairy: [Double] = []
    
    private var dayCountVegetablePercentage: [Double] = []
    private var dayCountProteinPercentage: [Double] = []
    private var dayCountFruitPercentage: [Double] = []
    private var dayCountGrainPercentage: [Double] = []
    private var dayCountDairyPercentage: [Double] = []
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
        let defaults = UserDefaultsHandler()
        let userPlan = defaults.getPlanStandard() as! [Double]
        
        //-- Set Standard
        grainStandard = userPlan[0]
        vegetableStandard = userPlan[1]
        proteinStandard = userPlan [2]
        fruitStandard = userPlan[3]
        dairyStandard = userPlan[4]
        
        self.fileName = getTrimmedDate(Name: fileNames)
//        self.fileName = self.fileName.sorted()
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
        var keepTrackIndex = 0
        if fileName.count > 0
        {
            
            for i in 0 ..< fileName.count
            {
                if !dateSaved.contains(fileName[i])
                {
                    dateSaved.append(fileName[i])
                    dayCountDairy.append(dairyList[i])
                    dayCountFruit.append(fruitList[i])
                    dayCountGrain.append(grainList[i])
                    dayCountProtein.append(proteinList[i])
                    dayCountVegetable.append(vegetableList[i])
                    keepTrackIndex = dateSaved.count - 1
                }else
                {
                    dayCountDairy[keepTrackIndex] = dayCountDairy[keepTrackIndex] + dairyList[i]
                    dayCountFruit[keepTrackIndex] = dayCountFruit[keepTrackIndex] + fruitList[i]
                    dayCountGrain[keepTrackIndex] = dayCountGrain[keepTrackIndex] + grainList[i]
                    dayCountProtein[keepTrackIndex] = dayCountProtein[keepTrackIndex] + proteinList[i]
                    dayCountVegetable[keepTrackIndex] = dayCountVegetable[keepTrackIndex] + vegetableList[i]
                }
            }
        }
        print("Date: \(dateSaved)")
        print("Daycount Of Vege: \(dayCountVegetable)")
        print("Daycount Of Grain: \(dayCountGrain)")
        print("Daycount Of Protein: \(dayCountProtein)")
        print("Daycount Of Fruit: \(dayCountFruit)")
        print("Daycount Of Dairy: \(dayCountDairy)")
    }
    
    private mutating func convertDailyCountIntoBalancePercentage()
    {
        dayCountVegetablePercentage = dayCountVegetable
        dayCountProteinPercentage = dayCountProtein
        dayCountFruitPercentage = dayCountFruit
        dayCountGrainPercentage = dayCountGrain
        dayCountDairyPercentage = dayCountDairy
        
        for i in 0 ..< dateSaved.count
        {
            if dayCountVegetablePercentage[i] > 0.0
            {
                dayCountVegetablePercentage[i] = ((dayCountVegetable[i] / vegetableStandard)*20).rounded()
                if dayCountVegetablePercentage[i] > 20.0
                {
                    dayCountVegetablePercentage[i] = 20.0
                }
            }
            if dayCountDairyPercentage[i] > 0.0
            {
                dayCountDairyPercentage[i] = ((dayCountDairy[i] / dairyStandard)*20).rounded()
                if dayCountDairyPercentage[i] > 20
                {
                    dayCountDairyPercentage[i] = 20
                }
            }
            if dayCountProteinPercentage[i] > 0.0
            {
                dayCountProteinPercentage[i] = ((dayCountProtein[i] / proteinStandard)*20).rounded()
                print("Day count protein \(dayCountProtein[i])")
                 print("Day count protein \(proteinStandard)")
                print("Day count protein percent \(dayCountProteinPercentage[i])")
                if dayCountProteinPercentage[i] > 20
                {
                    dayCountProteinPercentage[i] = 20
                }
            }
            if dayCountFruitPercentage[i] > 0.0
            {
                dayCountFruitPercentage[i] = ((dayCountFruit[i] / fruitStandard)*20).rounded()
                if dayCountFruitPercentage[i] > 20
                {
                    dayCountFruitPercentage[i] = 20
                }
            }
            if dayCountGrainPercentage[i] > 0.0
            {
                dayCountGrainPercentage[i] = ((dayCountGrain[i] / grainStandard)*20).rounded()
                if dayCountGrainPercentage[i] > 20
                {
                    dayCountGrainPercentage[i] = 20
                }
            }
            dayBalancePercentage.append((dayCountGrainPercentage[i] + dayCountFruitPercentage[i] + dayCountProteinPercentage[i] + dayCountDairyPercentage[i] + dayCountVegetablePercentage[i]))
        }
        print("###")
        print("convertDailyCountIntoBalancePercentage V: \(dayCountVegetablePercentage)")
        print("convertDailyCountIntoBalancePercentage G: \(dayCountGrainPercentage)")
        print("convertDailyCountIntoBalancePercentage P: \(dayCountProteinPercentage)")
        print("convertDailyCountIntoBalancePercentage F: \(dayCountFruitPercentage)")
        print("convertDailyCountIntoBalancePercentage D: \(dayCountDairyPercentage)")
        print("Average: \(dayBalancePercentage)")
    }
    
    
    var sevenDayAverageList: [Double] = []
    var sevenDayAverage: Double = 0.0
    
    mutating func getLastSevenDaysPercentage() -> Double
    {
        sevenDayAverageList = [0.0,0.0,0.0,0.0,0.0,0.0]
        var count = 0
        if dateSaved.count > 7 // a Week
        {
            for i in dateSaved.count - 7 ..< dateSaved.count
            {
                sevenDayAverageList.append(dayBalancePercentage[i])
            }
            count = 7
        }else
        {
            for i in 0 ..< dateSaved.count
            {
                sevenDayAverageList.append(dayBalancePercentage[i])
                count+=1
            }
        }
        var sum = 0.0
        for i in 0 ..< sevenDayAverageList.count
        {
            sum += sevenDayAverageList[i]
        }
        sevenDayAverage = sum / Double(count)
        return sevenDayAverage
    }
    
    
    var sevenDayVAverageList: [Double] = []
    var sevenDayGAverageList: [Double] = []
    var sevenDayPAverageList: [Double] = []
    var sevenDayDAverageList: [Double] = []
    var sevenDayFAverageList: [Double] = []
    
    mutating func getLastSevenDaysEachElementPercentage() -> [String:Double]
    {
        sevenDayVAverageList.removeAll()
        sevenDayGAverageList.removeAll()
        sevenDayPAverageList.removeAll()
        sevenDayDAverageList.removeAll()
        sevenDayFAverageList.removeAll()
        
        if dateSaved.count > 7
        {
            for i in dateSaved.count - 7 ..< dateSaved.count
            {
                sevenDayVAverageList.append(dayCountVegetablePercentage[i])
                sevenDayGAverageList.append(dayCountGrainPercentage[i])
                sevenDayPAverageList.append(dayCountProteinPercentage[i])
                sevenDayDAverageList.append(dayCountDairyPercentage[i])
                sevenDayFAverageList.append(dayCountFruitPercentage[i])
            }
        }else
        {
            for i in 0 ..< dateSaved.count
            {
                sevenDayVAverageList.append(dayCountVegetablePercentage[i])
                sevenDayGAverageList.append(dayCountGrainPercentage[i])
                sevenDayDAverageList.append(dayCountDairyPercentage[i])
                sevenDayFAverageList.append(dayCountFruitPercentage[i])
                sevenDayPAverageList.append(dayCountProteinPercentage[i])
            }
        }
        
        var sumEachElement = ["V":0.0,"G":0.0,"P":0.0,"D":0.0,"F":0.0]
        var averageEachElement = ["V":0.0,"G":0.0,"P":0.0,"D":0.0,"F":0.0]
        let finalCount = sevenDayPAverageList.count
        
        for i in 0 ..< finalCount
        {
            sumEachElement["V"]! += sevenDayVAverageList[i]
            sumEachElement["G"]! += sevenDayGAverageList[i]
            sumEachElement["P"]! += sevenDayPAverageList[i]
            sumEachElement["D"]! += sevenDayDAverageList[i]
            sumEachElement["F"]! += sevenDayFAverageList[i]
            
            if i == finalCount - 1
            {
                averageEachElement["V"]! = sumEachElement["V"]! / Double(finalCount)
                averageEachElement["G"]! = sumEachElement["G"]! / Double(finalCount)
                averageEachElement["P"]! = sumEachElement["P"]! / Double(finalCount)
                averageEachElement["D"]! = sumEachElement["D"]! / Double(finalCount)
                averageEachElement["F"]! = sumEachElement["F"]! / Double(finalCount)
            }
        }
        
        return averageEachElement
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
            sumv += dayCountVegetablePercentage[i]
            sumd += dayCountDairyPercentage[i]
            sump += dayCountProteinPercentage[i]
            sumf += dayCountFruitPercentage[i]
            sumg += dayCountGrainPercentage[i]
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
    
    private func getTodayDate() -> String
    {
        let format = DateFormatter()
        format.dateFormat = "MM-dd"
        let currentTime = Date()
        return "\(format.string(from: currentTime))"
    }
    
    
    
    mutating func getTodayEachElementData() -> [
        Double]
    {
        let todayVegetable = dayCountVegetable[dayCountVegetable.count - 1]
        let todayGrain = dayCountGrain[dayCountGrain.count - 1]
        let todayProtein = dayCountProtein[dayCountProtein.count - 1]
        let todayFruit = dayCountFruit[dayCountFruit.count - 1]
        let todayDairy = dayCountDairy[dayCountDairy.count - 1]
        return [todayGrain,todayVegetable,todayFruit,todayDairy,todayProtein]
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
