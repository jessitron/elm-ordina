module Main exposing (main)

import Html exposing (Html)


diagram =
    "elmview.png"


main : Html Never
main =
    Html.main_ []
        [ Html.canvas
            [ Html.Attributes.style
                [ ( "backgroundImage"
                  , "url(" + diagram + ")"
                  )
                ]
            ]
            []
        ]
