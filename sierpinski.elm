{-
  An example of how to utilize Elm to generate Sirpenski's triange.
  At order 0 there is are no triangles, at order 10 there would be
  59,049 triangles. This implimentation is limited to 10 iterations
  due to performnace limitations.
-}

import Html exposing (Html, beginnerProgram, div, button, text, br, input, em)
import Html.Attributes exposing (type_, min, max, value, style)
import Html.Events exposing (onInput)
import Svg exposing (Svg, svg, polygon)
import Svg.Attributes exposing (fill, stroke, points, width, height, viewBox)

vWidth = 400
vHeight = 400

type alias Triangle = (Point, Point, Point)

type alias Point =
  { x : Float, y : Float}

{-
   The following three functions are provided
   to allow ViewBox to be dynamically sized.
   they return formatted strings for
   vWidth and vHeight.
-}

-- get viewBox dimentions string
getViewDims : Int -> Int -> String
getViewDims w h =
  "0 0 " ++ toString w ++ " " ++ toString h

-- get vWidth string
getvWidth : Int -> String
getvWidth w =
  toString w ++ "px"

-- get vHeight String
getvHeight : Int -> String
getvHeight h =
  toString h ++ "px"

-- return new point  midpoint
getMidPoint: Point -> Point -> Point
getMidPoint p1 p2 =
  {x = ((p1.x + p2.x) / 2.0), y = ((p1.y + p2.y) / 2.0)}

-- return a new polygon with dim p
genTriangle : Triangle -> Svg Msg
genTriangle triangle =
  let
    (p1, p2, p3) = triangle
    pointString = String.join " " [pointToString p1, pointToString p2, pointToString p3]
  in
    polygon [fill "none", stroke "black", points pointString][]

-- generates the initial points of the fractal
genInitialPoints: Int -> Int -> Int -> (Point, Point, Point)
genInitialPoints order w h =
  let
    p1 = {x = (toFloat w / 2.0), y = (toFloat 10)}
    p2 = {x = (toFloat 10), y =  toFloat (h - 10)}
    p3 = {x = toFloat (w - 10), y =  toFloat (h - 10)}
 in
    (p1,p2,p3)

-- takes a tuple of points and returns a list of sub points
genSubTriangles: Triangle -> (Triangle, Triangle,Triangle)
genSubTriangles plist =
  let (p1,p2,p3) = plist
      p12 = getMidPoint p1 p2
      p23 = getMidPoint p2 p3
      p31 = getMidPoint p3 p1
  in
      ((p1, p12, p31),(p12, p2, p23),(p31, p23, p3))

-- takes a tuple of tuples and returns a list of polygons, recursive
genManyTriangles : Int -> Triangle -> List (Svg Msg)
genManyTriangles order triangle =
  case order of
    0 -> []
    _ -> let (t1, t2, t3) = genSubTriangles triangle
         in genTriangle triangle :: (List.concat [genManyTriangles (order - 1) t1,
             genManyTriangles (order - 1) t2,
             genManyTriangles (order - 1) t3
            ])

-- convert a point to string
pointToString : Point -> String
pointToString p =
  toString p.x ++ "," ++ toString p.y

-- entry point to Sirpenski generation
genPolys : Int -> Int -> Int -> List (Svg Msg)
genPolys order w h =
  genInitialPoints order w h
  |> genManyTriangles order

main =
  Html.beginnerProgram
  { model = model
  , view = view
  , update = update
  }

-- model

type alias Model =
  { fracOrder : Int }

model : Model
model =
 Model 0

-- update

type Msg
  = Update String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Update fracOrder ->
      { model | fracOrder = (Result.withDefault 0 (String.toInt fracOrder)) }

-- view

view : Model -> Html Msg
view model =

  div []
      [
      div [] [Html.text "Sirpenski's Triangle"]
      , svg [ viewBox (getViewDims vHeight vWidth),  Svg.Attributes.height (getvHeight vHeight), Svg.Attributes.width (getvWidth vWidth)]
      (genPolys model.fracOrder vWidth vHeight)
      , br [][]
      , br [][]
      , div [] [ Html.text "Fractal Order"]
      , input [ Html.Attributes.type_ "range", Html.Attributes.min "0"
                                             , Html.Attributes.max "10"
                                             , value <| toString model.fracOrder
                                             , onInput Update] []
      , Html.text <| toString model.fracOrder
      ]
