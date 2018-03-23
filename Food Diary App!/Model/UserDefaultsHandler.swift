//
//  UserDefaultsHandler.swift
//  Food Diary App!
//
//  Created by Ben Shih on 03/02/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import UIKit

struct UserDefaultsHandler
{
    private let defaults = UserDefaults.standard
    
    mutating func getOnboardingStatus() -> Bool
    {
        return defaults.bool(forKey: "OnboardingSuccess")
    }
    
    func getPlanStandard() -> AnyObject
    {
        /* Return list
         grainStandard = userPlan[0]
         vegetableStandard = userPlan[1]
         proteinStandard = userPlan [2]
         fruitStandard = userPlan[3]
         dairyStandard = userPlan[4]
         */
        return defaults.object(forKey: "PlanStandardArray") as AnyObject
    }
    
    func setOnboardingStatus(status: Bool)
    {
        defaults.set(status, forKey: "OnboardingSuccess")
    }
    
    func setPersonalData(value: [String:Int])
    {
        defaults.set(value, forKey: "PersonalData")
    }
    
    func getPersonalData() -> AnyObject
    {
        return defaults.object(forKey: "PersonalData") as AnyObject
    }
    
    func setMessageSeen(seen: Bool)
    {
        defaults.set(seen, forKey: "seenMessages")
    }
    
    func getMessageSeen() -> Bool
    {
        return defaults.bool(forKey: "seenMessages")
    }
    
    func setPlanStandard(value: [Double])
    {
        defaults.set(value, forKey: "PlanStandardArray")
    }
    
    func setHomepageTutorialStatus(status: Bool)
    {
        defaults.set(status, forKey: "HomepageTutorial")
    }
    
    func setAddDataTutorialStatus(status: Bool)
    {
        defaults.set(status, forKey: "AddDataTutorial")
    }
    
    func getHomepageTutorialStatus() -> Bool
    {
        return defaults.bool(forKey: "HomepageTutorial")
    }
    
    func getAddDataTutorialStatus() -> Bool
    {
        return defaults.bool(forKey: "AddDataTutorial")
    }
    
    
    
    /*
    func getTutorialStatus() -> Bool
    {
        
    }
 */
    
}
