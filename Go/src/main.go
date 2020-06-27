package main

func main() {
	machine := NewDFA([]string{"a", "b"})

	//add states to the DFA
	machine.AddState(true, true, "q0")
	machine.AddState(false, true, "q1")
	machine.AddState(false, true, "q2")
	machine.AddState(false, true, "q3")
	machine.AddState(false, false, "q4")

	//add transitions to the DFA
	machine.AddTransition("q0", "a", "q1")
	machine.AddTransition("q0", "b", "q0")
	machine.AddTransition("q1", "a", "q2")
	machine.AddTransition("q1", "b", "q1")
	machine.AddTransition("q2", "a", "q3")
	machine.AddTransition("q2", "b", "q2")
	machine.AddTransition("q3", "a", "q4")
	machine.AddTransition("q3", "b", "q3")
	machine.AddTransition("q4", "a", "q4")
	machine.AddTransition("q4", "b", "q4")

	machine.EvaluateString("aaab")
	machine.EvaluateString("aaaab")
	machine.EvaluateString("")
	machine.EvaluateString("bbbb")
}
