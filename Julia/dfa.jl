include("automata.jl")

"""
A Deterministic Finite Automaton (DFA)

Has only 3 components
 - the current state the DFA is in
 - the start state (same as `.aut.q₀`)
 - all other components are encapsulated in Automaton
   since they are static and need not have to be mutable
"""
mutable struct DFA <: AbstractFiniteAutomaton
    cur_state::State
    aut::Automaton
end

function DFA(aut::Automaton)
    DFA(aut.q₀, aut)
end

DFA(δ::AbstractDict,
    q₀::State,
    F::AbstractSet{State}) = DFA(Automaton(Dict(k => [v,] for (k, v) in δ),
                                           q₀, F))


"""
    transition!(dfa::DFA, char::Char)::Bool

Applies a transition from current state using the symbol
char. Returns `false` when transition fails (Note: does
not throw an exception for performance reasons) and true
when the transition succeeds while updating the current
state of the DFA.
"""
function transition!(M::DFA, a)::Bool
    key = (M.cur_state, a)

    if !haskey(M.aut.δ, key)
        return false
    end

    M.cur_state = M.aut.δ[key][1]
    return true
end


"""
    reset!(dfa::DFA)

Resets the DFA to it's start state.
"""
function reset!(M::DFA)
    M.cur_state = M.aut.q₀
end

function accepting(M::DFA)::Bool
    M.cur_state ∈ M.aut.F
end
