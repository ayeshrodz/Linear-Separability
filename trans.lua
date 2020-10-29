local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

local _width, _height, _centerX, _centerY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

local screenHypotenuse = math.sqrt(math.pow(_height,2) + math.pow(_width,2))


display.setDefault("background", 0.1, 0.4, 0.6)
display.setDefault("fillColor", 0)


local FONT = "Arial"
local HEADER = screenHypotenuse / 23
local NORMAL = screenHypotenuse / 45

local function layout()

end

local function handleButtonEvent( event )
    if ( event.phase == "ended" or event.phase == "submitted") then
        -- Creating an error message for not entering the X coordinate.
            composer.gotoScene("graph")      
    end  
end

-- Creating a submit button.
local function createButtons()
    btnTransform = widget.newButton(
        {
            label = "Submit",
            emboss = true,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = _width - _centerX,
            height = screenHypotenuse / 20,
            cornerRadius = 2,
            fillColor = { default={0.6,0.6,1}, over={0,0,0,0} },
            strokeColor = { default={0,0,0.1,0.8}, over={0.8,0.8,1,1} },
            strokeWidth = 2,
            labelColor = {default={0,0,0,1}},
            font = FONT,
            fontSize = NORMAL
    
        }
    )

    -- Center the button
    btnTransform.x = _centerX
    btnTransform.y = _centerY * 1.8
end


function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
end

function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        createButtons()
        layout()

        btnTransform:addEventListener("touch",handleButtonEvent)

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
        btnTransform:removeSelf()
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