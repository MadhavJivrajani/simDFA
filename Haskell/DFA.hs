module DFA (makeDFA, parseWithDFA) where
import Control.Monad
import Base (StateMachine(..), Transition(..), head')
import NFA (makeNFA)
import Data.List (nubBy)

makeDFA :: (Eq a, Eq b) => StateMachine a b -> StateMachine a b
makeDFA sm@(StateMachine states alphabet initialState finalStates transitions)
  | not . null $ nubBy (\x y -> from x == from y && input x == input y) transitions = error "Invalid transitions"
  | otherwise = makeNFA sm

parseWithDFA :: (Eq a, Eq b) => StateMachine a b -> [b] -> Maybe Bool
parseWithDFA (StateMachine _ _ initialState finalStates transitions) bs = do
    let foldingFn state i = let filterFn t = (from t == state) && (input t == i)
            in to <$> head' (filter filterFn transitions)
    result <- foldM foldingFn initialState bs
    return (result `elem` finalStates)
