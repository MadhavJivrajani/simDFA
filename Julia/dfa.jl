"""
A "type" to indicate a state of an automaton
"""
State = String


"""
An automaton having:
 - A set of start states q₀
 - A set of final/accepting states F
 - A set of input symbols (alphabet) Σ
 - A set of states Q
 - A transition function δ

Notations are from Wikipedia:
https://en.wikipedia.org/wiki/Deterministic_finite_automaton
"""
struct Automaton
    q₀::Set{State}
    F::Set{State}
    Σ::Set{Char}
    Q::Set{State}
    δ::Dict{Tuple{State,Char},State}
end

Automaton(Σ::String, F, δ) = Automaton(collect(Σ), F, δ)


function Automaton(δ::Dict{Tuple{State,Char},State},
        q₀::Set{State},
                  F::Set{State})
    # infer alphabet from transitions
    Σ = Set{Char}()

    # Q will be set of all states
    Q = Set{State}()
    # reached will be set of destination states
    reached = Set{State}()
    for (k, v) in δ
        # destination state
        d_state = State(v)
        push!(Q, d_state)

        # non-final source state
        s_state = State(k[1])
        push!(Q, s_state)

        push!(Σ, k[2])  # add to alphabet
    end

    Automaton(q₀, F, Σ, Q, δ)
end

"""
A Deterministic Finite Automaton (DFA)

Has only 3 components
 - the current state the DFA is in
 - the start state (same as `.aut.q₀`)
 - all other components are encapsulated in Automaton
   since they are static and need not have to be mutable
"""
mutable struct DFA
    cur_state::State
    q₀::State
    aut::Automaton
end

function DFA(aut::Automaton)
    q₀ = collect(aut.q₀)[1]
    DFA(q₀, q₀, aut)
end

DFA(δ::Dict{Tuple{State,Char},State},
    q₀::State,
    F::Set{State}) = DFA(Automaton(δ, Set([q₀]), F))


"""
    transition!(dfa::DFA, char::Char)::Bool

Applies a transition from current state using the symbol
char. Returns `false` when transition fails (Note: does
not throw an exception for performance reasons) and true
when the transition succeeds while updating the current
state of the DFA.
"""
function transition!(M::DFA, a::Char)::Bool
    key = (M.cur_state, a)

    if !haskey(M.aut.δ, key)
        return false
    end

    M.cur_state = M.aut.δ[key]
    return true
end


"""
    reset!(dfa::DFA)

Resets the DFA to it's start state.
"""
function reset!(M::DFA)
    M.cur_state = M.q₀
end


"""
    evaluate!(M::DFA, w::String)

Evaluates the input string using the DFA.
The DFA is reset before evaluating.

Returns `true` if string is accepted and
`false` otherwise. The final state is stored
in `M.cur_state`
"""
function evaluate!(M::DFA, w::String)
    reset!(M)

    for a in w
        transition!(M, a) || return false
    end

    M.cur_state ∈ M.aut.F ? true : false
end
