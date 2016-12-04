//
//  DataManager.swift
//  Doooge
//
//  Created by VicChan on 2016/12/4.
//  Copyright © 2016年 VicChan. All rights reserved.
//

import Foundation


extension UserDefaults {
    private static let groupIdentifier = "group.com.vic.Doooge"
    class func  doooge() -> UserDefaults {
        let user = UserDefaults(suiteName: groupIdentifier)!
        return user
    }
}



extension DateFormatter {
    
    private static let manager = DateFormatter()
    public class func shared() -> DateFormatter {
        return DateFormatter.manager
    }
    
}

struct Event {
    var id: Int
    var name: String
    var hour: Int
    var miniute: Int
    var persist: Int
    
    var last: Date
    var week: Int = 1
    var remind: Bool = true

    
    init(id: Int, name: String, hour: Int, min: Int, persist: Int, last: Date, week: Int = 1, remind: Bool = true) {
        self.id = id
        self.name = name
        self.hour = hour
        self.miniute = min
        self.persist = persist
        self.last = last
        self.week = week
        self.remind = remind
    }

}

struct DataManager {
    
    
    static func getGeneral() -> (growth: Int, gold: Int, level: Int) {
        let manager = UserDefaults.doooge()
        let growth = manager.object(forKey: "growthPoints") as? Int ?? 0
        let gold = manager.object(forKey: "goldCoins") as? Int ?? 0
        let level = manager.object(forKey: "petLevel") as? Int ?? 0
        return (growth, gold, level)
    }
    
    static func life() -> [Event] {
        
        
        
        var events = [Event]()
        let manager = UserDefaults.doooge()

        
        
        let morning = manager.object(forKey: "早饭") as? [String: Any]
        let lunch = manager.object(forKey: "午饭") as? [String: Any]
        let dinner = manager.object(forKey: "晚饭") as? [String: Any]
        let sport = manager.object(forKey: "运动") as? [String: Any]
        let sleep = manager.object(forKey: "睡觉") as? [String: Any]
        
        if let morning = getDailyRoutine(data: morning) {
            events.append(morning)
        }
        
        if let lunch = getDailyRoutine(data: lunch) {
            events.append(lunch)
        }
        if let dinner = getDailyRoutine(data: dinner) {
            events.append(dinner)
        }
        if let sport = getDailyRoutine(data: sport) {
            events.append(sport)
        }
        if let sleep = getDailyRoutine(data: sleep) {
            events.append(sleep)
        }
        
        return events
    
    }
    
    static func getDailyRoutine(data: [String: Any]?) -> Event? {
        if let data = data {
            let hour = data["hour"] as? Int ?? 0
            let miniute = data["minute"] as? Int ?? 0
            let persist = data["persist"] as? Int ?? 0
            let last = data["last"] as! Date
            let event = Event.init(id: 0, name: "breakfast", hour: hour, min: miniute, persist: persist, last: last)
            return event
        }
        return nil
    
    }
    
    
    
    
    
}
