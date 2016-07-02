module Pages.MyAccount.View exposing (view)

import Exts.RemoteData exposing (RemoteData(..), WebData)
import Html exposing (a, div, span, h2, i, p, text, img, Html)
import Html.Attributes exposing (class, href, src)
import User.Model exposing (..)
import Date exposing (fromTime, fromString)
import Date.Format exposing (..)


-- VIEW


view : WebData User -> Html a
view user =
    let
        ( name, login, avatar, company, created, followers ) =
            case user of
                Success val ->
                    let
                        name' =
                            case val.name of
                                Just name ->
                                    name

                                Nothing ->
                                    val.login

                        company' =
                            case val.company of
                                Just company ->
                                    company

                                Nothing ->
                                    ""

                        memberSince' =
                            Result.withDefault (Date.fromTime 0) <| Date.fromString val.created
                    in
                        ( name', val.login, img [ src val.avatarUrl ] [], company', format "%d/%m/%Y" memberSince', toString val.followers )

                _ ->
                    ( "", "", div [] [], "", "", "0" )
    in
        div [ class "ui card" ]
            [ div [ class "image" ] [ avatar ]
            , div [ class "content" ]
                [ div [ class "header" ] [ text <| "Welcome " ++ name ]
                , div [ class "meta" ] [ text <| "@" ++ login ]
                , div [ class "meta" ] [ text company ]
                ]
            , div [ class "extra content" ]
                [ span []
                    [ i [ class "users icon" ] []
                    , text <| followers ++ " Followers"
                    ]
                , span [ class "right floated" ] [ text <| "Joined: " ++ created ]
                ]
            ]
