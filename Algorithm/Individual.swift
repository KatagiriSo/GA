//
//  Individual.swift
//  Algorithm
//
//  Created by 片桐奏羽 on 2015/09/02.
//  Copyright (c) 2015年 SoKatagiri. All rights reserved.
//

import Foundation

/* 個体クラス */
class Individual {
    var ptype: Double = 0.0       // 表現型
    var gtype: Array<Int> = []    // 遺伝子型
    var fitness: Double = 0.0    // 適合度
    var rank: Int = 0 //ランク
    
//    var parent1: Individual? = nil
//    var parent2: Individual? = nil
    
    var parent1: Int = 0
    var parent2: Int = 0
    var crossPoint: Int = 0
    
//    init(parent1: Individual, parent2: Individual)
//    {
//        self.parent1 = parent1
//        self.parent2 = parent2
//    }
    
    init()
    {
        
    }
    
    init(randomForcodeLength:Int, codeMax:Int)
    {
        makeRandomGtype(randomForcodeLength, codeMax:codeMax)
    }
    
    func makeRandomGtype(codeLenth:Int, codeMax:Int)
    {
        for (var i=0;i<codeLenth;i++)
        {
            self.gtype.append((Int(arc4random_uniform(UInt32(codeMax+1)))))
        }
    }
    
    func gtypeString()->(String)
    {
        var ret: String = ""
        for a in self.gtype {
            ret = ret + String(format: "%d", arguments: [a])
        }
        return ret
    }
    
    func copy()->(Individual)
    {
        let c = Individual()
        c.ptype = self.ptype
        c.gtype = self.gtype
        c.fitness = self.fitness
        c.parent1 = self.parent1
        c.parent2 = self.parent2
        c.crossPoint = self.crossPoint
        c.rank = self.rank
        return c
    }
    
}
