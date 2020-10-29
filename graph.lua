local composer = require("composer")
local relayout = require("relayout")

local scene = composer.newScene()

local _width, _height, _centerX, _centerY = relayout._W, relayout._H, relayout._CX, relayout._CY
local aspectRatio = _height / _width

display.setDefault("background", 0.1, 0.4, 0.6)
display.setDefault("fillColor", 0)
a = require 'affine'

local FONT = "Arial"
local HEADER = aspectRatio * 45
local NORMAL = aspectRatio * 16
local CSVFILE = "data.csv"
local STROKE_WIDTH = 5
local transformation = "original"

--- **** Functions **** ---

local function layout()
    -- Display the title of the application.
    --heading = display.newText("Linear Separability", _centerX, _height - ((_centerY * 2) - 160), FONT, HEADER)
end

local function ReadDataFile()
    data = {}
    local counter = 1

    local csvPath = system.pathForFile("data.csv", system.ResourceDirectory)
    local file, readError = io.open(csvPath, "r")

    if not file then  
        print ("File opening error: " .. readError)
    else    
       for line in file:lines() do 
            local _xValue, _yValue, _class = string.match(line,"(%d+),(%-?%d*%.?%d+),(%a+)")  
            
            data[counter] = {xValue=_xValue, yValue=_yValue, class=_class} 
            print(data[counter].xValue..","..data[counter].yValue..","..data[counter].class)
            counter = counter + 1;
       end
       io.close(file)
    end
    file = nil
end

local function apply_transformation(data)
    if (rawequal(next(data), nil)) then
        print ("fail")
    else
        if (transformation == "original") then
            T1 = a.trans(10,10)
            T2 = a.scale(-2,-2)
            T3 = T1 * T2

            x2,y2 = T3(10,10)

            print(x2,y2) --> 0 0

            T3 = T2 * T1

            x2,y2 = T3(10,10)
            print(x2,y2) -->


            for i=1, data.xValue do
                print(data.xValue[i])
                i = i + 1
            end

        end
    end
end

local function displayLegend()
    --label1 = display.newText("Linear Separability",display.contentCenterX,display.contentCenterY*0.20,"Arial",24)
    pointA = display.newCircle(_centerX * 1.38, _centerY * 0.42, 16)
    pointA:setFillColor(1, 0, 0.7)
    label9 = display.newText("Benign", _centerX * 1.6, _centerY * 0.42, "Arial", NORMAL)
    
    pointB = display.newCircle(_centerX * 1.38, _centerY * 0.52, 16)
    pointB:setFillColor(0.5, 1, 0)
    label10 = display.newText("Malicious", _centerX * 1.65, _centerY * 0.52, "Arial", NORMAL)
    
    pointC = display.newCircle(_centerX * 1.38, _centerY * 0.62, 16)
    pointC:setFillColor(0.7, 0.5, 0.2)
    label11 = display.newText("ZeroDay", _centerX * 1.64, _centerY * 0.62, "Arial", NORMAL)
end

local function scatterGraph(data)
    -- graph layout
    local graphSize = (math.min(_width, _height)) * 0.85
    local graphLocation = {x = (_width - graphSize) / 2, y = (_height - graphSize) / 2}
    graph = display.newGroup()
    graph.x = _centerX * 0.2
    graph.y = _centerY * 0.85

    local yAxis = display.newLine(_centerX * 0.2, _centerY * 1.7, _centerX * 0.2, _centerY * 0.7)
    yAxis.strokeWidth = STROKE_WIDTH
    yAxis:setStrokeColor(0,0,0)

    local xAxis = display.newLine(_centerX * 0.2, _centerY * 1.7, _centerX * 1.9, _centerY * 1.7)
    xAxis.strokeWidth = STROKE_WIDTH
    xAxis:setStrokeColor(0,0,0)

    graphPoints = display.newGroup()
    pointA = display.newGroup(); graphPoints:insert(pointA)
    pointB = display.newGroup(); graphPoints:insert(pointB)


    for i=1, table.maxn(data) do
        if (data[i].class == "B") then
            if (transformation == "original") then
                pointA1 = display.newCircle(pointA, (data[i].xValue + 1) * 60, (display.contentHeight - data[i].yValue * 150) * 0.6, 10)
                pointA1:setFillColor(1, 0, 0.7)
            else
                pointA1 = display.newCircle(pointA, (data[i].xValue + 1) * 60, (display.contentHeight - data[i].yValue  * -150) * 0.6, 10)
                pointA1:setFillColor(1, 0, 0.7)
            end
        else if (data[i].class == "M") then
            if (transformation == "original") then
                pointB1 = display.newCircle(pointB, (data[i].xValue + 1) * 60, (display.contentHeight - data[i].yValue * 150) * 0.6, 10)
                pointB1:setFillColor(0.5, 1, 0)
            else
                pointB1 = display.newCircle(pointB, (data[i].xValue + 1) * 60, (display.contentHeight - data[i].yValue * -150) * 0.6, 10)
                pointB1:setFillColor(0.5, 1, 0)
            end
        else 
            if (transformation == "original") then
                pointC1 = display.newCircle(pointB, (data[i].xValue + 1) * 60, (display.contentHeight - data[i].yValue * 150) * 0.6, 10)
                pointC1:setFillColor(0.7, 0.5, 0.2)
            else
                pointC1 = display.newCircle(pointB, (data[i].xValue + 1) * 60, (display.contentHeight - data[i].yValue * -150) * 0.6, 10)
                pointC1:setFillColor(0.7, 0.5, 0.2)
            end
        end
    end    
end


local function layout()
    -- Display the title of the application.
    heading = display.newText("Linear Separability", _centerX, _height - ((_centerY * 2) - 180), FONT, HEADER)
end

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
        ReadDataFile()
        apply_transformation(data)
        displayLegend()
        scatterGraph(data)
        --original_data_display(data)

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


