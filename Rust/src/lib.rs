//How to run - `cargo test`

use std::cmp::Eq;
use std::collections::HashMap;
use std::hash::Hash;

#[derive(Debug, Default, Copy, Eq, PartialEq, Hash, Clone)]
pub struct State {
    is_start: bool,
    is_final: bool,
    name: char,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct Transition {
    from_state: State,
    to_state: State,
}
#[derive(Debug, Default, Clone)]
pub struct DFA {
    alphabet: [char; 2],
    states: HashMap<State, HashMap<Transition, char>>,
    reject: bool,
    current_state: State,
    num_of_start_states: i32,
}

impl State {
    pub fn init_state(is_start: bool, is_final: bool, name: char) -> Self {
        State {
            is_start: is_start,
            is_final: is_final,
            name: name,
        }
    }
}

impl Transition {
    pub fn init_transition(from_state: State, to_state: State) -> Self {
        let new_transition = Transition {
            from_state: from_state,
            to_state: to_state,
        };
        new_transition
    }
}

impl DFA {
    pub fn add_alphabet(&mut self, alphabet: [char; 2]) {
        self.alphabet = alphabet;
    }

    fn _contains_state(&self, state: State) -> bool {
        let mut res: bool = false;
        if let Some(_i) = self.states.get(&state) {
            res = true;
        }
        res
    }

    pub fn add_state(&mut self, state: State) {
        if state.is_start == true {
            self.num_of_start_states += 1;
        }
        self.states.insert(state, HashMap::new());
    }

    pub fn add_transition(&mut self, transition: &Transition, input: char) {
        if self.alphabet.contains(&(input)) == false {
            println!("Input symbol not part pf alphabet!");
        }
        if self._contains_state(transition.from_state) == false {
            println!("Current state is not part of the existing set of states!");
        }
        if self._contains_state(transition.to_state) == false {
            println!("Next state is not part of the existing set of states!");
        }

        if let Some(i) = self.states.get_mut(&(transition.from_state)) {
            i.insert(*transition, input);
        }
    }

    fn _get_start_state(&self) -> State {
        let mut start_state = self.current_state;
        for state in self.states.keys() {
            if state.is_start == true {
                start_state = *state;
                break;
            }
        }
        return start_state;
    }

    fn _get_final_states(&self) -> Vec<State> {
        let mut final_states: Vec<State> = Vec::new();
        for state in self.states.keys() {
            if state.is_final == true {
                final_states.push(*state);
            }
        }
        final_states
    }

    fn _apply_transition(&mut self, partial_transition: (State, char)) {
        let symbol: char = partial_transition.1;
        let current_state: State = partial_transition.0;

        let mut applicable_transitions: Vec<(Transition, char)> = Vec::new();
        for x in self.states.values() {
            for (transition, input) in x.iter() {
                if current_state.is_final == transition.from_state.is_final
                    && current_state.is_start == transition.from_state.is_start
                    && current_state.name == transition.from_state.name
                    && *input == symbol
                {
                    applicable_transitions.push((*transition, *input));
                };
            }
        }
        if applicable_transitions.len() > 0 {
            self.current_state = applicable_transitions.remove(0).0.to_state;
        } else {
            self.current_state = current_state;
            self.reject = true;
        }
    }

    pub fn evaluate_string(&mut self, input_string: String) -> Result<String, String> {
        if self.num_of_start_states > 1 {
            return Err("More than one start state detected. Exiting".to_string());
        }

        for input in input_string.chars() {
            if self.alphabet.contains(&input) == false {
                return Err(format!("{} is not part of the alphabet.", input));
            }
        }

        self.reject = false;
        let start_state: State = self._get_start_state();

        self.current_state = start_state;

        for symbol in input_string.chars() {
            if self.reject == false {
                self._apply_transition((self.current_state, symbol));
            } else {
                // println!("Rejected :(");
                return Ok("Rejected with no errors.".to_string());
            }
        }

        if self.current_state.is_final == true {
            // println!("Accepted! :)");
            Ok("Accepted with no errors.".to_string())
        } else {
            // println!("Rejected :(");
            Ok("Rejected with no errors.".to_string())
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn check_dfa() {
        let s0: State = State::init_state(true, true, 'a');
        let s1: State = State::init_state(false, true, 'b');
        let s2: State = State::init_state(false, true, 'c');
        let s3: State = State::init_state(false, true, 'd');
        let s4: State = State::init_state(false, false, 'e');
        let t0: Transition = Transition::init_transition(s0, s1);
        let t1: Transition = Transition::init_transition(s0, s0);
        let t2: Transition = Transition::init_transition(s1, s2);
        let t3: Transition = Transition::init_transition(s1, s1);
        let t4: Transition = Transition::init_transition(s2, s3);
        let t5: Transition = Transition::init_transition(s2, s2);
        let t6: Transition = Transition::init_transition(s3, s4);
        let t7: Transition = Transition::init_transition(s3, s3);
        let t8: Transition = Transition::init_transition(s4, s4);
        let mut dfa: DFA = DFA::default();
        dfa.add_alphabet(['a', 'b']);
        dfa.add_state(s0);
        dfa.add_state(s1);
        dfa.add_state(s2);
        dfa.add_state(s3);
        dfa.add_state(s4);
        dfa.add_transition(&t0, 'a');
        dfa.add_transition(&t1, 'b');
        dfa.add_transition(&t2, 'a');
        dfa.add_transition(&t3, 'b');
        dfa.add_transition(&t4, 'a');
        dfa.add_transition(&t5, 'b');
        dfa.add_transition(&t6, 'a');
        dfa.add_transition(&t7, 'b');
        dfa.add_transition(&t8, 'a');
        dfa.add_transition(&t8, 'b');

        assert_eq!(
            dfa.evaluate_string(String::from("aaab")),
            Ok("Accepted with no errors.".to_string())
        );
        assert_eq!(
            dfa.evaluate_string(String::from("aaaab")),
            Ok("Rejected with no errors.".to_string())
        );
        assert_eq!(
            dfa.evaluate_string(String::from("")),
            Ok("Accepted with no errors.".to_string())
        );
        assert_eq!(
            dfa.evaluate_string(String::from("bbbb")),
            Ok("Accepted with no errors.".to_string())
        );
    }
}
