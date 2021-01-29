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
    q₀::State
    F::Set{State}
    Σ::Set{Char}
    Q::Set{State}
    δ::Dict{Tuple{State,Char},Vector{State}}
end

function Automaton(δ::AbstractDict{},
                   q₀::State,
                   F::AbstractSet{State})
    # infer alphabet from transitions
    Σ = Set{Char}()

    # Q will be set of all states
    Q = Set{State}()
    # reached will be set of destination states
    reached = Set{State}()
    for (k, v) in δ
        # destination states
        for d_state in v
            push!(Q, State(d_state))
        end

        # non-final source state
        push!(Q, State(k[1]))

        push!(Σ, k[2])  # add to alphabet
    end

    Automaton(q₀, F, Σ, Q, δ)
end

abstract type AbstractFiniteAutomaton end

"""
    evaluate!(M::AbstractFiniteAutomaton, w::String)

Evaluates the input string using the given automaton.
The automaton is reset before evaluating.

Returns `true` if string is accepted and
`false` otherwise.
"""
function evaluate!(M::AbstractFiniteAutomaton, w)
    reset!(M)

    for a in w
        transition!(M, a) || return false
    end

    accepting(M)
end
