//
//  BitStringMaker.swift
//  Algorithm
//
//  Created by 片桐奏羽 on 2015/09/02.
//  Copyright (c) 2015年 SoKatagiri. All rights reserved.
//

import Foundation



// バイナリ表現へのエンコード
class BitStringMaker {
    
    var codeLength: Int
    var min: Double
    var max: Double
    
    init(codeLength:Int, min:Double, max:Double)
    {
        self.codeLength = codeLength
        self.min = min
        self.max = max
    }
    
    func encode(value:Double) -> Array<Int>
    {
        let gap = max - min
        var remain = value - min //
        
        var binaryList = Array<Int>()
        var position = 1.0
        
        for i in 0...codeLength-1 {
            
            let ValueOfCode = gap / pow(2.0, position)
            
            if (remain >= ValueOfCode) {
                binaryList.append(1)
                remain = remain - ValueOfCode
            } else {
                binaryList.append(0)
            }
            position++
        }
        
        return binaryList
    }
    
    func decode(binaryList:Array<Int>) -> Double
    {
        let gap = max - min
        var decodeValue = min
        var position = 1.0
        
        for i in 0...codeLength-1 {
            if (binaryList[i] == 1) {
                decodeValue += gap / pow(2.0, position)
            }
            position++
        }
        
        return decodeValue
    }
}

