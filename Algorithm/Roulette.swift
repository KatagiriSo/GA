//
//  Roulette.swift
//  Algorithm
//
//  Created by katagiriTestFullName on 2015/10/23.
//  Copyright © 2015年 SoKatagiri. All rights reserved.
//

import Foundation

class Roulette
{
    var pSelectRoulette: Array<Double> = [] // 適合ルーレット

    // 適合度計算
    func calcPselectRoulette(individuals:[Individual])
    {
        self.pSelectRoulette = []
        
        // ルーレット初期化
        for _ in 0...individuals.count-1 {
            self.pSelectRoulette.append(0.0)
        }
        
        // 適合度をどんどん入れていく。
        self.pSelectRoulette[0] = individuals[0].fitness
        var all = individuals[0].fitness
        let count = individuals.count
        for j in 1...count-1 {
            self.pSelectRoulette[j] = self.pSelectRoulette[j-1] + individuals[j].fitness
            all += individuals[j].fitness
        }
        
        for j in 0...count-1 {
            self.pSelectRoulette[j] /= all
        }
    }
    
    // 適合度による親選択
    func selectParentRoulette(Individuals:[Individual]) -> Individual
    {
        let r = Double(arc4random()) / Double(UINT32_MAX) // 0-1の間の乱数
        
        for i in 0...self.pSelectRoulette.count-1 {
            if r < self.pSelectRoulette[i] {
                return Individuals[i]
            }
        }
        
        assert(false, "ここにきてはいけない")
        return Individuals[0]
    }
    
}
