module ContextViewer.App exposing (..)

import ContextViewer.Commands exposing (..)
import ContextViewer.Models exposing (Msg(..), Model, newContext, decodeConfiguration)
import ContextViewer.Views exposing (renderContext)
import Html.App exposing (programWithFlags)
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
        FetchContextDone newCtx ->
            ( { configuration = model.configuration, context = Ok newCtx }, Cmd.none )

        FetchContextFail error ->
            ( { configuration = model.configuration, context = Err error }, Cmd.none )


view : Model -> Html Msg
view model =
    renderContext model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Json.Decode.Value
main =
    programWithFlags { view = view, init = init, update = update, subscriptions = subscriptions }
