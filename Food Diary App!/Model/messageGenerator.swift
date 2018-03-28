//
//  messageGenerator.swift
//  Food Diary App!
//
//  Created by Ben Shih on 21/03/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct messageGenerator {
    
    var messageList : [String] = []
    var Max: Double?
    var Min: Double?
    var nList: [Double] = []
    
    
    func setGreetingMessages() -> String
    {
        let Greetings = ["Hi", "Nice to see you again", "Hey man", "Hey", "How's it going?", "What's up?","What's going on?","How's everything","How are things?","How's life","How's your day?", "Good to see you","Yo!","Are you OK","Howdy!","WHAZZUP!","Good day mate","Hiya!"]
        
        let zh_Greetings = ["嗨","您好","吃飯了嗎",""]
        
        let diceRoll:Int = Int(arc4random_uniform(UInt32(Greetings.count - 1)))
        return Greetings[diceRoll]
    }
    
    var momo: [String] = []
    var Databasecalled = false
    /*
    mutating func setMessagingMessages() -> [String] // From online
    {
        var mes : [String] = []
        let ref = Database.database().reference()
        ref.child("FaceTappedMessages").observeSingleEvent(of: .value, with:
        { (snapshot) in
            if let value = snapshot.value as? [String:Any]
            {
                    if let m = value["message"] as? String
                    {
                        mes.append(m)
                    }
            }
            print("Getting Message")
        }) { (error) in
            print("Error on")
            print(error.localizedDescription)
        }
        return mes
    }*/
    
    func setInformationMessages() -> [String] // Three type of message
    {
        //[vegetablePercentage,proteinPercentage,grainPercentage,fruitPercentage,dairyPercentage]
        
//        var Most = ""
        var Least = ""
//
//        switch Max {
//        case nList[0]?:
//            Most = "vegetable"
//        case nList[1]?:
//            Most = "protein"
//        case nList[2]?:
//            Most = "grain"
//        case nList[3]?:
//            Most = "fruit"
//        case nList[4]?:
//            Most = "dairy"
//        default:
//            Most = ""
//        }
        
        switch Min
        {
        case nList[0]?:
            Least = "vegetable"
        case nList[1]?:
            Least = "protein"
        case nList[2]?:
            Least = "grain"
        case nList[3]?:
            Least = "fruit"
        case nList[4]?:
            Least = "dairy"
        default:
            Least = ""
        }
        
        var lackMessage: [String] = []
        if Min! < 5.0
        {
            lackMessage =
            [
                 "Consider to eat more \(Least)",
                 "Try to eat more \(Least), your score is low",
                 "One way to improve your balance is eat more \(Least)",
                 "Add more \(Least) to your plate!",
            ]
        }else
        {
            lackMessage =
            [
                    "You are doing a great job balancing your diet",
                    "There is more than one way to eat healthfully and everyone has their own eating style.",
                    "Be physically active at least 2 1/2 hours per week.",
                
            ]
        }
        
        
        var message : [String] = []
        let diceRoll:Int = Int(arc4random_uniform(UInt32(lackMessage.count - 1)))
        message = [lackMessage[diceRoll]]
        return message
    }
    
    func healthQuotes() -> [String]
    {
        let healthQuote = ["Balance your diet prevents you from getting diseases and infections",
                           "Everything You Eat and Drink Matters — Focus on Variety, Amount, and Nutrition",
                           "Choose Foods and Beverages with Less Saturated Fat, Sodium, and Added Sugars",
                           "A balanced diet may be the best medicine",
                           "A balanced diet, adequate exercise, and common sense keep the doctor away",
                           "When diet is wrong, medicine is of no use.",
                           "Keep calm and eat well",
                           "Focus on whole fruits. Whole fruits include fresh, frozen, dried, and canned options. Choose whole fruits more often than 100% fruit juice.",
                           "Vary your veggies. Vegetables are divided into five subgroups and include dark-green vegetables, red and orange vegetables, legumes (beans and peas), starchy vegetables, and other vegetables.",
                           "Make half your grains whole grains. Grains include whole grains and refined, enriched grains. Choose whole grains more often.",
                           "Vary your protein routine. Protein foods include both animal and plant sources. Choose a variety of lean protein foods from both plant and animal sources.",
                           "Move to low-fat or fat-free milk or yogurt. Dairy includes milk, yogurt, cheese, and calcium-fortified soy beverages (soymilk).",
                           ]
        
        let diceRoll:Int = Int(arc4random_uniform(UInt32(healthQuote.count - 1)))
        var diceRoll2:Int = Int(arc4random_uniform(UInt32(healthQuote.count - 1)))
        
        if diceRoll == diceRoll2
        {
            diceRoll2 = Int(arc4random_uniform(UInt32(healthQuote.count - 1)))
        }
        
        return [healthQuote[diceRoll2],healthQuote[diceRoll]]
        
    }
    
    func setAnnoyingMessages() -> [String] // Start annoying
    {
        let message = [
            "I think you are just enjoying pocking my face",
            "I have given you enough advices",
            "Tapping it does abosolutely nothing except irritate me",
            "I know I conditioned you to tap my face in my counterpart apps, but I'm really serious: it doesn't do anything now",
            "Yet you're still poking my face",
            "OK, stop",
            "I am not going to talk anymore"]
        
        let zh_message =
        [
            "你是不是覺得戳我的臉很好玩",
            "你繼續戳下去我也不會再給你其他建議了",
            "不",
            "要",
            "戳",
            "林北的臉！！！！",
            
        ]
        
        return message
    }
    /*
    func setQuoteMessages() -> [String] // Give you some quote
    {
        let message = ["OK, stop", "I am not going to talk anymore", "I regret for that", "You need to grow up", "Look at some quotes"]
        let notify = ""
        let url = URL(string: "https://icanhazdadjoke.com/")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil
            {
                print(error)
            }else
            {
                if let urlContent = data
                {
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        print(jsonResult)
                    } catch
                    {
                        print("Json Processing failed")
                    }
                }
            }
        }
        task.resume()
        return message
    }
    */
    
    init(nList: [Double], count: Int)
    {
        messageList.removeAll()
        self.nList = nList
        //[vegetablePercentage,proteinPercentage,grainPercentage,fruitPercentage,dairyPercentage]
        Max = nList.max()
        Min = nList.min()
        messageList.append(setGreetingMessages())
        if count > 2
        {
        messageList += setInformationMessages()
        }
        messageList += healthQuotes()
        messageList += setAnnoyingMessages()
    }
    
    func getMessage() -> [String]
    {
        return messageList
    }
    
    
}
