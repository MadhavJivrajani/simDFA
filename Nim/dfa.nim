import tables

type State = ref object
    is_start : bool
    is_final : bool
    name : string

type DFA = object
    sigma : seq[string]
    transitions : OrderedTableRef[string, seq[(string, string, string)]]
    states : OrderedTableRef[string, State]
    rejected : bool
    curr_state : State


proc new_DFA(alphabet : seq[string]): ref DFA =
    var dfa : ref DFA = new(DFA)
    dfa.sigma = alphabet
    dfa.rejected = false
    dfa.curr_state = nil
    dfa.states = newOrderedTable[string, State]()
    dfa.transitions = newOrderedTable[string, seq[(string, string, string)]]()
    return dfa

proc add_DFA_state(dfa : ref DFA, is_start : bool, is_final : bool, name : string): void =
    if not dfa.states.contains(name):
        let state : State = State(is_start : is_start, is_final : is_final, name : name)
        dfa.states[name] = state
    else:
        echo "State already exists"

proc add_DFA_transition(dfa : ref DFA, curr_state : string, input_symbol : string, next_state : string): void =
    if not (input_symbol in dfa.sigma):
        echo "Input symbol not part of the alphabet"
        return
    if not dfa.states.contains(curr_state):
        echo "Current state is not part of the existing set of states"
        return
    if not dfa.states.contains(next_state):
        echo "Next state is not part of the existing set of states"
        return
    if not dfa.transitions.contains(input_symbol):
        dfa.transitions[input_symbol] = newSeq[(string, string, string)]()
    dfa.transitions[input_symbol].add( (curr_state, input_symbol, next_state) )

proc get_DFA_start_state(dfa : ref DFA): State =
    for key, value in dfa.states.pairs:
        if value.is_start == true:
            return value

proc get_DFA_final_states(dfa : ref DFA): seq[string] =
    var final_s : seq[string] = newSeq[string]()
    for key, value in dfa.states.pairs:
        if value.is_final == true:
            final_s.add(value.name)
    return final_s


proc apply_DFA_transition(dfa : ref DFA, partial_transition : seq[string]): void =
    let
        symbol : string = partial_transition[1]
        current : string = partial_transition[0]
        total : seq[(string, string, string)] = dfa.transitions[symbol]

    var applicable : seq[(string, string, string)]

    for i in countup(0, total.len()-1):
        if total[i][0] == current:
            applicable.add(total[i])

    if applicable.len() != 0:
        dfa.curr_state = dfa.states[applicable[0][2]]
    else:
        dfa.rejected = true
        dfa.curr_state = dfa.states[current]


proc evaluate_DFA_string(dfa : ref DFA, str : string): void =
    for i in countup(0, str.len()-1):
        var symb: string
        symb.add(str[i])
        if not (symb in dfa.sigma):
            echo symb & " is not part of the alphabet"
            return

    dfa.rejected = false
    let start : State = dfa.get_DFA_start_state()
    let final : seq[string] = dfa.get_DFA_final_states()

    dfa.curr_state = start

    for i in countup(0, str.len()-1):
        if not dfa.rejected:
            var symb: string
            symb.add(str[i])
            let partial : seq[string] = @[dfa.curr_state.name, symb]
            dfa.apply_DFA_transition(partial)
        else:
            echo "Rejected"
            return

    if final.contains(dfa.curr_state.name):
        echo "Accepted!"
    else:
        echo "Rejected"

let alphabet : seq[string] = @["a", "b"]
let dfa : ref DFA = new_DFA(alphabet)

dfa.add_DFA_state(true, true, "q0")
dfa.add_DFA_state(false, true, "q1")
dfa.add_DFA_state(false, true, "q2")
dfa.add_DFA_state(false, true, "q3")
dfa.add_DFA_state(false, false, "q4")

dfa.add_DFA_transition("q0", "a", "q1")
dfa.add_DFA_transition("q0", "b", "q0")
dfa.add_DFA_transition("q1", "a", "q2")
dfa.add_DFA_transition("q1", "b", "q1")
dfa.add_DFA_transition("q2", "a", "q3")
dfa.add_DFA_transition("q2", "b", "q2")
dfa.add_DFA_transition("q3", "a", "q4")
dfa.add_DFA_transition("q3", "b", "q3")
dfa.add_DFA_transition("q4", "a", "q4")
dfa.add_DFA_transition("q4", "b", "q4")

dfa.evaluate_DFA_string("aaab")
dfa.evaluate_DFA_string("aaaab")
dfa.evaluate_DFA_string("")
dfa.evaluate_DFA_string("bbbb")