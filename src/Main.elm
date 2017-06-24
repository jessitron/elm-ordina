module Main exposing (main)

import Dom
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode
import Mouse
import Task


-- MODEL


type alias Model =
    { newLabel : String
    , labels : List Label
    , lastClick : Maybe Mouse.Position
    }


init : ( Model, Cmd Msg )
init =
    ( { newLabel = ""
      , labels = [ { text = "CodeStar", x = 100, y = 10 } ]
      , lastClick = Nothing
      }
    , Cmd.none
    )



-- MESSAGES


type Msg
    = NoOp
    | NewLabel String
    | SaveLabel Label
    | Click Mouse.Position
    | FocusFieldNotFound String



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
    case model.lastClick of
        Nothing ->
            Html.div [] []

        Just { x, y } ->
            Html.input
                [ Html.Attributes.id "newLabel"
                , Html.Events.onInput NewLabel
                , Html.Attributes.value model.newLabel
                , onEnter
                    (SaveLabel
                        { text = model.newLabel
                        , x = x
                        , y = y
                        }
                    )
                , Html.Attributes.style
                    [ ( "position", "absolute" )
                    , ( "top", (toString y) ++ "px" )
                    , ( "left", (toString x) ++ "px" )
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        NewLabel newLabel ->
            ( { model | newLabel = newLabel }, Cmd.none )

        SaveLabel label ->
            ( { model
                | labels = label :: model.labels
                , newLabel = ""
                , lastClick = Nothing
              }
            , Cmd.none
            )

        Click position ->
            ( { model | lastClick = Just position }
            , requestFocus "newLabel"
            )

        FocusFieldNotFound id ->
            ( model, Cmd.none )


requestFocus : String -> Cmd Msg
requestFocus field_id =
    let
        handle result =
            case result of
                Ok () ->
                    NoOp

                Err (Dom.NotFound id) ->
                    FocusFieldNotFound id
    in
        Task.attempt handle (Dom.focus field_id)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Mouse.clicks Click



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
