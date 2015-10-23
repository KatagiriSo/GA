//
//  GA.swift
//  Algorithm
//
//  Created by 片桐奏羽 on 2015/09/01.
//  Copyright (c) 2015年 SoKatagiri. All rights reserved.
//

import Foundation

class GA {
    
    let poputation = Population(populationSize: 10, codeLength: 10, codeMax: 1, min:-5.12, max:+5.12)
    let generationTransitionInfo = GenerationTransitionInfo(gap: 0.6, eliteRate: 0.7, mutate: 0.4, cross:0.7)
    let generation = 2000 //計算する世代数
    
    init ()
    {
        
    }
    
    func main()
    {
        
        
        for i in 0...generation-1
        {
            print("第\(i)世代")
            
            // 適合度計算
            poputation.calcFitness()
            
            // 適合度の統計記録
            poputation.recordFitness()
            
            // 世代表示
            poputation.show()
            
            // 世代交代
            poputation.generateNext(self.generationTransitionInfo)
            
        }
    }
    
    
    
}




