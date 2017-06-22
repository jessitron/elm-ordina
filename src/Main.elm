module Main exposing (main)

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode


-- MODEL


type alias Model =
    { newLabel : String
    , labels : List Label
    }


init : Model
init =
    { newLabel = ""
    , labels = [ { text = "CodeStar", x = 100, y = 10 } ]
    }



-- MESSAGES


type Msg
    = NoOp
    | NewLabel String
    | SaveLabel Label



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
        , drawLabels model.labels
        , newLabelInput model
        ]


diagram =
    "elmprogram.png"


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


newLabelInput : Model -> Html Msg
newLabelInput model =
    Html.input
        [ Html.Attributes.id "newLabel"
        , Html.Events.onInput NewLabel
        , Html.Attributes.value model.newLabel
        , onEnter
            (SaveLabel
                { text = model.newLabel
                , x = 200
                , y = 200
                }
            )
        , Html.Attributes.style
            [ ( "position", "absolute" )
            , ( "top", (toString 300) ++ "px" )
            , ( "left", (toString 300) ++ "px" )
            ]
        ]
        []


onEnter : Msg -> Html.Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.Decode.succeed msg
            else
                Json.Decode.fail "not ENTER"
    in
        Html.Events.on "keydown" (Json.Decode.andThen isEnter Html.Events.keyCode)



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        NewLabel newLabel ->
            { model | newLabel = newLabel }

        SaveLabel label ->
            { model | labels = label :: model.labels }



-- MAIN


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }
