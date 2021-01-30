include("automata.jl")

const λ = 'λ'

mutable struct NFA <: AbstractFiniteAutomaton
    cur_states::Set{State}
    aut::Automaton
end

function NFA(aut::Automaton)
    NFA(Set([aut.q₀]), aut)
end

NFA(δ::AbstractDict,
    q₀::State,
    F::AbstractSet{State}) = NFA(Automaton(δ, q₀, F))

function try_λ_transitions!(M::NFA)
    states_to_try = copy(M.cur_states)
    while !isempty(states_to_try)
        state = pop!(states_to_try)
        key = (state, λ)
        if haskey(M.aut.δ, key)
            next_states = M.aut.δ[key]
            push!(M.cur_states, next_states...)
            push!(states_to_try, next_states...)
        end
    end
end

function transition!(M::NFA, a)::Bool
    old_states = copy(M.cur_states)
    empty!(M.cur_states)
    for state in old_states
        key = (state, a)
        if haskey(M.aut.δ, key)
            push!(M.cur_states, M.aut.δ[key]...)
        end
    end

    isempty(M.cur_states) ? false : true
end

function reset!(M::NFA)
    M.cur_states = Set([M.aut.q₀])
end

function accepting(M::NFA)
    !isdisjoint(M.cur_states, M.aut.F)
end

function evaluate!(M::NFA, w)
    reset!(M)

    try_λ_transitions!(M)

    for a in w
        transition!(M, a) || return false
        try_λ_transitions!(M)
    end

    accepting(M)
end
