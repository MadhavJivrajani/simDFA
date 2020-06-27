package main

import (
	"fmt"
)

type State struct {
	isStart, isFinal bool
	name             string
}

type DFA struct {
	sigma       []string
	transitions map[string][][]string
	states      map[string]*State
	rejected    bool
	currState   *State
}

func exists(vals []string, item string) bool {
	for _, val := range vals {
		if val == item {
			return true
		}
	}
	return false
}

func NewDFA(alphabet []string) *DFA {
	var machine DFA
	machine.sigma = alphabet
	machine.states = make(map[string]*State)
	machine.transitions = make(map[string][][]string)

	return &machine
}

func (machine *DFA) AddState(isStart bool,
	isFinal bool,
	name string) {
	if _, exists := machine.states[name]; exists {
		fmt.Printf("State with name %s already exists!\n", name)
	} else {
		state := &State{isStart, isFinal, name}
		machine.states[state.name] = state
	}
}

func (machine *DFA) AddTransition(currState string,
	inputSymbol string,
	nextState string) {
	if flag := exists(machine.sigma, inputSymbol); !flag {
		fmt.Println("Input symbol not part of alphabet.")
		return
	}

	if _, exists := machine.states[currState]; !exists {
		fmt.Println("Current state is not part of the existing set of states.")
		return
	}

	if _, exists := machine.states[nextState]; !exists {
		fmt.Println("Next state is not part of the existing set of states.")
		return
	}

	machine.transitions[inputSymbol] = append(machine.transitions[inputSymbol],
		[]string{currState, inputSymbol, nextState})
}

func (machine *DFA) GetStartState() *State {
	var startState *State
	for _, tempState := range machine.states {
		if tempState.isStart {
			startState = tempState
			break
		}
	}
	return startState
}

func (machine *DFA) GetFinalStates() []string {
	var finalStates []string
	for _, tempState := range machine.states {
		if tempState.isFinal {
			finalStates = append(finalStates, tempState.name)
		}
	}
	return finalStates
}

func (machine *DFA) ApplyTransition(partialTransition []string) {
	symbol := partialTransition[1]
	currState := partialTransition[0]

	var applicableTransitions [][]string
	for _, transition := range machine.transitions[symbol] {
		if currState == transition[0] {
			applicableTransitions = append(applicableTransitions, transition)
		}
	}

	if len(applicableTransitions) == 0 {
		machine.currState = machine.states[currState]
		machine.rejected = true
	} else {
		/*
		   since it is a DFA there will be only one transition for the
		   defined current state, next state and input symbol.
		*/
		machine.currState = machine.states[applicableTransitions[0][2]]
	}
}

func (machine *DFA) EvaluateString(toEvaluate string) {
	checkMembership := make(map[string]bool)
	for _, char := range toEvaluate {
		checkMembership[string(char)] = true
	}

	for _, char := range toEvaluate {
		if _, exists := checkMembership[string(char)]; !exists {
			fmt.Printf("'%s' symbol is not part of the alphabet.\n", string(char))
			return
		}
	}

	machine.rejected = false
	startState := machine.GetStartState()
	machine.currState = startState

	for _, symbol := range toEvaluate {
		if machine.rejected {
			fmt.Println("Rejected.")
			return
		}
		machine.ApplyTransition([]string{machine.currState.name, string(symbol)})
	}

	finalStates := machine.GetFinalStates()
	if flag := exists(finalStates, machine.currState.name); flag {
		fmt.Println("Accepted!")
	} else {
		fmt.Println("Rejected.")
	}
}
