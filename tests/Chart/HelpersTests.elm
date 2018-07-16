module Chart.HelpersTests exposing (..)

import Chart.Helpers
    exposing
        ( getBandDomain
        , getLinearDomain
        )
import Chart.Types exposing (..)
import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


data : Data
data =
    [ [ { cssClass = Nothing
        , point = toPointBand ( "a", 0 )
        , tooltip = Nothing
        , group = Nothing
        }
      , { cssClass = Nothing
        , point = toPointBand ( "b", 12 )
        , tooltip = Nothing
        , group = Nothing
        }
      ]
    , [ { cssClass = Nothing
        , point = toPointBand ( "a", -10 )
        , tooltip = Nothing
        , group = Nothing
        }
      , { cssClass = Nothing
        , point = toPointBand ( "b", 10 )
        , tooltip = Nothing
        , group = Nothing
        }
      ]
    ]


data2 : Data
data2 =
    [ [ { cssClass = Nothing
        , point = toPointBand ( "a", 0 )
        , tooltip = Nothing
        , group = Just "big"
        }
      , { cssClass = Nothing
        , point = toPointBand ( "b", 12 )
        , tooltip = Nothing
        , group = Just "big"
        }
      ]
    , [ { cssClass = Nothing
        , point = toPointBand ( "a", -10 )
        , tooltip = Nothing
        , group = Just "small"
        }
      , { cssClass = Nothing
        , point = toPointBand ( "b", 10 )
        , tooltip = Nothing
        , group = Just "small"
        }
      ]
    ]


suite : Test
suite =
    describe "The helper module"
        [ test "getLinearDomain from data" <|
            \() ->
                getLinearDomain data linearDomainTransformer Nothing |> Expect.equal ( -10, 12 )
        , test "getBandDomain from data with no group" <|
            \() ->
                getBandDomain data |> Expect.equal [ "0", "1" ]
        , test "getBandDomain from data with group" <|
            \() ->
                getBandDomain data2 |> Expect.equal [ "big", "small" ]
        ]
