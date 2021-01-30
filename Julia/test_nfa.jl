using Test

include("nfa.jl")

M = NFA(Dict(
             ("q0", '0') => ["q0", "q1"],
             ("q0", '1') => ["q0", "q2"],
             ("q1", '0') => ["q3",],
             ("q2", '0') => ["q2", "q3"],
             ("q2", '1') => ["q3",],
             ("q3", '0') => ["q3",],
             ("q3", '1') => ["q3",]
       ), "q0", Set(["q3"]))

@test !evaluate!(M, "")
@test !evaluate!(M, "01")
@test evaluate!(M, "00")
@test evaluate!(M, "1111110000")

# Taken from here:
# https://www.cs.wcupa.edu/rkline/assets/img/FCS/nfas/n2d2.jpg?1379001651
# regex: (a* + (ab)*) b*
M = NFA(Dict(
             ("1",  λ)  => ["2", "3"],
             ("2",  λ)  => ["5"],
             ("2", 'a') => ["2"],
             ("5", 'b') => ["5"],
             ("3", 'a') => ["4"],
             ("3",  λ)  => ["5"],
             ("4", 'b') => ["3"],
       ), "1", Set(["5"]))

@test evaluate!(M, "")
@test evaluate!(M, "b")
@test evaluate!(M, "a")
@test evaluate!(M, "ab")
@test evaluate!(M, "aa")
@test evaluate!(M, "abab")
@test !evaluate!(M, "aba")
