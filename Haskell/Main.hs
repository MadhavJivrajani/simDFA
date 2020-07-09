import DFA (Transition(..), makeDFA, parse)

q      = [ "q0", "q1", "q2", "q3", "q4"]
sigma  = "ab"
q0     = "q0"
accept = ["q0", "q1", "q2", "q3"]
delta  = [
    Transition "q0" 'a' "q1",
    Transition "q0" 'b' "q0",
    Transition "q1" 'a' "q2",
    Transition "q1" 'b' "q1",
    Transition "q2" 'a' "q3",
    Transition "q2" 'b' "q2",
    Transition "q3" 'a' "q4",
    Transition "q3" 'b' "q3",
    Transition "q4" 'a' "q4",
    Transition "q4" 'b' "q4"
    -- Transition "q4" 'c' "q4"  would result in:
    -- Main.hs: Invalid transitions
    -- CallStack (from HasCallStack):
    -- error, called at ./DFA.hs:19:58 in main:DFA
        ]

lang = makeDFA q sigma q0 accept delta

main = mapM_ (print . parse lang) ["aaab", "aaaab", "c", "bbbb"]

-- Just True
-- Just False
-- Nothing
-- Just True
