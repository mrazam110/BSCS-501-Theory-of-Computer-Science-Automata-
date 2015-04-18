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
    var xStates = [String]()
    var yStates = [String]()
    
    var x:String!
    var y:String!
    
    x = "\(fa1.initialState)"
    xStates.append(x)
    
    x = "2"
    
    if contains(fa1.finalStates, x.toInt()!){
        if y != nil {
            y = "\(y)\(fa2.initialState)"
        }else{
            y = "\(fa2.initialState)"
        }
        yStates.append(y)
    }
    
    for _x in xStates {
        fa1.transition(_x.toInt()!, charCheck: fa1.char[0])
    }
    
    return fa1
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


//MARK: Main Method (You can say)
//Declaring variables
var letters:[Character] = ["a", "b"]
var tt1 = [ [1,3], [3,2], [2,2], [3,3] ]
var tt2 = [ [3,1], [2,2], [2,1], [3,3] ]

var initialState:Int = 0

var fs1:[Int] = [2]
var fs2:[Int] = [0, 2]

var fa1 = dfa(table: tt1, initialState: initialState, finalState: fs1, letter: letters)

var fa2 = dfa(table: tt2, initialState: initialState, finalState: fs2, letter: letters)

var fa3 = fa_or(fa1, fa2)

var fa4 = fa_concat(fa1, fa2)

fa3.validation("ba")
fa3.validation("ab")
