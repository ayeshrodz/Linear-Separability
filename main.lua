-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )

local scene = composer.newScene()

-- Calling the first scene.
local transition =
{
    effect = "slideLeft",
    time = 2000
}

composer.gotoScene("home", transition)