// Playground - noun: a place where people can play

//String extension
extension String {
    
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

}

//MARK: DFA Class
class dfa {
    var states:Int = 0
    
    var finalStates:[Int]
    var initialState:Int
    var char:[Character]
    
    var transitionTable:[[Int]]
    
    //Constructor
    init(table: [[Int]], initialState:Int, finalState: [Int], letter:[Character]){
        self.transitionTable = table
        self.initialState = initialState
        self.finalStates = finalState
        self.char = letter
    }
    
    //Transition Method
    func transition(stateToCheck:Int, charCheck:Character) -> Int {
        var output:Int = -1
        
        if charCheck == "a" || charCheck == "A" {
            output = transitionTable[stateToCheck][0]
        }else if charCheck == "b" || charCheck == "B" {
            output = transitionTable[stateToCheck][1]
        }
        return output
    }
    
    //Validation Method
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


func fa_concat(fa1: dfa, fa2: dfa) -> dfa {
    
    var newT_T = [[Int]]()
    var states = [String,String]()
    var newFinalState = [Int]()
    var newInitialState:Int = 0
    
    var indexNum:Int = 0
    
    var x:String!
    var y:String!
    
    x = "\(fa1.initialState)"
    
    let a = ("\(0)", "")
    states.append(a)
    
    if contains(fa1.finalStates, x.toInt()!){
        if y != nil {
            y = "\(y)\(fa2.initialState)"
        }else{
            y = "\(fa2.initialState)"
        }
        states[0].1 = y
    }
    
    for var i:Int = 0; i < states.count; i++ {
        
        var stateTo1:Int = 0
        var stateTo2:Int = 0
        
        for var k:Int = 0; k < fa1.char.count; k++ {
        
            var s1:String = ""
            var s2:String = ""
            
            for var sOne:Int = 0; sOne < countElements(states[i].0); sOne++ {
                s1 = "\(s1)\(fa1.transition(((states[i].0)[sOne]).toInt()!, charCheck: fa1.char[k]))"
            
                if contains(fa1.finalStates, s1[sOne].toInt()!){
                s2 = "\(s2)\(fa2.initialState)"
                }
            }
            if states[i].1 != "" {
                for var sOne:Int = 0; sOne < countElements(states[i].1); sOne++ {
                    let temp = "\(fa2.transition(((states[i].1)[sOne]).toInt()!, charCheck: fa1.char[k]))"
                    if !contains(s2, temp[0]){
                        s2 = "\(s2)\(temp)"
                    }
                }
            }
        
            let _s1 = sortedString(s1)
            let _s2 = sortedString(s2)
        
            var flag:Bool = false
        
            for var j:Int = 0; j < states.count; j++ {
                if states[j].0 == _s1 && states[j].1 == _s2{
                    flag = true
                    indexNum = j
                    break
                }else{
//                    flag = false
                }
            }
        
            if !flag {
                let temp = ("\(_s1)", "\(_s2)")
                states.append(temp)
                indexNum = states.count - 1
                
                for s in s2 {
                    if contains(fa2.finalStates, "\(s)".toInt()!){
                        newFinalState.append(indexNum)
                    }
                }
            }
            
            if k == 0 {
                stateTo1 = indexNum
            }else if k == 1 {
                stateTo2 = indexNum
            }
        }
        newT_T.insert([stateTo1, stateTo2], atIndex: i)
        
        
    }
    println(states)
    println(newT_T)
    println(newFinalState)
    
    let newDFA = dfa(table: newT_T, initialState: newInitialState, finalState: newFinalState, letter: fa1.char)
    
    return newDFA
}

func sortedString(str: String) -> String {
    return String(sorted(str, { $0 < $1 } ))
}

//OR of Finite Automata Method
func fa_or(fa1: dfa, fa2: dfa) -> dfa {
    
    var state:String = "\(fa1.initialState)\(fa2.initialState)"
    var states = [String]()
    
    states.append(state)
    
    var s1:Int
    var s2:Int
    var newT_T = [[Int]]()
    var newFinalState = [Int]()
    var newInitialState:Int = 0
    var indexNum:Int = 0
    
    //for var j:Int = 0; j < states.count; j++ {
    for var j = 0; j < states.count; j++ {
    
        var stateTo1:Int = 0
        var stateTo2:Int = 0
        
        var tempArrToStoreTransition = [Int]()
        var updateState:String = states[j]
        
        for var i:Int = 0; i < fa1.char.count; i++ {
            s1 = fa1.transition(Int(updateState[0].toInt()!), charCheck: fa1.char[i])
            s2 = fa2.transition(Int(updateState[1].toInt()!), charCheck: fa1.char[i])
        
            var newState:String = "\(s1)\(s2)"
        
            var flag:Bool = false
            
            for var n:Int = 0; n < states.count; n++ {
                if states[n] == newState {
                    flag = true
                    indexNum = n
                    break
                }else{
                    flag = false
                }
            }
        
            if (flag == false){
                states.append(newState)
                indexNum = states.count - 1
            }
            
            if i == 0 {
                stateTo1 = indexNum
            }else if i == 1 {
                stateTo2 = indexNum
            }
        }
        
        newT_T.insert([stateTo1, stateTo2], atIndex: j)
    }
    
    println(newT_T)
    println(states)
    
    newFinalState = getFinalStateOR_FA(finalState1: fa1.finalStates, finalState2: fa2.finalStates, states: states)
    
    println("Final State \(newFinalState)")
    
    let newDFA = dfa(table: newT_T, initialState: newInitialState, finalState: newFinalState, letter: letters)
    
    return newDFA
}

func getFinalStateOR_FA(#finalState1: [Int], #finalState2: [Int], #states: [String]) -> [Int] {
    
    var returnFinalState = [Int]()
    
    for var f:Int = 0; f < states.count; f++ {
        let s = states[f]
        
        for fa in finalState1 {
            if fa == s[0].toInt()! {
                if !(contains(returnFinalState, f)) {
                    returnFinalState.append(f)
                }
                break
            }
        }
        
        for fa in finalState2 {
            if fa == s[1].toInt()! {
                if !(contains(returnFinalState, f)) {
                    returnFinalState.append(f)
                }
                break
            }
        }
    }
    
    return returnFinalState
}

func fa_complement(fa: dfa) -> dfa {
    
    var newFinalState = [Int]()
    
    for var i:Int = 0; i < fa.transitionTable.count; i++ {
        if !contains(fa.finalStates, i) {
            newFinalState.append(i)
        }
    }
    
    let newDFA = dfa(table: fa.transitionTable, initialState: fa.initialState, finalState: newFinalState, letter: fa.char)
    
    return newDFA
}

func fa_intersection(fa1: dfa, fa2: dfa) -> dfa {

    let fa1Complement = fa_complement(fa1)
    let fa2Complement = fa_complement(fa2)
    
    let fa3OR = fa_or(fa1Complement, fa2Complement)
    
    let newDFa = fa_complement(fa3OR)
    
    return newDFa
}

//MARK: Main Method (You can say)
//Declaring variables
var letters:[Character] = ["a", "b"]
var tt1 = [ [1,3], [3,2], [2,2], [3,3] ]
var tt2 = [ [3,1], [2,1], [2,1], [3,3] ]

var initialState:Int = 0

var fs1:[Int] = [2]
var fs2:[Int] = [2]

var fa1 = dfa(table: tt1, initialState: initialState, finalState: fs1, letter: letters)

var fa2 = dfa(table: tt2, initialState: initialState, finalState: fs2, letter: letters)

//var fa3 = fa_or(fa1, fa2)

//var fa4 = fa_concat(fa1, fa2)

var fa5 = fa_complement(fa1)

//
//fa3.validation("ba")
//fa3.validation("ab")
