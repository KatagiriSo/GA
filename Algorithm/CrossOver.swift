//
//  CrossOver.swift
//  Algorithm
//
//  Created by katagiriTestFullName on 2015/10/23.
//  Copyright © 2015年 SoKatagiri. All rights reserved.
//

import Foundation

class CrossOver
{
    
    let info:GenerationTransitionInfo
    //var generated:Int
    var newGene:[Individual]
    var individualArray:[Individual]
    var mutableCount:Int = 0
    var codeinfo:CodeInfo


    init(newGene:[Individual],individualArray:[Individual],info:GenerationTransitionInfo, codeinfo:CodeInfo)
    {
        //  self.generated = generated
        self.newGene = newGene
        self.individualArray = individualArray
        self.info = info
        self.codeinfo = codeinfo
    }
    
    
    
    func crossOver(index1:Int, index2:Int, mutation:Mutation) -> (gen1:Individual, gen2:Individual)
    {
        let parent1 = self.individualArray[index1]
        let parent2 = self.individualArray[index2]
        
        // cross over
        let res =  makeCrossoverChildrenGense(parent1,parent2: parent2)
        self.mutableCount = self.mutableCount + res.mutalCount
        let gen1 = res.gen1
        let gen2 = res.gen2
        
        // each mutate
        _ = mutation.mutate(gen1)
        mutableCount = mutableCount + mutation.mutate(gen2).mutalPoint
        
        return (gen1, gen2)
    }
    
    
    func makeCrossoverChildrenGense(parent1:Individual, parent2:Individual) -> (mutalCount:Int,gen1:Individual,gen2:Individual)
    {
        let gen1 = parent1.copy()
        let gen2 = parent2.copy()
        
        // crossOver
        let crossPoint = cross(gen1, gen2:gen2)
        
        gen1.parent1 = parent1.rank
        gen1.parent2 = parent2.rank
        gen1.crossPoint = crossPoint
        
        gen2.parent1 = parent1.rank
        gen2.parent2 = parent2.rank
        gen2.crossPoint = crossPoint
        

        
        return (mutableCount, gen1, gen2)
    }
    
    func cross(gen1:Individual, gen2:Individual) -> Int
    {
        let crossPoint = Int(arc4random_uniform(UInt32(self.codeinfo.codeLength)))
        for (var i = crossPoint+1;i<self.codeinfo.codeLength;i++)
        {
            let tmp = gen1.gtype[i]
            gen1.gtype[i] = gen2.gtype[i]
            gen2.gtype[i] = tmp
        }
        return crossPoint
    }

}