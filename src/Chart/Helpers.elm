module Chart.Helpers exposing (..)

import Chart.Types exposing (..)


flatList : List (List a) -> List a
flatList list =
    list |> List.foldr (\l a -> l ++ a) []


getLinearDomain :
    Data
    -> (Datum -> Float)
    -> Maybe LinearDomain
    -> LinearDomain
getLinearDomain data transformer linearDomain =
    case linearDomain of
        Nothing ->
            let
                pointData =
                    data
                        |> flatList
                        |> List.map transformer
            in
            ( pointData
                |> List.minimum
                |> Maybe.withDefault 0
            , pointData
                |> List.maximum
                |> Maybe.withDefault 0
            )

        Just linearDomain ->
            linearDomain


getBandDomain : Data -> BandDomain
getBandDomain data =
    data
        |> List.indexedMap
            (\idx g ->
                g |> List.head |> Maybe.andThen .group |> Maybe.withDefault (toString idx)
            )
