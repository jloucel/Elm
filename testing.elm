import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Svg exposing (..)
import Svg.Attributes exposing (..)

width = 400
height = 400

-- midpoint
midpoint: Point -> Point -> Point
midpoint p1 p2 =
    {x = ((p1.x + p2.x) / 2.0), y = ((p1.y + p2.y) / 2.0)}

type alias Point =
  { x : Float, y : Float}

--generate points string
--genpoints: Int -> Int -> Int -> String
--genpoints order w h =
--  "200,10 10,390 390,390"

genpoints: Int -> Int -> Int -> String
genpoints order w h =
    let
        pointToString : { x : number, y: number } -> String
        pointToString =
            toString x ++ "," ++ toString y
    in
        if order == 0
            let
                p1 = {x = (w / 2), y = 10}
                p2 = {x = 10, y = (h - 10)}
                p3 = {x = (w - 10), y = (h - 10)}
            in
                [ p1, p2, p3 ]
                    |> List.map pointToString
                    |> String.join " "
        else
          ""

main =
  Html.beginnerProgram
  { model = initialmodel
  , view = view
  , update = update
  }

-- model

type alias Model =
  { fracOrder : Int }


initialmodel : Model
initialmodel =
 Model 0


-- update

type Msg
    = Update String

update : Msg -> Model -> Model
update msg model =
  case msg of

    Update fracOrder ->
      { model | fracOrder = (Result.withDefault 0 (String.toInt fracOrder))}


-- view

view : Model -> Html Msg
view model =



  div []
      [
      svg [ viewBox "0 0 400 400",  Svg.Attributes.height "400px", Svg.Attributes.width "400px" ]
      [
       polygon [fill "none", stroke "black", points "200,10 10,390 390,390"][]
      ]
      , br [][]
      , br [][]
      , input [ Html.Attributes.type_ "range", Html.Attributes.min "0"
                                               , Html.Attributes.max "10"
                                               , value <| toString model.fracOrder
                                               , onInput Update] []
      , Html.text <| toString model.fracOrder
      , Html.text  <| (genpoints model.fracOrder 400 400)
    ]
