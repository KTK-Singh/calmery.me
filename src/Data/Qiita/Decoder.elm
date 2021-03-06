module Data.Qiita.Decoder exposing (decodeQiita)

import Json.Decode as JD
import Model exposing (Article)
import Parser as P exposing ((|.), (|=))


decodeQiita : String -> Result JD.Error (List Article)
decodeQiita response =
    JD.decodeString (JD.list qiitaDecoder) response


qiitaDecoder : JD.Decoder Article
qiitaDecoder =
    JD.map4 Article
        (JD.field "title" JD.string)
        (JD.field "tags"
            (JD.list
                (JD.at [ "name" ] JD.string)
            )
        )
        (JD.field "created_at" JD.string
            |> JD.andThen dateDecoder
        )
        (JD.field "url" JD.string)


type alias Date =
    { year : String
    , month : String
    , date : String
    }


dateDecoder : String -> JD.Decoder String
dateDecoder date =
    JD.succeed <|
        case P.run dateParser date of
            Ok x ->
                x.year ++ "/" ++ x.month ++ "/" ++ x.date

            Err _ ->
                -- 日付のパースに失敗した場合は何も表示しない
                ""


dateParser : P.Parser Date
dateParser =
    P.succeed Date
        |= number
        |. P.symbol "-"
        |= number
        |. P.symbol "-"
        |= number


number : P.Parser String
number =
    P.getChompedString (P.chompWhile Char.isDigit)
