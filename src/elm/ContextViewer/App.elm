module ContextViewer.App exposing (..)

import ContextViewer.Commands exposing (..)
import ContextViewer.Models exposing (Msg(..), Model, newContext, decodeConfiguration)
import ContextViewer.Views exposing (renderContext)
import Html exposing (..)
import Json.Decode exposing (Value)


init : Value -> ( Model, Cmd Msg )
init payload =
    let
        conf =
            decodeConfiguration payload

        model =
            { configuration = conf, context = Ok newContext }
    in
        ( model, fetchContext conf.jsonUrl )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateContext result ->
            { model | context = result } ! []


view : Model -> Html Msg
view model =
    renderContext model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    programWithFlags { view = view, init = init, update = update, subscriptions = subscriptions }
