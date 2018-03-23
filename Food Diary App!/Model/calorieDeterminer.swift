//
//  calorieDeterminer.swift
//  Food Diary App!
//
//  Created by Ben Shih on 20/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation

struct calorieDeterminer
{
    var sex: String
    var age: Double
    var weight: Double
    var height: Double
    
    func getCalculateCalorie() -> Double
    {
        let Calculation = 10 * (weight) + 6.25 * (height)
        if sex == "Male"
        {
            return Calculation - 5 * age + 5
        }else
        {
            return Calculation - 5 * age - 161
        }
    }
}

