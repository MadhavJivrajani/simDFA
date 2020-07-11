module Base (StateMachine(..), Transition(..), head') where
import Data.List (uncons)

data Transition a b = Transition { from :: a, input :: b, to :: a } deriving (Show)

data StateMachine a b = StateMachine { 
        states       :: [a],
        alphabet     :: [b],
        initialState :: a,
        finalStates  :: [a],
        transitions  :: [Transition a b]
                   } deriving (Show)

head' = fmap fst . uncons

