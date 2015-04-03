// Playground - noun: a place where people can play

import UIKit

extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}

class dfa {
    var states:Int = 0
    
    var finalStates:[Int]
    var initialState:Int
    var char:[Character]
    
    var transitionTable:[[Int]]
    
    init(table: [[Int]], initialState:Int, finalState: [Int], letter:[Character]){
        self.transitionTable = table
        self.initialState = initialState
        self.finalStates = finalState
        self.char = letter
    }
    
    func transition(stateToCheck:Int, charCheck:Character) -> Int {
        var output:Int = -1
        
        if charCheck == "a" || charCheck == "A" {
            output = transitionTable[stateToCheck][0]
        }else if charCheck == "b" || charCheck == "B" {
            output = transitionTable[stateToCheck][1]
        }
        return output
    }
    
    func validation(inputChar: String) -> Bool {
        var checkState:Int = self.initialState
        for var i:Int = 0; i < countElements(inputChar); i++ {
            checkState = transition(checkState, charCheck: inputChar[i])
        }
        
        for var j:Int = 0; j < finalStates.count; j++ {
            if checkState == finalStates[j] {
                return true
            }
        }
        return false
    }
}

func fa_or(fa1: dfa, fa2: dfa){
    
    var state:String = "\(fa1.initialState)\(fa2.initialState)"
    var states = [String]()
    
    states.append(state)
    
    
    
}



var letters:[Character] = ["a", "b"]
var tt1 = [ [0,1], [0,1] ]
var tt2 = [ [1,3], [3,2], [1,3], [3,3] ]


var initialState:Int = 0

var fs1:[Int] = [1]
var fs2:[Int] = [0, 2]

var fa1 = dfa(table: tt1, initialState: initialState, finalState: fs1, letter: letters)

var fa2 = dfa(table: tt2, initialState: initialState, finalState: fs2, letter: letters)

fa_or(fa1, fa2)
















