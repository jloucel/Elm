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

With these three pieces in place we can now dive into the functions that are used to create our triangles.



<u>The Functions</u>

> A note on Elm syntax '|>' is an insertion operator indicating we want to take   the output of the item on the left and insert into the item on the right. You may have noticed in our view we have the opposite version of this '<|', meaning take the output on the right and insert into the item on the left.



First lets understand the custom types we have seen and will be using. Elm use the syntax 'type alias' to define a type.  

```javascript
type alias Triangle = (Point, Point, Point)

type alias Point =
  { x : Float, y : Float}

```

As we can see here a Triangle is defined as a list of Points. A Point is defined as a record containing an x and y value of type float. As you can see we have many degrees of freedom building up complex types.

As we discuss the functions keep in mind that a Triangle is a list of points that represent each corner of the triangle. You will see how we take advantage of this structure as we generate our output.

At each new order we must perform some recursive tasks to generate a list of triangle that will be displayed in the SVG viewBox. We accomplish this by chaining together several function calls to produce the necessary output. Lets start with genPolys and see how we start the process.

 ```javascript
-- entry point to Sirpenski generation
genPolys : Int -> Int -> Int -> List (Svg Msg)
genPolys order w h =
  genInitialPoints order w h
  |> genManyTriangles order
 ```

Here we can see that genPolys is taking in three integer values and returning a list of Svg Msg, polygons which we have defined as Triangles. At each fractal order we have to build up a list of polygons, so we start by generating the initial triangle and inserting this triangle into genManyTriangles along with the order.  Let's look at genInitialPoins:

```javascript
-- generates the initial points of the fractal
genInitialPoints: Int -> Int -> Int -> (Point, Point, Point)
genInitialPoints order w h =
  let
    p1 = {x = (toFloat w / 2.0), y = (toFloat 10)}
    p2 = {x = (toFloat 10), y =  toFloat (h - 10)}
    p3 = {x = toFloat (w - 10), y =  toFloat (h - 10)}
 in
    (p1,p2,p3)
```

We perform some basic math and create our initial triangle in relation to the Svg container we defined in our view.  We then return these points as a tuple. For simplicity in this program using a tuple works well as we don't have to handle the maybe case of a list being empty. We know that each triangle will have three points and we can easily manage this within a tuple. 

We also see let binding. the 'let' keyword is used to assign values to local variables which we can then use to generate our triangle. Using 'let' can also allow us to do some interesting things, such as pass output to another function, which will help us in building up our list of triangles.

Next we step into genManyTriangles:

```javascript
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
```

genManyTriangles is where the recursive magic happens. First we need to determine if there is an order other than 0 that has been passed in. If 0 we don't have to do anything so we return an empty list. If it is any other value we will generate the requested triangles and build up a list.

The first step in this process is to build up a list of triangles that we can recur with.

To accomplish this we call genSubTriangles:

```javascript
-- takes a tuple of points and returns a list of sub points
genSubTriangles: Triangle -> (Triangle, Triangle,Triangle)
genSubTriangles plist =
  let (p1,p2,p3) = plist
      p12 = getMidPoint p1 p2
      p23 = getMidPoint p2 p3
      p31 = getMidPoint p3 p1
  in
      ((p1, p12, p31),(p12, p2, p23),(p31, p23, p3))
```

This function then will pull out the points of the passed triangle, find the middle point of side of the triangle, and then generate a tuple of three new triangles. At this step we can now recur across each of the sub triangles and the whole process can basically repeat infinitely, though at order 10 we are already generating just under 60,000 triangles!  At each recursive step we also pass a decremented order to genManyTriangles. In this way we are able to build up the list of all triangles needed to fill the Sierpenski triangle at a given order. 

Hopefully this walk-through gives you a solid entry point for beginning functional programming with Elm! Happy Coding!
