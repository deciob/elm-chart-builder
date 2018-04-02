module Chart.Helpers exposing (..)


flatList : List (List a) -> List a
flatList list =
    list |> List.foldr (\l a -> l ++ a) []
