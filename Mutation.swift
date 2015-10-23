//
//  Mutation.swift
//  Algorithm
//
//  Created by katagiriTestFullName on 2015/10/23.
//  Copyright © 2015年 SoKatagiri. All rights reserved.
//

import Foundation


class Mutation
{
    let info:GenerationTransitionInfo
   // var generated:Int
    var newGene:[Individual]
    var individualArray:[Individual]
    var mutableCount:Int = 0
    var codeinfo:CodeInfo
    
    init(/*generated:Int,*/newGene:[Individual],individualArray:[Individual],info:GenerationTransitionInfo, codeinfo:CodeInfo)
    {
      //  self.generated = generated
        self.newGene = newGene
        self.individualArray = individualArray
        self.info = info
        self.codeinfo = codeinfo
    }
    
    func mutate(roulette:Roulette) -> Individual
    {
        let parent = roulette.selectParentRoulette(self.individualArray)
        let gen = parent.copy();
        self.mutableCount = self.mutableCount + mutate(gen).mutalPoint
        return gen
    }
    
    
//    func mutate2()
//    {
//        let parent1 = self.individualArray[generated]
//        let parent2 = self.individualArray[generated+1]
//        
//        // mutate
//        let gen1 = parent1.copy();
//        self.mutableCount = self.mutableCount + mutate(gen1, info: info)
//        newGene.append(gen1)
//        let gen2 = parent2.copy();
//        self.mutableCount = self.mutableCount + mutate(gen2, info: info)
//        newGene.append(gen2)
//        
//    }
    

    
     
    
    func mutate(gen: Individual) -> (individual:Individual, mutalPoint:Int)
    {
        var mutatePoint = 0
        for i in 0...self.codeinfo.codeLength-1
        {
            let r = Double(arc4random()) / Double(UINT32_MAX) // 0-1の間の乱数
            if (r < info.mutate) {
                let range:UInt32 = UInt32(self.codeinfo.codeMax) + UInt32(1)
                gen.gtype[i] = Int(arc4random_uniform(range))
                mutatePoint++
            }
        }
        return (gen,mutatePoint)
        
    }

}