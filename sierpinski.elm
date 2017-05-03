import Html exposing (Html, beginnerProgram, div, button, text, br, input)
import Html.Attributes exposing (type_, min, max, value)
import Html.Events exposing (onInput)
import Svg exposing (svg, polygon)
import Svg.Attributes exposing (fill, stroke, points, width, height, viewBox)

width = 400
height = 400
plist = "200,10 10,390 390,390"

type alias Point =
  { x : Float, y : Float}

-- return new point  midpoint
getMidPoint: Point -> Point -> Point
getMidPoint p1 p2 =
    {x = ((p1.x + p2.x) / 2.0), y = ((p1.y + p2.y) / 2.0)}

-- return a new polygon with dim p
genNextTriangle p =
  polygon [fill "none", stroke "black", points p][]


{-
  So I'm trying to figure out how I can make a
  functional implimentation for what I need to do.

  genPoints will generate the initial triangle, order 0
  of the set. It returns a string currently, what I would like
  to do is push that output to genNextTriangle and have it return
  the poloygon object.

  The else case for the genPoints would process recursively and return
  a list of polygon objects following the logic commented in the else case.
  The problem is that I need to change the gen points to accept points if I
  were to generate the initial points in another fucntion so that I can use
  this recursively to generate the points for each order and add to a list.
  The list can be returned and update the view, svg accepts a list of shapes
  so it will work well for what I want to do.

  So question is should I store the initial points in model? They are only
  used once.
-}




--generate points string
genPoints: Int -> Int -> Int -> String
genPoints order w h =
    let
        pointToString : Point -> String
        pointToString p =
            toString p.x ++ "," ++ toString p.y
    in
        if order == 0 then
            let
                p1 = {x = (toFloat w / 2.0), y = (toFloat 10)}
                p2 = {x = (toFloat 10), y =  toFloat (h - 10)}
                p3 = {x = toFloat (w - 10), y =  toFloat (h - 10)}
            in
                [ p1, p2, p3 ]
                    |> List.map pointToString
                    |> String.join " "
        else
          ""
{-
                p12 = midpoint p1 p2
                p23 = midpoint p2 p3
                p31 = midpoint p3 p1

                genPoints (order-1) p1 p12 p31
                genPoints (order-1) p12 p2 p23
                genPoints (order-1) p31 p23 p3


-}

main =
  Html.beginnerProgram
  { model = initialmodel
  , view = view
  , update = update
  }

-- model

type alias Model =
  { fracOrder : Int
  , polyPoints : String
 }


initialmodel : Model
initialmodel =
 Model 0 plist


-- update

type Msg
    = Update String

update : Msg -> Model -> Model
update msg model =
  case msg of

    Update fracOrder ->
      { model |
        fracOrder = (Result.withDefault 0 (String.toInt fracOrder))
      , polyPoints = "100,10 10,290 290,290"
      }

-- view

view : Model -> Html Msg
view model =

  div []
      [
      svg [ viewBox "0 0 400 400",  Svg.Attributes.height "400px", Svg.Attributes.width "400px" ]
      [
      -- here will be the function that returns a polygon list
        genNextTriangle model.polyPoints
      ]
      , br [][]
      , br [][]
      , div [] [ Html.text "Fractal Order"]
      , input [ Html.Attributes.type_ "range", Html.Attributes.min "0"
                                               , Html.Attributes.max "10"
                                               , value <| toString model.fracOrder
                                               , onInput Update] []
      , Html.text <| toString model.fracOrder
    ]
