using Test

include("dfa.jl")

M = DFA(Dict(
         ("q0", 'a') => "q1",
         ("q0", 'b') => "q0",
         ("q1", 'a') => "q2",
         ("q1", 'b') => "q1",
         ("q2", 'a') => "q3",
         ("q2", 'b') => "q2",
         ("q3", 'a') => "q4",
         ("q3", 'b') => "q3",
         ("q4", 'a') => "q4",
         ("q4", 'b') => "q4"
       ), "q0", Set(["q0", "q1", "q2", "q3"]))

@test evaluate!(M, "")
@test evaluate!(M, "aaab")
@test evaluate!(M, "bbbb")
@test !evaluate!(M, "aaaab")
