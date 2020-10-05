# Simulation of Deterministic Finite Automata 

This is a product of boredom and curiosity during the Covid-19 lockdown.

This can simulate any deterministic finite automata, I'd like to simulate NFAs as well, so if any of you are interested, please feel free to contribute!

Languages implemented in so far:
- Python
- JavaScript
- C++
- Go
- Racket
- Haskell (NFA evaluator included)
- Nim
- Java
- Rust

Here's an example in python of a DFA that accepts no more than 3 a's:

```py
#initialize the DFA with its alphabet
dfa = DFA(['a','b'])

#add states to the DFA
dfa.add_state(1, 1, 'q0')
dfa.add_state(0, 1, 'q1')
dfa.add_state(0, 1, 'q2')
dfa.add_state(0, 1, 'q3')
dfa.add_state(0, 0, 'q4')

#add transitions to the DFA 
dfa.add_transition('q0', 'a', 'q1')
dfa.add_transition('q0', 'b', 'q0')
dfa.add_transition('q1', 'a', 'q2')
dfa.add_transition('q1', 'b', 'q1')
dfa.add_transition('q2', 'a', 'q3')
dfa.add_transition('q2', 'b', 'q2')
dfa.add_transition('q3', 'a', 'q4')
dfa.add_transition('q3', 'b', 'q3')
dfa.add_transition('q4', 'a', 'q4')
dfa.add_transition('q4', 'b', 'q4')
```

And finally, evaluate an input string!

```py
dfa.evaluate_string("aaab")  #Accepted!
dfa.evaluate_string("aaaab") #Rejected
dfa.evaluate_string("")	     #Accepted!
dfa.evaluate_string("bbbb")  #Accepted!
```
