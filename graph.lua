local composer = require("composer")
--local relayout = require("relayout")
local math = require("math")
local scene = composer.newScene()

--local _width, _height, _centerX, _centerY = relayout._W, relayout._H, relayout._CX, relayout._CY
local _width, _height, _centerX, _centerY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

local screenHypotenuse = math.sqrt(math.pow(_height,2) + math.pow(_width,2))

display.setDefault("background", 0.1, 0.4, 0.6)
display.setDefault("fillColor", 0)
a = require 'affine'

local FONT = "Arial"
local HEADER = screenHypotenuse / 23
local NORMAL = screenHypotenuse / 45
local CSVFILE = "data.csv"
local STROKE_WIDTH = 4

local transform = " "
local inverse = "yes"
local input = 1

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

if (switch.id == 'Translation') then
    transform = "Translation"
elseif (switch.id =='Scaling') then
    transform = "Scaling"
elseif (switch.id =='Rotation') then
    transform = "Rotation"
elseif (switch.id =='Shearing') then
    transform = "Shearing"
end

local function apply_transformation(data, transformation, input)
    if (rawequal(next(data), nil)) then
        print ("fail")
    else
        if (transformation == "Translation") then
            if (inverse == "no") then
                for pos,val in pairs( data ) do
                    T1 = a.trans(0,input)
                    --x2 = x + dx
                    --y2 = y + dy
                    x1,y1 = T1(val.xValue,val.yValue)
                    val.xValue = x1
                    val.yValue = y1
                end 
            else
                for pos,val in pairs( data ) do
                    T1_ = a.trans(0,input)
                    _1T = a.inverse(T1_)
                    --x2 = x + dx
                    --y2 = y + dy
                    x1,y1 = _1T(val.xValue,val.yValue)
                    val.xValue = x1
                    val.yValue = y1
                end 
            end
            
        elseif (transformation == "Scaling") then  
            if (inverse == "no") then
                for pos,val in pairs( data ) do
                    T2 = a.scale(1,1 + (input / 2))
                    --x2 = x * sx
                    --y2 = y * sy
                    x2,y2 = T2(val.xValue,val.yValue)
                    val.xValue = x2
                    val.yValue = y2
                end 
            else
                for pos,val in pairs( data ) do
                    T2_ = a.scale(1,1 + (input / 2))
                    _2T = a.inverse(T2_)
                    --x2 = x * sx
                    --y2 = y * sy
                    x2,y2 = _2T(val.xValue,val.yValue)
                    val.xValue = x2
                    val.yValue = y2
                end 
            end
              
        elseif (transformation == "Rotation") then  
            if (inverse == "no") then
                for pos,val in pairs( data ) do
                    T3 = a.rotate(input / 6)
                    --x2 = x*math.cos(theta) - y*math.sin(theta)
                    --y3 = x*math.sin(theta) + y*math.cos(theta)
                    x3,y3 = T3(val.xValue,val.yValue)
                    val.xValue = x3
                    val.yValue = y3
                end
            else
                for pos,val in pairs( data ) do
                    T3_ = a.rotate(input / 6)
                    _3T = a.inverse(T3_)
                    --x2 = x*math.cos(theta) - y*math.sin(theta)
                    --y3 = x*math.sin(theta) + y*math.cos(theta)
                    x3,y3 = _3T(val.xValue,val.yValue)
                    val.xValue = x3
                    val.yValue = y3
                end
            end
            
        elseif (transformation == "Shearing") then
            if (inverse == "no") then
                for pos,val in pairs( data ) do
                    T4 = a.shear(input / 4, input / 4)
                    --x2 = x + kx*y
                    --y2 = y + ky*x
                    x4,y4 = T4(val.xValue,val.yValue)
                    val.xValue = x4
                    val.yValue = y4
                end
            else       
                for pos,val in pairs( data ) do
                    T4_ = a.shear(input / 4, input / 4)
                    _4T = a.inverse(T4_)
                    --x2 = x + kx*y
                    --y2 = y + ky*x
                    x4,y4 = _4T(val.xValue,val.yValue)
                    val.xValue = x4
                    val.yValue = y4
                end
            end    
        end
    end
