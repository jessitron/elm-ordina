module Main exposing (main)

import Html exposing (Html)
import Html.Attributes


-- MODEL


type alias Model =
    {}


init : Model
init =
    {}



-- MESSAGES


type Msg
    = NoOp



-- VIEW


view : Model -> Html Msg
view model =
    Html.main_ []
        [ Html.canvas
            [ Html.Attributes.style
                [ ( "backgroundImage"
                  , "url(" ++ diagram ++ ")"
                  )
                ]
            ]
            []
        , drawLabels [ { text = "CodeStar", x = 100, y = 10 } ]
        ]

diagram =
    "elmbp.png"





type alias Label =
    { text : String
    , x : Int
    , y : Int
    }


drawLabels : List Label -> Html Msg
drawLabels labels =
    let
        formatLabel { text, y, x } =
            Html.label
                [ Html.Attributes.style
                    [ ( "position", "absolute" )
                    , ( "top", (toString y) ++ "px" )
                    , ( "left", (toString x) ++ "px" )
                    ]
                ]
                [ Html.text text ]
    in
        Html.div [] (List.map formatLabel labels)



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model



-- MAIN


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }