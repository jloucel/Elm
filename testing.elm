import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String


main =
  Html.beginnerProgram
  { model = model
  , view = view
  , update = update
  }

-- model

type alias Model =
  { p1x : Int
  , p1y : Int
  , p2x : Int
  , p2y : Int
  , point1 : Point
  , point2 : Point
  }


model : Model
model =
 Model "" "" "" "" "" ""


-- update

-- distance
distance: Point -> Point -> String
distance p1 p2 =
  sqrt  (((p2.x-p1.x)^2 + (p2.y-p1.y)^2) |> toFloat)
  |> toString

type alias Point =
  { x : Int, y : Int}

type Msg
    = P1x String
    | P1y String
    | P2x String
    | P2y String
    | Dist

update : Msg -> Model -> Model
update msg model =
  case msg of
    P1x p1x ->
      {model | p1x = p1x}

    P1y p1y ->
      { model | p1y = p1y}

    P2x p2x ->
      { model | p2x = p2x}

    P2y p2y ->
      { model | p2y = p2y}

    Dist ->
      { model |
          point1 = { x = Result.withDefault 0 (String.toInt p1x)
                   , y = Result.withDefault 0 (String.toInt p1y) }
        , point2 = { x = Result.withDefault 0 (String.toInt p2x)
                   , y =  p2x) }
      }


-- view

view : Model -> Html Msg
view model =
  div []
    [ text "Point 1: "
    , div [] [ input [ type_ "text", placeholder "X=", onInput P1x ] [] ]
    , input [ type_ "text", placeholder "Y=", onInput P1y ] []
    , div [] [ text "Point 2: " ]
    , div [] [ input [type_ "text", placeholder "X=", onInput P2x ] [] ]
    , input [type_ "text", placeholder "Y=", onInput P2y ] []
    , div [] [ button [ onClick Dist] [ text "Calculate Distance" ]]
    , div [] [ text "x"]
    ]
