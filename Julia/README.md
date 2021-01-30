# DFA

Deterministic Finite Automaton simulator implemented in Julia.

 - Supports arbitrary alphabet
 - Simple interface
 - Fast (see Performance section below)

## Usage

A DFA can be "instantiated" using just the transition function (as a `Dict`), the start state and the set of final states.

```julia
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
```

A string can be evaluated using:
```julia
evaluate!(M, "aaab")  # returns true
```

## Performance

Some basic performance testing was done using the above DFA (10 transitions, 5 states) and a string consisting of `a`s.

```julia
julia> @btime evaluate!(M, "a"^1)
  77.851 ns (0 allocations: 0 bytes)
true

julia> @btime evaluate!(M, "a"^10)
  495.948 ns (1 allocation: 32 bytes)
false

julia> @btime evaluate!(M, "a"^100)
  4.190 μs (1 allocation: 128 bytes)
false

julia> @btime evaluate!(M, "a"^1000)
  41.633 μs (1 allocation: 1.06 KiB)
false

julia> @btime evaluate!(M, "a"^10000)
  423.215 μs (1 allocation: 9.88 KiB)
false

julia> @btime evaluate!(M, "a"^100000)
  4.660 ms (1 allocation: 97.75 KiB)
false

julia> @btime evaluate!(M, "a"^1000000)
  49.663 ms (1 allocation: 976.69 KiB)
false
```

Even a string with 1 million symbols can be evaluated in ~50ms!

It scales linearly with the size of the input string.

(the allocations are only for the input string, there are no allocations performed during evaluation)

## Tests

Some basic tests are included in [`test.jl`](./test.jl).


# NFA

Non-deterministic Finite Automaton (NFA) simulator in Julia.

 - Supports arbitrary alphabet
 - Supports lambda-transitions
 - Simple interface
 - Not as fast the DFA simulator

## Usage

A NFA can be instantiated using just the transition function (as a `Dict`), the start state and the set of final states.

```julia
M = NFA(Dict(
             ("q0", '0') => ["q0", "q1"],
             ("q0", '1') => ["q0", "q2"],
             ("q1", '0') => ["q3",],
             ("q2", '0') => ["q2", "q3"],
             ("q2", '1') => ["q3",],
             ("q3", '0') => ["q3",],
             ("q3", '1') => ["q3",]
       ), "q0", Set(["q3"]))
```

Lambda transitions can be added by using the literal `λ` as the transition symbol.

A string can be evaluated using:
```julia
evaluate!(M, "1111110000")
```

## Tests

The tests in [`test_nfa.jl`](./test_nfa.jl) includes 2 NFAs - one with lambda transitions and one without.

## Performance

Some basic performance testing was done using the 2nd NFA from the tests (8 transitions, 5 states) and a string consisting of `a`s.

```julia
julia> @btime evaluate!(M, "a"^1)
  1.675 μs (37 allocations: 2.28 KiB)
true

julia> @btime evaluate!(M, "a"^10)
  6.872 μs (164 allocations: 11.59 KiB)
true

julia> @btime evaluate!(M, "a"^100)
  59.676 μs (1424 allocations: 104.50 KiB)
true

julia> @btime evaluate!(M, "a"^1000)
  599.947 μs (14024 allocations: 1.01 MiB)
true

julia> @btime evaluate!(M, "a"^10000)
  7.011 ms (140024 allocations: 10.08 MiB)
true

julia> @btime evaluate!(M, "a"^100000)
  77.404 ms (1400024 allocations: 100.80 MiB)
true

julia> @btime evaluate!(M, "a"^1000000)
  840.357 ms (14000024 allocations: 1008.04 MiB)
true
```

It is an order of magnitude slower than the DFA implementation, but it scales linearly. The memory usage is also much higher (which causes the slowdown).

Most of the slowdown is from copying arrays for checking lambda transitions. If you see any scope for optimisation, please do contribute!
