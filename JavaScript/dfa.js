class State {
    constructor(is_start, is_final, name) {
	this.is_start = is_start;
	this.is_final = is_final;
	this.name = name;
    }
}

class DFA {
    constructor(alphabet) {
	this.sigma = alphabet;
	this.transitions = {};
	this.states = {};
	this.rejected = 0;

	this.curr_state = null;
    }

    add_state(is_start, is_final, name) {
	if(!this.states[name]) {
	    this.states[name] = new State(is_start, is_final, name);
	} else {
	    alert("State already exists!");
	}
    }

    add_transition(curr_state, input_symbol, next_state) {
	if(!this.sigma.includes(input_symbol)) {
	    alert("Input symbol not part of the alphabet");
	}
	if(!curr_state in this.states) {
	    alert("Current set is not part of the existing set of states");
	}
	if(!next_state in this.states) {
	    alert("Next state is not part of the existing set of states");
	}

	if(!this.transitions[input_symbol]) {
	    this.transitions[input_symbol] = [];
	}

	this.transitions[input_symbol].push([curr_state, input_symbol, next_state]);
    }

    get_start_state() {
	for(let state in this.states) {
	    if(this.states[state].is_start == 1) {
		return this.states[state];
	    }
	}
    }

    get_final_states() {
	let final_states = [];
	for(let state in this.states) {
	    if(this.states[state].is_final == 1) {
		final_states.push(this.states[state].name);
	    }
	}
	return final_states;
    }

    apply_transition(partial_transition) {
	let symbol = partial_transition[1];
	let curr_state = partial_transition[0];

	let applicable_transitions = [];
	for(let i = 0; i < this.transitions[symbol].length; i++) {
	    if(this.transitions[symbol][i][0] === curr_state) {
		applicable_transitions.push(this.transitions[symbol][i]);
	    }
	}

	if(applicable_transitions.length != 0) {
	    this.curr_state = this.states[applicable_transitions[0][2]];
	} else {
	    this.curr_state = this.states[curr_state];
	    this.rejected = 1;
	}
    }

    evaluate_string(string) {
	let set = new Set(string);
	for(let i=0;i<[...set].length;i++) {
	    if(!this.sigma.includes([...set][i])) {
		alert("Symbol not part of the alphabet");
		return null;
	    }
	}

	this.rejected = 0;
	let start_state = this.get_start_state();
	let final_states = this.get_final_states();

	this.curr_state = start_state;
	let string_arr = [...string];
	for(let i=0;i<string_arr.length;i++) {
	    if(this.rejected != 1) {
		this.apply_transition([this.curr_state.name, string_arr[i]]);
	    }
	    else {
		alert("Rejected");
		return null;
	    }
	}

	if(final_states.includes(this.curr_state.name)) {
	    alert("Accepted!");
	} else {
	    alert("Rejected");
	}
    }
}

let dfa = new DFA(['a','b']);

dfa.add_state(1, 1, 'q0');
dfa.add_state(0, 1, 'q1');
dfa.add_state(0, 1, 'q2');
dfa.add_state(0, 1, 'q3');
dfa.add_state(0, 0, 'q4');


dfa.add_transition('q0', 'a', 'q1');
dfa.add_transition('q0', 'b', 'q0');
dfa.add_transition('q1', 'a', 'q2');
dfa.add_transition('q1', 'b', 'q1');
dfa.add_transition('q2', 'a', 'q3');
dfa.add_transition('q2', 'b', 'q2');
dfa.add_transition('q3', 'a', 'q4');
dfa.add_transition('q3', 'b', 'q3');
dfa.add_transition('q4', 'a', 'q4');
dfa.add_transition('q4', 'b', 'q4');

dfa.evaluate_string("aaab");
dfa.evaluate_string("aaaab");
