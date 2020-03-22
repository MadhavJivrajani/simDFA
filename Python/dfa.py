class State:
    def __init__(self, is_start, is_final, name):
        """
        is_start: Whether the state is a start state or not (0 or 1)
        is_final: Whether the state is a final state or not (0 or 1)
        name : Name of the state, expected to be unique
        """
        self.is_final = is_final
        self.is_start = is_start
        self.name = name
    
class DFA:
    def __init__(self, alphabet):
        """
        sigma: Set of symbols accepted by the language of the DFA
        transitions: Each transition is of the form (current state, input symbol, next state) 
                     A dictionary with input symbols as keys is maintained for transitions
                     Each key will have a list of tuple(s)
        states: Set of states of the DFA
                A dictionary with state names as keys and values as an object of the class State
        rejected: Flag to indicated whether a state ends up "dead" or there is not defined transisiton for the current input symbol
        curr_state : Keeps track of the state the DFA is currently in after each transistion 
        """
        self.sigma = alphabet        
        self.transitions = {}
        self.states = {}
        self.rejected = 0
        
        self.curr_state = None
    
    def add_state(self, is_start, is_final, name):
        if name not in self.states:
            self.states[name] = State(is_start, is_final, name)
        else:
            print("State already exists!")
    
    def add_transition(self, curr_state, input_symbol, next_state):
        if input_symbol not in self.sigma:
            print("Input symbol not part of alphabet")
            return None
        
        if curr_state not in self.states:
            print("Current state is not part of the existing set of states")
            return None
        if next_state not in self.states:
            print("Next state is not part of the existing set of states")
            return None
        
        if input_symbol not in self.transitions:
            self.transitions[input_symbol] = []
        
        self.transitions[input_symbol].append((curr_state, input_symbol, next_state))
    
    def get_start_state(self):
        for state in self.states:
            if self.states[state].is_start:
                return self.states[state]
            
    def get_final_states(self):
        final = []
        for state in self.states:
            if self.states[state].is_final:
                final.append(self.states[state].name)
                
        return final
    
    def apply_transition(self, partial_transition):
        symbol = partial_transition[1]
        curr_state = partial_transition[0]
        
        applicable_transitions = [i for i in self.transitions[symbol] if curr_state == i[0]]

        if len(applicable_transitions):
            self.curr_state = self.states[applicable_transitions[0][2]]
        else:
            self.curr_state = self.states[curr_state]
            self.rejected = 1
    
    def evaluate_string(self, string):
        for symbol in list(set(string)):
            if symbol not in self.sigma:
                print("'"+symbol+"' is not part of the alphabet")
                return
        
        self.rejected = 0
        start_state = self.get_start_state()
        final_states = self.get_final_states()
        
        self.curr_state = start_state
        
        for symbol in list(string):
            if not self.rejected:
                self.apply_transition((self.curr_state.name, symbol))
            else:
                print("Rejected")
                return
        
        if self.curr_state.name in final_states:
            print("Accepted!")
        else:
            print("Rejected")
