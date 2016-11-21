module ContextViewer.Commands exposing (..)

import ContextViewer.Models exposing (Msg(..), Context)
import Http
import Json.Decode exposing ((:=), Decoder, succeed, maybe, andThen, string, oneOf, null)
import Json.Decode.Extra exposing ((|:))
import Task


fetchContext : String -> Cmd Msg
fetchContext url =
    Http.get contextDecoder url
        |> Task.perform FetchContextFail FetchContextDone


contextDecoder : Decoder Context
contextDecoder =
    succeed Context
        |: ("context" := string)
        |: ("repository" := string)
        |: ("headBranch" := string)
        |: ((maybe ("commitRef" := string)) `andThen` decodeOptionalString)
        |: ((maybe ("reviewId" := string)) `andThen` decodeOptionalString)


decodeOptionalString : Maybe (String) -> Decoder (String)
decodeOptionalString option =
    succeed (Maybe.withDefault "" option)
