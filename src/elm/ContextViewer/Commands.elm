module ContextViewer.Commands exposing (..)

import ContextViewer.Models exposing (Msg(..), Context)
import Http
import Json.Decode exposing (Decoder, field, succeed, maybe, andThen, string, oneOf, null)
import Json.Decode.Extra exposing ((|:))
import Task


fetchContext : String -> Cmd Msg
fetchContext url =
    Http.send fetchResult (Http.get url contextDecoder)


fetchResult : Result Http.Error Context -> Msg
fetchResult result =
    UpdateContext result


contextDecoder : Decoder Context
contextDecoder =
    succeed Context
        |: (field "context" string)
        |: (field "repository" string)
        |: (field "headBranch" string)
        |: ((maybe (field "commitRef" string)) |> andThen decodeOptionalString)
        |: ((maybe (field "reviewId" string)) |> andThen decodeOptionalString)


decodeOptionalString : Maybe String -> Decoder String
decodeOptionalString option =
    succeed (Maybe.withDefault "" option)
