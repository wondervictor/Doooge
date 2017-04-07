//
//  ScoreManager.swift
//  Doooge
//
//  Created by VicChan on 2016/11/19.
//  Copyright © 2016年 VicChan. All rights reserved.
//

import Foundation


/// 成绩管理

enum ScoreRule: Int {

    /// 连续坚持3天
    case continue_3_day = 15
    
    /// 连续坚持7天
    case continue_7_day = 30
    
    /// 连续坚持21天
    case continue_21_day = 100
    
    /// 正常活动(1小时内睡觉／吃饭／运动 小时自定义事件(可以提前))
    case normal = 10
    
    /// 自定义时间1-24小时内
    case custom_late = 5
    
    /// 未完成 (睡觉吃饭玩 1小时内未完成/自定义事件24小时内未完成)
    case undo = -5
    
    
    func gold() -> Int {
        var gold = 0
        switch self {
        case .custom_late:gold = 3
        case .normal:gold = 5
        case .continue_3_day: gold = 10
        case .continue_7_day: gold = 20
        case .continue_21_day:gold = 50
        case .undo:gold = 0
        }
        return gold
    }

}


class ScoreManager {

    
    var growthValue: Int = 50
    var level: Int = 1
    var coin: Int = 50
    
    var ceiling = 300
    
    
    static let manager: ScoreManager = {
        let instance = ScoreManager()
        let tuple = instance.load()
        instance.level = tuple.level
        instance.coin = tuple.coin
        instance.growthValue = tuple.growth
        return instance
    }()
    
    // 坚持某个事件
    func keepDoing(days: Int) -> Bool {
        if days >= 3 && days < 7 {
            incrementScore(rule: .continue_3_day)
            return true
        } else if days >= 7 && days < 21 {
            incrementScore(rule: .continue_7_day)
            return true

        } else if days >= 21 {
            incrementScore(rule: .continue_21_day)
            return true
        } else {
            return false
        }
    }
    
    // MARK: 加分
    func incrementScore(rule: ScoreRule) {
        growthValue += rule.rawValue
    }
    
    // 加载数据
    func load() -> (level: Int, growth: Int, coin: Int) {
        return (2,250,50)
    }
    
    // 降低成长值
    func decrement() {
        growthValue -= 5
        if growthValue <= 0 && level > 0 {
            level -= 1
            growthValue = getCeiling(level)
        }
    }
    
    //  MARK: 等级增加
    func incrementLevel() {
        ceiling = getCeiling(level)
        if growthValue > ceiling {
            level += 1
        }
    }
    
    // 设置上限
    func getCeiling(_ level: Int) -> Int{
        let ceil = ceiling + level * 50
        return ceil > 1000 ? 1000: ceil
    }
    
    // MARK: 存储数据值
    private func save() {
    
        
    }
}

extension ScoreManager {

    func eat(ontime: Bool) {
        if ontime {
            //
            let days = 0
            if keepDoing(days: days) {
            } else {
                incrementScore(rule: .normal)
            }
        } else {

        }
    }
    
    func play(ontime: Bool) {
        
    
    }



}
