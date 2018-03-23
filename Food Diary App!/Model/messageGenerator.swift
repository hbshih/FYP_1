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
        
        let diceRoll:Int = Int(arc4random_uniform(UInt32(Greetings.count - 1)))
        return Greetings[diceRoll]
    }
    
    var momo: [String] = []
    var Databasecalled = false
    
    mutating func setMessagingMessages() -> [String] // From online
    {
        var mes : [String] = []
        var ref = Database.database().reference()
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
    }
    
    func setInformationMessages() -> [String] // Three type of message
    {
        //[vegetablePercentage,proteinPercentage,grainPercentage,fruitPercentage,dairyPercentage]
        
        var Most = ""
        var Least = ""
        
        switch Max {
        case nList[0]?:
            Most = "vegetable"
        case nList[1]?:
            Most = "protein"
        case nList[2]?:
            Most = "grain"
        case nList[3]?:
            Most = "fruit"
        case nList[4]?:
            Most = "dairy"
        default:
            Most = ""
        }
        
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
        }
        
        let healthQuote = ["Balance your diet prevents you from getting diseases and infections",
                           "A balanced diet may be the best medicine",
                           "A balanced diet, adequate exercise, and common sense keep the doctor away",
                           "When diet is wrong, medicine is of no use.",
                            "Keep calm and eat well"
                           ]
        
        var message : [String] = []
        let diceRoll:Int = Int(arc4random_uniform(UInt32(lackMessage.count - 1)))
        let diceRoll2:Int = Int(arc4random_uniform(UInt32(healthQuote.count - 1)))
        
        message = [lackMessage[diceRoll],healthQuote[diceRoll2]]
        
        return message
    }
    
    func setAnnoyingMessages() -> [String] // Start annoying
    {
        let message = [
            "I think you are just enjoying pocking my face",
            "I have gave you enough advices",
            "Tapping it does abosolutely nothing except irritate me",
            "I know I conditioned you to tap my face in my counterpart apps, but I'm really serious: it doesn't do anything now",
            "Yet you're still poking my face",
            "OK, stop",
            "I am not going to talk anymore"]
        return message
    }
    
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
    
    
    init(nList: [Double], count: Int)
    {
        messageList.removeAll()
        self.nList = nList
        //[vegetablePercentage,proteinPercentage,grainPercentage,fruitPercentage,dairyPercentage]
        Max = nList.max()
        Min = nList.min()
        messageList += setInformationMessages()
        messageList += setAnnoyingMessages()
    }
    
    func getMessage() -> [String]
    {
        return messageList
    }
    
    
}
