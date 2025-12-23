module Dofgen.Core.Layout where

data Finger
  -- B is a thumb
  = LP | LR | LM | LI | LB
  | RI | RM | RR | RP | RB
  deriving (Show, Read, Eq, Enum)

data Hand = LeftHand | RightHand
  deriving (Show, Read, Eq, Enum)

fingerHand finger
  | finger `elem` [LP, LR, LM, LI, LB] = LeftHand
  | finger `elem` [RI, RM, RR, RP, RB] = RightHand

changeHand hand = toEnum . changeHand' . toEnum 
 where
  changeHand' = case hand of
    LeftHand -> \n -> if n >= 5 then n - 5 else n
    RightHand -> \n -> if n < 5 then n + 5 else n
