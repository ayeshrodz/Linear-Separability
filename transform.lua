local composer = require("composer")
--local relayout = require("relayout")
local widget = require("widget")
local math = require("math")

local scene = composer.newScene()

--local _width, _height, _centerX, _centerY = relayout._W, relayout._H, relayout._CX, relayout._CY
local _width, _height, _centerX, _centerY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

local screenHypotenuse = math.sqrt(math.pow(_height,2) + math.pow(_width,2))

--display.setDefault("background", 0.1, 0.7, 0.8)
display.setDefault("fillColor", 0)

local transition =
{
    effect = "slideLeft",
    time = 2000
}

local FONT = "Arial"
local HEADER = screenHypotenuse / 23
local NORMAL = screenHypotenuse / 35

local function layout()
    -- Display the title of the application.
    heading2 = display.newText("Linear Separability", _centerX, (_height / 8), FONT, HEADER)
    menu1 = display.newText("● Please select a transform function", _centerX, (_height / 3.8), FONT, NORMAL)
    imgSeperator = display.newImageRect( "seperator.png", _width, _centerX * 0.9)
    imgSeperator.x = _centerX
    imgSeperator.y = _centerY * 0.4
    menu2 = display.newText("● Please enter options", _centerX / 1.55, _centerY + (_height / 5), FONT, NORMAL)

    range = display.newText("Range :", _width * 0.2 , _height * 0.78, FONT, NORMAL * 0.9)
    rangeField = native.newTextField(_width * 0.4, _height * 0.78, _centerX/3, _centerX/5.5)
    rangeField.font = native.newFont(FONT, NORMAL * 0.9)
    rangeField.placeholder = "Integer / Float"
    rangeField.text = "0"

    inverseText = display.newText("Inverse :", _width * 0.66 , _height * 0.782, FONT, NORMAL * 0.9)
end

local function includeOptions()
end

local function handleButtonEvent( event )
    if ( event.phase == "ended" or event.phase == "submitted") then
        -- Creating an error message for not entering the X coordinate.
        if (switch =="" or switch == null) then
            local xAlert = native.showAlert("Alert", "Please enter the transform function",{"OK"})
        elseif (userInputRange == "" or userInputRange == null) then
            local yAlert = native.showAlert("Alert", "Please enter Range",{"OK"})
        elseif (tonumber(userInputRange) > 1) then 
            local yRangeAlert = native.showAlert("Alert", "Please enter a value between 1 and -1",{"OK"})
        elseif (tonumber(userInputRange) < -1) then 
            local yRangeAlert = native.showAlert("Alert", "Please enter a value between 1 and -1",{"OK"})
        
        else
            --os.exit()
            composer.gotoScene("graph") 
        end     
    end  
end

local function onSwitchPress( event )
    switch = event.target
end

local function onSwitch2Press( event )
    switch2 = event.target
    print( "Switch with ID '"..switch2.id.."' is on: "..tostring(switch2.isOn) )
end

-- Getting user input for the range.
local function rangeValue(event)
    if (event.phase == "ended" or event.phase == "editing") then
        userInputRange = event.target.text
        
        print("Input Range: " ..userInputRange)  
    end
end

-- Creating a submit button.
local function createButtons()
Submit = widget.newButton(
    {
        label = "Submit",
        emboss = true,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = _width - _centerX,
        height = screenHypotenuse / 20,
        cornerRadius = 20,
        fillColor = { default={0.6,0.6,1}, over={0,0,0,0} },
        strokeColor = { default={0,0,0.1,0.8}, over={0.8,0.8,1,1} },
        strokeWidth = 2,
        labelColor = {default={0,0,0,1}},
        font = FONT,
        fontSize = NORMAL

    }
)
     
-- Center the button
Submit.x = _centerX
Submit.y = _centerY * 1.8
end


function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    local params = event.params
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        
        layout()
        createButtons()
        switch=""
        switch2=""
        userInputRange=""

        rangeField:addEventListener("userInput", rangeValue)
        rangeField.inputType = "decimal"
        Submit:addEventListener("touch",handleButtonEvent)
        
        
        print(userInputRange)
        -- Creating a new group for the four distance calculation  methods.
        radioGroup = display.newGroup()

        -- Creating a radio button for translation method.
        local Translation = widget.newSwitch(
            {
                left = _centerX * 0.55,
                top = _centerY / 1.6,
                style = "radio",
                width = screenHypotenuse / 25,
                height = screenHypotenuse / 25,
                id = "Translation",
                onPress = onSwitchPress,
            }
        )
        radioGroup:insert( Translation )
        Tr = display.newText("Translation", _centerX * 1.08, _centerY / 1.49, FONT, NORMAL)

        -- Creating a radio button for scaling method.
        local Scaling = widget.newSwitch(
            {
                left = _centerX * 0.55,
                top = _centerY / 1.3,
                style = "radio",
                width = screenHypotenuse / 25,
                height = screenHypotenuse / 25,
                id = "Scaling",
                onPress = onSwitchPress
            }
        )
        radioGroup:insert( Scaling )
        Sc = display.newText("Scaling", _centerX * 1, _centerY / 1.22, FONT, NORMAL)

        -- Creating a radio button for rotation method.
        local Rotation = widget.newSwitch(
            {
                left = _centerX * 0.55,
                top = _centerY / 1.09,
                style = "radio",
                width = screenHypotenuse / 25,
                height = screenHypotenuse / 25,
                id = "Rotation",
                onPress = onSwitchPress
            }
        )
        radioGroup:insert( Rotation )
        Ro = display.newText("Rotation", _centerX * 1.03, _centerY / 1.03, FONT, NORMAL)

        -- Creating a radio button for shearing method.
        local Shearing = widget.newSwitch(
            {
                left = _centerX * 0.55,
                top = _centerY / 0.93,
                style = "radio",
                width = screenHypotenuse / 25,
                height = screenHypotenuse / 25,
                id = "Shearing",
                onPress = onSwitchPress
            }
        )
        radioGroup:insert( Shearing )
        Sh = display.newText("Shearing", _centerX * 1.04, _centerY / 0.89, FONT, NORMAL)
        
        -- Creating a radio button for shearing method.
        local Default = widget.newSwitch(
            {
                left = _centerX * 0.55,
                top = _centerY / 0.82,
                style = "radio",
                width = screenHypotenuse / 25,
                height = screenHypotenuse / 25,
                id = "Default",
                onPress = onSwitchPress
            }
        )
        radioGroup:insert( Default )
        Df = display.newText("Default", _centerX * 1, _centerY / 0.79, FONT, NORMAL)
        radioGroup.fillColor = {1,1,1}

        -- Adding event listener for the radio buttons.
        radioGroup:addEventListener("touch",onSwitchPress)  

        checkboxButton = widget.newSwitch(
        {
            left = _centerX * 1.6,
            top = _height * 0.76,
            width = screenHypotenuse / 25,
            height = screenHypotenuse / 25,
            style = "checkbox",
            id = "Inverse",
            onPress = onSwitch2Press
        })


    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        
    end
end

function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        Submit:removeSelf()
        imgSeperator:removeSelf()
        menu1:removeSelf()
        menu2:removeSelf()
        Tr:removeSelf()
        Sc:removeSelf()
        Ro:removeSelf()
        Sh:removeSelf()
        Df:removeSelf()
        radioGroup:removeSelf()
        range:removeSelf()
        rangeField:removeSelf()
        inverseText:removeSelf()
        if checkboxButton ~= nil then 
            checkboxButton:removeSelf() 
            checkboxButton = nil
        end
        --checkboxButton:removeSelf()
    end
end

function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene