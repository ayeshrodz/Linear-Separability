local composer = require("composer")
local relayout = require("relayout")

local scene = composer.newScene()

local _width, _height, _centerX, _centerY = relayout._W, relayout._H, relayout._CX, relayout._CY
local aspectRatio = _height / _width

display.setDefault("background", 0.1,0.4,0.7)
display.setDefault("fillColor", 0)


local FONT = "Calibri"
local HEADER = aspectRatio * 45

local function layout()
    
    -- Display the title of the application.
    heading = display.newText("Linear Separability", _centerX, _height - ((_centerY * 2) - 180), FONT, HEADER)

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
        layout()

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