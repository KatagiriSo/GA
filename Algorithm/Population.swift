//
//  Population.swift
//  Algorithm
//
//  Created by 片桐奏羽 on 2015/09/02.
//  Copyright (c) 2015年 SoKatagiri. All rights reserved.
//

import Foundation


struct CodeInfo {
    var codeLength: Int = 0// 遺伝子長
    var codeMax: Int = 0// 各遺伝子座の最大値、ビットストリングの場合は1
}

// 全体
class Population {
    var individualArray: Array<Individual> = [] // 各個体
    var mutableCount: Int = 0 // 突然変異の合計
    var populationSize: Int = 0// 集団の個体数
    var fitness: Fitness = Fitness()
    var codeinfo:CodeInfo
    var bitStringMaker: BitStringMaker
    var roulette = Roulette()
    
    
    init(populationSize:Int, codeLength:Int, codeMax:Int, min:Double, max:Double)
    {
        self.populationSize = populationSize
        self.codeinfo = CodeInfo(codeLength: codeLength, codeMax: codeMax)
        self.bitStringMaker = BitStringMaker(codeLength: self.codeinfo.codeLength, min: min, max: max)
        
        for _ in 0...self.populationSize-1
        {
            let gen = Individual(randomForcodeLength:self.codeinfo.codeLength, codeMax:self.codeinfo.codeMax)
            self.individualArray.append(gen)
        }
    }
    
    
    func calcFitness()
    {
        self.individualArray = self.fitness.calcFitness(self.individualArray, decoder: self.bitStringMaker)
    }
    
    func recordFitness()
    {
        self.fitness.recordFitness(self.individualArray)
    }

    
    func getElite(individuals:[Individual], info: GenerationTransitionInfo) -> [Individual]
    {
        var elites: Array<Individual> = Array<Individual>()

        // 親世代で残る数
        let remain =  Int(Double(self.individualArray.count) * (1 - info.gap))
        
        // その中のエリートの数
        let elite = Int(Double(remain) * info.eliteRate)
        
        // elite strategy (survive)
        for (var generated = 0; generated < elite; generated++)
        {
            let newTarget = self.individualArray[generated]
            elites.append(newTarget)
        }
        
        return elites
    }
    
     
    
    // 世代交代
    func generateNext(info:GenerationTransitionInfo)
    {
        var newGene: Array<Individual> = Array<Individual>()
        
        // 親世代で生き残る数
        let remain =  Int(Double(self.populationSize) * (1 - info.gap))
        
        
        //適合度計算
        self.roulette.calcPselectRoulette(self.individualArray)
        
        
        var generated: Int = 0
        
        // そのまま生き残るエリート
        let elites = self.getElite(self.individualArray, info: info)
        newGene.appendContentsOf(elites)
        generated += elites.count
        
        // エリートではないが生き残る
        for (; generated < remain; generated++)
        {
            let newTarget = self.individualArray[generated]
            newGene.append(newTarget)
        }
        
        
        self.mutableCount = 0

        let mutation = Mutation(newGene: newGene, individualArray: self.individualArray, info: info, codeinfo: self.codeinfo)
        let crossOver = CrossOver(newGene: newGene, individualArray: self.individualArray, info: info, codeinfo: self.codeinfo)
        
        // 残り個数が奇数なら突然変異の子供を一個つくる
        if ((self.individualArray.count - generated) % 2 == 1) {
            let gen = mutation.mutate(self.roulette)
            newGene.append(gen)
            generated++
        }
        
        for (;generated < self.individualArray.count;generated = generated + 2) {
            
            let r = Double(arc4random()) / Double(UINT32_MAX)
                
            if ( r<info.cross) {
                let gens = crossOver.crossOver(generated, index2: generated+1, mutation: mutation)
                newGene.append(gens.gen1)
                newGene.append(gens.gen2)
            } else {
                let gen1 = self.individualArray[generated].copy()
                let gen2 = self.individualArray[generated+1].copy()
                let a = mutation.mutate(gen1).individual
                let b = mutation.mutate(gen2).individual
                newGene.append(a)
                newGene.append(b)
            }
            
        }
        
        // generation change
        self.individualArray = newGene
    }


    

    
    
    

    func show()
    {
        // population
        print("-------------")
        print("# parents xsite gtype ptype fitness")
        for i in 0...self.individualArray.count-1
        {
            let target = self.individualArray[i]
            print("\(i) (\(target.parent1),\(target.parent2)) \(target.crossPoint) ", terminator: "")
            print("\(target.gtypeString()) \(self.codeinfo.codeLength) ", terminator: "")
            print("\(target.ptype) \(target.fitness)", terminator: "")
            print("\n", terminator: "")
        }
        print("total mutate \(self.mutableCount)")
    }
}


