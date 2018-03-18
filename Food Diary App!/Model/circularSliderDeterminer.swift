//
//  circularSliderDeterminer.swift
//  Food Diary App!
//
//  Created by Ben Shih on 18/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import UIKit

struct circularSliderDeterminer
{
    var value: Double?
    var sliderValue: Double = 0.0
    var sliderColor: UIColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:1.0)
    var sliderTrackColor: UIColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:0.2)
    
    init(value:Double)
    {
        self.value = value
        setValueAndColourDeterminer()
    }
    
    mutating func getSliderValue()-> Double
    {
        return sliderValue
    }
    mutating func getSliderColour()-> UIColor
    {
        return sliderColor
    }
    mutating func getSliderTrackColour() -> UIColor
    {
        return sliderTrackColor
    }
    
    mutating func setValueAndColourDeterminer()
    {
        let value = self.value!
        if value > 0.0 && value <= 20.0
        {
            sliderColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:1.0)
            sliderTrackColor = UIColor(red:0.99, green:0.44, blue:0.39, alpha:0.2)
        }else if value > 20.0 && value <= 60.0
        {
            sliderColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:1.0)
            sliderTrackColor = UIColor(red:0.99, green:0.82, blue:0.39, alpha:0.2)
        }else if value > 60.0 && value <= 80.0
        {
            sliderColor = UIColor(red:0.39, green:0.82, blue:0.99, alpha:1.0)
            sliderTrackColor = UIColor(red:0.39, green:0.82, blue:0.99, alpha:0.2)
        }else
        {
            sliderColor = UIColor(red:0.60, green:0.80, blue:0.29, alpha:1.0)
            sliderTrackColor = UIColor(red:0.60, green:0.80, blue:0.29, alpha:0.2)
        }
        sliderValue = value * 3.6
    }
}
