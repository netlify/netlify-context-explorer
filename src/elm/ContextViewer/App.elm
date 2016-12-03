module ContextViewer.App exposing (..)

import ContextViewer.Commands exposing (..)
import ContextViewer.Models exposing (Msg(..), Model, Visibility(..), newContext, newModel, decodeConfiguration)
import ContextViewer.Views exposing (renderContext)
import Html exposing (..)
import Json.Decode exposing (Value)
import Keyboard exposing (KeyCode)


init : Value -> ( Model, Cmd Msg )
init payload =
    let
        conf =
            decodeConfiguration payload

        model =
            newModel conf
    in
        ( model, fetchContext conf.jsonUrl )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateContext result ->
            { model | context = result } ! []

        KeyUp keyCode ->
            keyUp keyCode model ! []


view : Model -> Html Msg
view model =
    renderContext model


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.ups KeyUp


keyUp : KeyCode -> Model -> Model
keyUp keyCode model =
    case keyCode of
        192 ->
            -- ` ~
            toggleVisibility model

        _ ->
            model


toggleVisibility : Model -> Model
toggleVisibility model =
    let
        newVisibility =
            if model.visibility == Visible then
                Hidden
            else
                Visible
    in
        { model | visibility = newVisibility }


main =
    programWithFlags { view = view, init = init, update = update, subscriptions = subscriptions }
