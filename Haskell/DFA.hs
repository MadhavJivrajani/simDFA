module DFA (DFA, Transition(..), makeDFA, parse) where
import Control.Monad

data Transition a b = Transition { from :: a, input :: b, to :: a } deriving (Show)

data DFA a b = DFA { 
        states       :: [a],
        alphabet     :: [b],
        initialState :: a,
        finalStates  :: [a],
        transitions  :: [Transition a b]
                   } deriving (Show)

makeDFA :: (Eq a, Eq b) => [a] -> [b] -> a -> [a]-> [Transition a b] -> DFA a b
makeDFA states alphabet initialState finalStates transitions
  | initialState `notElem` states = error "Invalid initial state"
  | not (all (flip elem alphabet . input) transitions)
      || not (all (flip elem states . from) transitions)
      || not (all (flip elem states . to) transitions) = error "Invalid transitions"
  | otherwise = DFA states alphabet initialState finalStates transitions

head' :: [a] -> Maybe a
head' [] = Nothing 
head' (x:xs) = Just x

parse :: (Eq a, Eq b) => DFA a b -> [b] -> Maybe Bool
parse (DFA _ _ initialState finalStates transitions) bs = do
    let foldingFn state i = to <$> head' (filter (\t -> (from t == state) && (input t == i)) transitions)
    result <- foldM foldingFn initialState bs
    return (result `elem` finalStates)
