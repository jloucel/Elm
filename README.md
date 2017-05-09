# Sierpinski's Triangle in Elm

This is a simple project to illustrate the use of the Elm programming language. Check out the demo [here](https://jloucel.github.io/Elm/).

Elm is a purely functional programming language developed for use in web browsers that compiles to HTML, CSS, and JavaScript. It boasts superior performance and no runtime exceptions.

You can (and should) review the examples and even integrate Elm features into your existing site by embedding into JavaScript! Check it out [here](http://elm-lang.org/).  You can also take advantage of an active community on [Reddit](https://www.reddit.com/r/elm/) and [Slack](http://elmlang.herokuapp.com/) to help you get started.

### *Getting Started*

Understanding Elm Architecture.  Every interactive Elm program is based around three main parts:

- Model - maintains state
- View - update state
- Update - display current state

We will take a look at each of these parts with examples from our Sierpinski's Triangle code.



<u>Model</u>

```javas
type alias Model =

  { fracOrder : Int }

model : Model

model =

 Model 0

```

Here we can see we define a type Model and give it an integer element of fracOrder. This will be the container of the user requested fractal order. This is updated each time the user slides the range selector on the web page. At each update new Model is generated containing the new state of fracOrder.



<u>Update</u>

```javascript
type Msg
  = Update String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Update fracOrder ->
      { model | fracOrder = (Result.withDefault 0 (String.toInt fracOrder)) }
```

Update gives us a look at the function type declaration:

​	`update : Msg -> Model -> Model`

Here we define the function template which allows Elm to perform it's strict type checking. In this case we are taking a Msg, which is a String, a Model, and returning a Model. 

The Msg comes to us from the view, as the result of an event. We will see this in a moment. In this program we are capturing the user updating the fractal order range selector. Since we defined the fracOrder as in integer in our Model we have to convert the string value that is captures by the user update to an integer as seen here:

`{ model | fracOrder = (Result.withDefault 0 (String.toInt fracOrder)) }` 

As  you can see this is a fairly wordy conversion, but we accomplish two things, first we trap any errors if we fail to convert the input to an integer we provide a default value of '0', or if successful we return the integer value of the input. This value is now stored in model and returned.



<u>View</u>

The magic of what we see in the browser happens in the view:

```javascript
view : Model -> Html Msg
view model =

  div []
      [
      div [] [Html.text "Sirpenski's Triangle"]
      , svg [ viewBox (getViewDims vHeight vWidth),
             Svg.Attributes.height (getvHeight vHeight),
             Svg.Attributes.width (getvWidth vWidth)]
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
```

There are a few key things to notice here, first is that we provide the structure of the web page here. Utilizing the Elm packaged version of HTML tags we can provide all the structure of an HTML page similar to how we may write standard HTML.

In this example I have created a few helper methods that return constant values to us, so if we wanted to change the size of our viewBox we can edit a couple of values in our page and everywhere these values are needed will also get updated:

```javascript
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
```

These functions facilitate providing string values to our view objects so that they can be properly rendered in the browser. You can see we are taking in Integer values and returning String values in each case.

Now notice our input is a range input. You can see how we set various attributes for these elements in Elm. Since we want to limit the fractal order to 10 we set the max for our range selector at 10. We then take that value and push it into our model and call Update on input. This then runs the update method and updates the model.

Finally the actual work of generating Sierpenski's triangle is accomplished by calling `(genPolys model.fracOrder vWidth vHeight)`. We pass the fracOrder width and height to the genPolys function, which produces a list of objects that are drawn in the SVG viewBox.

