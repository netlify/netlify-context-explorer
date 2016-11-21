module ContextViewer.Views exposing (renderContext)

import ContextViewer.Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Regex exposing (HowMany(..), regex, replace)
import String


renderContext : Model -> Html Msg
renderContext model =
    case model.context of
        Err error ->
            case error of
                Http.BadResponse 404 msg ->
                    div [] []

                otherError ->
                    text (parseError otherError) |> renderWrapper

        Ok ctx ->
            let
                render =
                    (List.member ctx.context model.configuration.contextsEnabled) && ctx.repository /= ""
            in
                if render then
                    renderGitInfo ctx |> renderWrapper
                else
                    div [] []


renderWrapper : Html Msg -> Html Msg
renderWrapper msg =
    div [ class "netlify-context-wrapper" ]
        [ msg ]


renderGitInfo : Context -> Html Msg
renderGitInfo ctx =
    let
        gitHost =
            parseGitHost ctx

        infoLink =
            gitInfo ctx gitHost

        dom =
            [ text (humanContextName ctx.context), infoLink ] ++ (reviewInfo ctx gitHost)
    in
        span [ class "bucket" ] dom


gitInfo : Context -> String -> Html Msg
gitInfo ctx gitHost =
    span []
        [ text " built with "
        , referenceLink ctx gitHost
        ]


referenceLink : Context -> String -> Html Msg
referenceLink ctx gitHost =
    if ctx.commitRef == "" then
        a [ href (gitHost ++ "/tree/" ++ ctx.headBranch) ] [ text ctx.headBranch ]
    else
        a [ href (gitHost ++ "/commit/" ++ ctx.commitRef) ] [ text (ctx.headBranch ++ "@" ++ (String.slice 0 8 ctx.commitRef)) ]


reviewInfo : Context -> String -> List (Html Msg)
reviewInfo ctx gitHost =
    if ctx.reviewId /= "" then
        [ text " - This is still a work in progress, ", codeReviewLink ctx gitHost ]
    else
        []


codeReviewLink : Context -> String -> Html Msg
codeReviewLink ctx gitHost =
    a [ href (gitHost ++ (codeReviewPath gitHost) ++ ctx.reviewId) ] [ text "review the code" ]


parseGitHost : Context -> String
parseGitHost ctx =
    let
        url =
            removeGitSuffix ctx.repository
    in
        if String.startsWith "git@" url then
            replaceSshProtocol url
        else
            url


removeGitSuffix =
    replace All (regex "\\.git$") (\{ match } -> String.dropRight 4 match)


replaceSshProtocol : String -> String
replaceSshProtocol url =
    replace All (regex "^git@") (\{ match } -> String.dropLeft 4 match) url
        |> replace All (regex ":") (\_ -> "/")
        |> String.append "https://"


codeReviewPath : String -> String
codeReviewPath gitHost =
    if String.contains "gitlab" gitHost then
        "/merge_requests/"
    else if String.contains "bitbucket" gitHost then
        "/pull-requests/"
    else
        "/pull/"


humanContextName : String -> String
humanContextName name =
    if name == "production" then
        "Netlify Production -"
    else if name == "deploy-preview" then
        "Netlify Deploy Preview -"
    else
        "Netlify Branch deploy -"
