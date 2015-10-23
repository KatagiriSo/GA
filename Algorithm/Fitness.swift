//
//  Fitness.swift
//  Algorithm
//
//  Created by 片桐奏羽 on 2015/09/02.
//  Copyright (c) 2015年 SoKatagiri. All rights reserved.
//

import Foundation

class Fitness {
    var maxFitness: Double = 0.0
    var minFitness: Double = 0.0
    var avgFitness: Double = 0.0
    init()
    {
        
    }
    
    // 適合度の計算
    func calcFitness(var individuals:[Individual], decoder:BitStringMaker) -> [Individual]
    {
        for target in individuals
        {
            // デコード
            let x = decoder.decode(target.gtype)
            
            // 表現型に設置
            target.ptype = x
            
            // 表現型から適合度計算
            target.fitness = 1 / ( 1 + abs(target.ptype))
            
        }
        
        // 適合度順に並べ替える。
        individuals.sortInPlace {(lhs, rhs) in return lhs.fitness > rhs.fitness}
        for i in 0...individuals.count-1
        {
            individuals[i].rank = i
        }
        
        return individuals
    }
    
    // 適合度の記録
    func recordFitness(individuls:[Individual])
    {
        self.maxFitness = individuls.first!.fitness //先頭が最大適合度
        self.minFitness = individuls.last!.fitness //最後尾が最低適合度
        
        // 平均値計算
        var avg = 0.0
        for target in individuls
        {
            avg = avg + target.fitness
        }
        avg = avg / Double(individuls.count)
        
        self.avgFitness = avg
    }

}