end

local function displayLegend()
    --label1 = display.newText("Linear Separability",display.contentCenterX,display.contentCenterY*0.20,"Arial",24)
    pointA = display.newCircle(_width * 0.7, _height * 0.2, 18)
    pointA:setFillColor(1, 0, 0.7)
    label9 = display.newText("Benign", _width * 0.82, _height * 0.2, "Arial", NORMAL)
    
    pointB = display.newCircle(_width * 0.7, _height * 0.25, 18)
    pointB:setFillColor(0.5, 1, 0)
    label10 = display.newText("Malicious", _width * 0.84, _height * 0.25, "Arial", NORMAL)
    
    pointC = display.newCircle(_width * 0.7, _height * 0.3, 18)
    pointC:setFillColor(0.7, 0.5, 0.2)
    label11 = display.newText("ZeroDay", _width * 0.84, _height * 0.3, "Arial", NORMAL)
end

local function scatterGraph(data)
    -- graph layout
    local graphSize = (math.min(_width, _height)) * 0.85
    local graphLocation = {x = (_width - graphSize) / 2, y = (_height - graphSize) / 2}
    graph = display.newGroup()
    graph.x = _centerX * 0.2
    graph.y = _centerY * 0.85

    local yAxis = display.newLine(_centerX * 0.2, _centerY * 1.95, _centerX * 0.2, _centerY * 0.6)
    yAxis.strokeWidth = STROKE_WIDTH
    yAxis:setStrokeColor(0,0,0)

    local xAxis = display.newLine(_centerX * 0.1, _centerY * 1.3, _centerX * 1.9, _centerY * 1.3)
    xAxis.strokeWidth = STROKE_WIDTH
    xAxis:setStrokeColor(0,0,0)

    graphPoints = display.newGroup()
    pointA = display.newGroup(); graphPoints:insert(pointA)
    pointB = display.newGroup(); graphPoints:insert(pointB)


    for i=1, table.maxn(data) do
        if (data[i].class == "B") then
            pointA1 = display.newCircle(pointA, (data[i].xValue + 1) * (screenHypotenuse / 26), (_height - data[i].yValue * (screenHypotenuse / 10)) * 0.65, 10)
            pointA1:setFillColor(1, 0, 0.7)
        else if (data[i].class == "M") then
            pointB1 = display.newCircle(pointB, (data[i].xValue + 1) * (screenHypotenuse / 26), (_height - data[i].yValue * (screenHypotenuse / 10)) * 0.65, 10)
            pointB1:setFillColor(0.5, 1, 0)
        else
            pointC1 = display.newCircle(pointB, (data[i].xValue + 1) * (screenHypotenuse / 26), (_height - data[i].yValue * (screenHypotenuse / 10)) * 0.65, 10)
            pointC1:setFillColor(0.7, 0.5, 0.2)

            local xScale = display.newLine((data[i].xValue + 1) * (screenHypotenuse / 26), _centerY * 1.28, (data[i].xValue + 1) * (screenHypotenuse / 26), _centerY * 1.32)
            xScale.strokeWidth = 3
            xScale:setStrokeColor(0,0,0)
        end
        if ((i > 10) and (i <= 20)) then
            local yScale = display.newLine(_centerX * 0.16, (_centerY - (_centerY / 2.08))  + ((_centerY / 6.4) * (i-10)), _centerX * 0.24, (_centerY - (_centerY / 2.08)) + ((_centerY / 6.4) * (i-10)))
            yScale.strokeWidth = 3
            yScale:setStrokeColor(0,0,0)
            print (_centerX)
            local xScaleNumbers = display.newText(i - 10, _centerX * ((i - 9) / 6.4), _centerY * 1.34, FONT, NORMAL * 0.75)
            local yScaleNumbers = display.newText(15 - i, _centerX * 0.12, (_centerY - (_centerY / 2.08))  + ((_centerY / 6.4) * (i-10)), FONT, NORMAL * 0.75) 
        end
        i = i + 1
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
        apply_transformation(data, transform, input)
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


