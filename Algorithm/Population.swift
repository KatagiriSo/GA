//
//  Population.swift
//  Algorithm
//
//  Created by 片桐奏羽 on 2015/09/02.
//  Copyright (c) 2015年 SoKatagiri. All rights reserved.
//

import Foundation

// 全体
class Population {
    var individualArray: Array<Individual> = [] // 個体へのポインタ
    var pSelectRoulette: Array<Double> = [] // 適合ルーレット
    var mutableCount: Int = 0 // 突然変異の合計
    var populationSize: Int = 0// 集団の個体数
    var fitness: Fitness = Fitness()
    var codeLength: Int = 0// 遺伝子長
    var codeMax: Int = 0// 各遺伝子座の最大値、ビットストリングの場合は1
    var bitStringMaker: BitStringMaker
    
    init(populationSize:Int, codeLength:Int, codeMax:Int, min:Double, max:Double)
    {
        self.populationSize = populationSize
        self.codeLength = codeLength
        self.codeMax = codeMax
        self.bitStringMaker = BitStringMaker(codeLength: self.codeLength, min: min, max: max)
        
        for i in 0...self.populationSize-1
        {
            let gen = Individual(randomForcodeLength:self.codeLength, codeMax:codeMax)
            self.individualArray.append(gen)
        }
    }
    
    // 適合度計算
    func calcPselectRoulette()
    {
        self.pSelectRoulette = []
        
        // すべての個体
        for i in 0...self.individualArray.count-1 {
            self.pSelectRoulette.append(0.0)
        }
        
        self.pSelectRoulette[0] = self.individualArray[0].fitness
        var all = self.individualArray[0].fitness
        var count = self.individualArray.count
        for j in 1...count-1 {
            self.pSelectRoulette[j] = self.pSelectRoulette[j-1] + self.individualArray[j].fitness
            all += self.individualArray[j].fitness
        }
        
        for j in 0...count-1 {
            self.pSelectRoulette[j] /= all
        }
    }
    
    // 適合度による親選択
    func selectParentRoulette() -> Individual
    {
        let r = Double(arc4random()) / Double(UINT32_MAX) // 0-1の間の乱数
        
        for i in 0...self.pSelectRoulette.count-1 {
            if r < self.pSelectRoulette[i] {
                return self.individualArray[i]
            }
        }
        
        assert(false, "ここにきてはいけない")
        return self.individualArray[0]
    }
    
    // 適合度の計算
    func calcFitness()
    {
        for target in self.individualArray
        {
            // デコード
            var x = self.bitStringMaker.decode(target.gtype)
            
            // 表現型に設置
            target.ptype = x
            
            // 表現型から適合度計算
            target.fitness = 1 / ( 1 + abs(target.ptype))
            
        }
        
        // 適合度順に並べ替える。
        self.individualArray.sort {(lhs, rhs) in return lhs.fitness > rhs.fitness}
        for i in 0...self.individualArray.count-1
        {
            individualArray[i].rank = i
        }
    }
    
    // 適合度の記録
    func recordFitness()
    {
        self.fitness.maxFitness = self.individualArray.first!.fitness //先頭が最大適合度
        self.fitness.minFitness = self.individualArray.last!.fitness //最後尾が最低適合度
        
        // 平均値計算
        var avg = 0.0
        for target in self.individualArray
        {
            avg = avg + target.fitness
        }
        avg = avg / Double(self.individualArray.count)
        
        self.fitness.avgFitness = avg
    }
    
    
    // 世代交代
    func generateNext(info:GenerationTransitionInfo)
    {
        var newGene: Array<Individual> = Array<Individual>()
        
        // 親世代で残る数
        let remain =  Int(Double(self.populationSize) * (1 - info.gap))
        
        // その中のエリートの数
        let elite = Int(Double(remain) * info.eliteRate)
        
        //適合度計算
        self.calcPselectRoulette()
        
        var index = 0
        
        var generated: Int
        
        // elite strategy (survive)
        for (generated = 0; generated < elite; generated++)
        {
            var newTarget = self.individualArray[generated]
            newGene.append(newTarget)
        }
        
        // no elite but directly child
        for (; generated < remain; generated++)
        {
            var newTarget = self.individualArray[generated]
            newGene.append(newTarget)
        }
        
        // cross over and mutate
        self.mutableCount = 0
        
        // 残り個数が奇数なら突然変異の子供を一個つくる
        if ((self.populationSize - generated) % 2 == 1) {
            var parent = selectParentRoulette()
            var gen = parent.copy();
            self.mutableCount = self.mutableCount + mutate(gen, info: info)
            newGene.append(gen)
            generated++
        }
        
        // cross over and mutate
        
        for (;generated < self.populationSize;generated = generated + 2) {
            
            let r = Double(arc4random()) / Double(UINT32_MAX)
            let parent1 = self.individualArray[generated]
            let parent2 = self.individualArray[generated+1]
            
            if ( r<info.cross) {
                // cross over
                let res =  makeCrossoverChildrenGense(parent1,parent2: parent2, info: info)
                self.mutableCount = self.mutableCount + res.mutalCount
                let gen1 = res.gen1
                let gen2 = res.gen2
                
                newGene.append(gen1)
                newGene.append(gen2)
                
            } else {
                // mutate
                let gen1 = parent1.copy();
                self.mutableCount = self.mutableCount + mutate(gen1, info: info)
                newGene.append(gen1)
                let gen2 = parent2.copy();
                self.mutableCount = self.mutableCount + mutate(gen2, info: info)
                newGene.append(gen2)
            }
        }
        
        // generation change
        self.individualArray = newGene
    }

    func makeCrossoverChildrenGense(parent1:Individual, parent2:Individual, info:GenerationTransitionInfo) -> (mutalCount:Int,gen1:Individual,gen2:Individual)
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
        
        // each mutate
        var mutalCount = mutate(gen1, info: info)
        mutableCount = mutableCount + mutate(gen2, info:info)
        
        return (mutableCount, gen1, gen2)
    }
    
    func cross(gen1:Individual, gen2:Individual) -> Int
    {
        let crossPoint = Int(arc4random_uniform(UInt32(self.codeLength)))
        for (var i = crossPoint+1;i<self.codeLength;i++)
        {
            var tmp = gen1.gtype[i]
            gen1.gtype[i] = gen2.gtype[i]
            gen2.gtype[i] = tmp
        }
        return crossPoint
    }
    
    
    func mutate(gen: Individual, info:GenerationTransitionInfo) -> Int
    {
        var mutatePoint = 0
        for i in 0...self.codeLength-1
        {
            let r = Double(arc4random()) / Double(UINT32_MAX) // 0-1の間の乱数
            if (r < info.mutate) {
                var range:UInt32 = UInt32(self.codeMax) + UInt32(1)
                gen.gtype[i] = Int(arc4random_uniform(range))
                mutatePoint++
            }
        }
        return mutatePoint
        
    }
    
    
    

    func show()
    {
        // population
        println("-------------")
        println("# parents xsite gtype ptype fitness")
        for i in 0...self.individualArray.count-1
        {
            let target = self.individualArray[i]
            print("\(i) (\(target.parent1),\(target.parent2)) \(target.crossPoint) ")
            print("\(target.gtypeString()) \(self.codeLength) ")
            print("\(target.ptype) \(target.fitness)")
            print("\n")
        }
        println("total mutate \(self.mutableCount)")
    }
}


