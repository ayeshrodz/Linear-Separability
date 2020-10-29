local composer = require( "composer" )
local math = require("math")
local widget = require( "widget" )

local scene = composer.newScene()




-- create a background to fill the screen

	


-- Display the topic 
heading = display.newText("Machine Learning", display.contentCenterX, display.contentCenterY*0.01, "Roboto-Black.ttf", 35)

heading = display.newText("Functions", display.contentCenterX, display.contentCenterY*0.01+35, "Roboto-Black.ttf", 35)


text =   display.newText("Choose a mechine \n learning function", display.contentCenterX, 120,"Roboto-Black.ttf" , 24 )  
text: setFillColor(0,0,0)

-- Creating a new group for the four separate methods.
    radioGroup = display.newGroup()



-- Creating a radio button for function1 method.
    local function1 = widget.newSwitch(
        {
            left = 50,
            top = 200,
            style = "radio",
            id = "Function1",
            onPress = onSwitchPress,
           
            
        }
    )
    radioGroup:insert( function1 )
    -- Coordinates to display the text in the simulator.
    F1 = display.newText("function1", 130, 215, "Roboto-Black.ttf", 20)
    F1:setFillColor(0,0,0)

-- Creating a radio button for function2 method.
    local function2 = widget.newSwitch(
        {
            left = 50,
            top = 240,
            style = "radio",
            id = "Function2",
            onPress = onSwitchPress
        }
    )
    radioGroup:insert( function2 )
    -- Coordinates to display the text in the simulator.
    F2 = display.newText("function2", 130, 255, "Roboto-Black.ttf", 20)
    F2:setFillColor(0,0,0)

 -- Creating a radio button for function3 method.
    local function3 = widget.newSwitch(
        {
            left = 50,
            top = 280,
            style = "radio",
            id = "function3",
            onPress = onSwitchPress
        }
    )
    radioGroup:insert( function3 )
    -- Coordinates to display the text in the simulator.
    F3 = display.newText("function3", 130, 295, "Roboto-Black.ttf", 20)
    F3:setFillColor(0,0,0)

 -- Creating a radio button for function4 method.
    local function4  = widget.newSwitch(
        {
            left = 50,
            top = 320,
            style = "radio",
            id = "function4 ",
            onPress = onSwitchPress

        }
    )

    radioGroup:insert( function4  )
    -- Coordinates to display the text in the simulator.
    F4 = display.newText("function4 ", 130, 335, "Roboto-Black.ttf", 20)
    F4:setFillColor(0,0,0)
    

 local buttonProceed = widget.newButton(
            {
                label = "Next",
                onEvent = onProceed,
                shape = "roundedRect",
                width = 100,
                height = 40,
                cornerRadius = 12,
                fontSize = 18,
                fillColor = { default = { 0.58,0.50,1}, over = { 1, 1, 1 } },
                labelColor = { default={ 1, 1, 1 }, over={ 0.58, 0.50, 1} },
                
            }
        )

 buttonProceed.x = display.contentCenterX*1.9 - 50
 buttonProceed.y = display.contentCenterY*2 - 10


       