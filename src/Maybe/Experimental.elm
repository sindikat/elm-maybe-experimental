module Maybe.Experimental
  ( keepJusts
  , maybe
  , unsafe
  , mapReplaceBy
  ) where

{-| Maybe.Experimental is a testing playground for various Maybe related functions. It contains functions that are experimental, unidiomatic, controversial or downright silly. This is specifically to not clutter Maybe and Maybe.Extra, and also have an isolated place to test crazy ideas.

*Do not* use this module in production code. Try your best to come up with equivalent functionality or solve your problem in a different way, and if you fail, consider contributing to Maybe and Maybe.Extra packages.

*Do not* import functions from this module unqualified if you do use it.

This package has the lowest possible bar for inclusion of Maybe related functions. If you have some code that you want to publish somewhere, but not necessarily contribute to core libraries, feel absolutely free to contribute here. Treat this package as a safe sandbox. The GitHub page for ideas, suggestions, discussions, and pull requests is:

https://github.com/sindikat/elm-maybe-experimental

# Maybe functions
@docs keepJusts, maybe, unsafe, mapReplaceBy
-}

import Debug
import Maybe exposing (..)
import Maybe.Extra exposing (..)


{-| Take a list of `Maybe`s and return the list of all values inside `Just`s.

    keepJusts [Nothing, Just 1, Nothing, Just 2, Just 3] == [1,2,3]
-}
keepJusts : List (Maybe a) -> List a
keepJusts = List.filterMap identity


{-| Take default value, a function, and a `Maybe` value. If the `Maybe` value is `Nothing`, the function returns the default value. Otherwise, it applies the function to the value of `Just` and returns the result.

    maybe [] ((::)0) Nothing == []
    maybe [] ((::)0) (Just [1,2,3]) == [0,1,2,3]
-}
maybe : b -> (a -> b) -> Maybe a -> b
maybe d f = withDefault d << map f


{-| Extract the value, if it's `Just`, or throw an error, if it's `Nothing`.

This is a *dangerous* function and you should do your best to not use it at all in your code. Instead of trying to extract values from `Just`, you should operate within the `Maybe` context by using `Maybe.map`, or extract safely using default value with `Maybe.withDefault`. If you use `unsafe` heavily, consider changing your code style to more idiomatic and type-safe.
-}
unsafe : Maybe a -> a
unsafe v =
  case v of
    Nothing -> Debug.crash "Can't extract value from Nothing!"
    Just x -> x


{-| Replace the value inside `Just` with a new value (possibly of a different type). Otherwise, return `Nothing`.

Advanced functional programmers will recognize this as the implementation of `<$` for `Maybe`s from the `Functor` typeclass, where `<$ == map << always`.
-}
mapReplaceBy : a -> Maybe b -> Maybe a
mapReplaceBy = map << always
