import Base (Transition(..), StateMachine(..))
import DFA (makeDFA, parseWithDFA)
import NFA (makeNFA, parseWithNFA)

q = [ "q0", "q1", "q2", "q3", "q4"]
sigma = "ab"
q0 = "q0"
accept =  ["q4"]
delta = [
    Transition "q0" 'a' "q0",
    Transition "q0" 'b' "q0",
    Transition "q0" 'b' "q1",
    Transition "q1" 'b' "q2",
    Transition "q2" 'a' "q3",
    Transition "q3" 'a' "q4",
    Transition "q4" 'a' "q4",
    Transition "q4" 'b' "q4"
    -- Transition "q4" 'c' "q4"  would result in:
    -- Main.hs: Invalid transitions
    -- CallStack (from HasCallStack):
    -- error, called at ./DFA.hs:19:58 in main:DFA
               ]

-- a double 'b' followed by a double 'a'
testNFA = makeNFA $ StateMachine q sigma q0 accept delta
main = mapM_ (print . parseWithNFA testNFA) ["bbaa", "aaa", "aabbabbaa", "bbbb"]

-- True
-- False
-- True
-- False
