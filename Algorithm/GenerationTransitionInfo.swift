//
//  GenerationTransitionInfo.swift
//  Algorithm
//
//  Created by 片桐奏羽 on 2015/09/03.
//  Copyright (c) 2015年 SoKatagiri. All rights reserved.
//

import Foundation

class GenerationTransitionInfo
{
    var gap: Double// 一回の生殖で子と入れ替わる割合
    var eliteRate: Double // 次世代にそのまま残るエリートの割合
    var mutate: Double // 突然変異率
    var cross: Double // 交叉確率
    
    init(gap:Double, eliteRate:Double, mutate:Double, cross:Double)
    {
        self.gap = gap
        self.eliteRate = eliteRate
        self.mutate = mutate
        self.cross = cross
    }
    
}

