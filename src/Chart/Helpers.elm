module Chart.Helpers exposing (..)


flatList : List (List a) -> List a
flatList list =
    list |> List.foldr (\l a -> l ++ a) []



--getLinearDomain : List (List DataStructure) ->
--getLinearDomain data defaultPoint =
--    Maybe.withDefault
--        ( 0
--        , data
--            |> flatList
--            |> List.map (.point >> defaultPoint >> Tuple.second)
--            |> List.maximum
--            |> Maybe.withDefault 0
--        )
--        config.linearDomain
