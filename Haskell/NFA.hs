module NFA (makeNFA, parseWithNFA) where
import Base (StateMachine(..), Transition(..))
import Control.Monad

makeNFA :: (Eq a, Eq b) => StateMachine a b -> StateMachine a b
makeNFA sm@(StateMachine states alphabet initialState finalStates transitions)
  | initialState `notElem` states = error "Invalid initial state"
  | not (all ((`elem` alphabet) . input) transitions)
      || not (all ((`elem` states) . from) transitions)
      || not (all ((`elem` states) . to) transitions) = error "Invalid transitions"
  | otherwise = sm

parseWithNFA :: (Eq a, Eq b) => StateMachine a b -> [b] -> Bool
parseWithNFA (StateMachine _ _ initialState finalStates transitions) bs = 
    any (`elem` finalStates) $ foldl foldingFn [initialState] bs
    where foldingFn states i = let filterFn t = (from t `elem` states) && (input t == i) 
              in to <$> filter filterFn transitions
