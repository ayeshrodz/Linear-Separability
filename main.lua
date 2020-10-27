-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local composer = require( "composer" )
local relayout = require("relayout")

local scene = composer.newScene()

-- Calling the first scene.
local transition =
{
    effect = "slideLeft",
    time = 800
}

composer.gotoScene("graph", transition)