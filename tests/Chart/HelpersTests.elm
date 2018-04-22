module Chart.HelpersTests exposing (..)

import Chart.Helpers exposing (getLinearDomain)
import Chart.Types exposing (..)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    test "getLinearDomain from bandScale" <|
        \() ->
            let
                data : List (List DataStructure)
                data =
                    [ [ { cssClass = Nothing
                        , point = toPointBand ( "a", 0 )
                        , tooltip = Nothing
                        }
                      , { cssClass = Nothing
                        , point = toPointBand ( "b", 12 )
                        , tooltip = Nothing
                        }
                      ]
                    , [ { cssClass = Nothing
                        , point = toPointBand ( "a", -10 )
                        , tooltip = Nothing
                        }
                      , { cssClass = Nothing
                        , point = toPointBand ( "b", 10 )
                        , tooltip = Nothing
                        }
                      ]
                    ]

                transformer : DataStructure -> Float
                transformer =
                    .point >> fromPointBand >> Maybe.withDefault ( "", 0 ) >> Tuple.second
            in
            getLinearDomain data transformer Nothing |> Expect.equal ( -10, 12 )
