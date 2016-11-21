module ContextViewer.Models exposing (..)

import Http
import Json.Decode exposing (Decoder, Value, decodeValue, succeed, maybe, andThen, string, oneOf, null, list, bool, (:=))
import Json.Decode.Extra exposing ((|:))


defaultJsonUrl =
    "/netlify-context.json"


defaultContextsEnabled =
    [ "deploy-preview" ]


type alias Context =
    { context : String
    , repository : String
    , headBranch : String
    , commitRef : String
    , reviewId : String
    }


type alias Configuration =
    { jsonUrl : String
    , contextsEnabled : List String
    }


type alias Model =
    { configuration : Configuration
    , context : Result Http.Error Context
    }


type Msg
    = FetchContextDone Context
    | FetchContextFail Http.Error


newConfiguration : Configuration
newConfiguration =
    { jsonUrl = defaultJsonUrl
    , contextsEnabled = defaultContextsEnabled
    }


newContext : Context
newContext =
    Context "" "" "" "" ""


parseError : Http.Error -> String
parseError error =
    case error of
        Http.Timeout ->
            "timeout reading the context file"

        Http.NetworkError ->
            "network error reading the context file"

        Http.UnexpectedPayload str ->
            str

        Http.BadResponse int str ->
            str


decodeConfiguration : Value -> Configuration
decodeConfiguration payload =
    case decodeValue configurationDecoder payload of
        Ok configuration ->
            configuration

        Err _ ->
            newConfiguration


configurationDecoder : Decoder Configuration
configurationDecoder =
    succeed Configuration
        |: ((maybe ("jsonUrl" := oneOf [ string, null defaultJsonUrl ])) `andThen` decodeOptionalUrl)
        |: ((maybe ("contextsEnabled" := oneOf [ list string, null defaultContextsEnabled ])) `andThen` decodeOptionalList)


decodeOptionalUrl : Maybe (String) -> Decoder (String)
decodeOptionalUrl option =
    succeed (Maybe.withDefault defaultJsonUrl option)


decodeOptionalList : Maybe (List String) -> Decoder (List String)
decodeOptionalList option =
    succeed (Maybe.withDefault defaultContextsEnabled option)
