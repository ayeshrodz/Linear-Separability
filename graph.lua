local composer = require("composer")
--local relayout = require("relayout")
local math = require("math")
local widget = require("widget")
local scene = composer.newScene()

--local _width, _height, _centerX, _centerY = relayout._W, relayout._H, relayout._CX, relayout._CY
local _width, _height, _centerX, _centerY = display.contentWidth, display.contentHeight, display.contentCenterX, display.contentCenterY

local screenHypotenuse = math.sqrt(math.pow(_height,2) + math.pow(_width,2))

--display.setDefault("background", 0.1, 0.7, 0.8)
display.setDefault("fillColor", 0)
a = require 'affine'
affine = require 'affine'

local FONT = "Arial"
local HEADER = screenHypotenuse / 23
local NORMAL = screenHypotenuse / 45
local CSVFILE = "data.csv"
local STROKE_WIDTH = 3

local transform = " "
local inverse = false
local input = 0

--- **** Functions **** ---

local function layout()
    -- Display the title of the application.
    --heading = display.newText("Linear Separability", _centerX, _height - ((_centerY * 2) - 160), FONT, HEADER)
end

local function handleButtonEvent( event )
    if ( event.phase == "ended" or event.phase == "submitted") then
        os.exit()   
    end  
end

local function createButtons()
    Exit = widget.newButton(
        {
            label = "Exit",
            emboss = true,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            width = _width - _centerX * 1.5,
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

    Exit.x = _width * 0.2
    Exit.y = _height * 0.23
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

local function assignTransformation(switch)
    if (switch == 'Translation') then
        return "Translation"
    elseif (switch =='Scaling') then
        return "Scaling"
    elseif (switch =='Rotation') then
        return "Rotation"
    elseif (switch =='Shearing') then
        return "Shearing"
    else
        return "Default"
    end
end

local function assignInverseOperator(switch)
    if (switch == 'Inverse') then
        return true
    else
        return false
    end
end

local function assignUserInputRange (range)
    return range
end

local function transformData (data, input, inverse)
    --Transformation function's algorithm inside affine library
    --x2 = x + dx
    --y2 = y + dy

    if (inverse == false) then
        T1 = affine.trans(0,input)

        _x1, _y1 = T1(data.xValue, data.yValue)
        return {x=_x1, y=_y1}   
    else
        T1_ = affine.trans(0,input)
        _1T = affine.inverse(T1_)

        _x2, _y2 = _1T(data.xValue, data.yValue)
        return {x=_x2, y=_y2}
    end
end

local function scaleData (data, input, inverse)
    --Scale function's algorithm inside affine library
    --x2 = x * sx
    --y2 = y * sy

    if (inverse == false) then
        T2 = affine.scale(1,1+ (input / 2))

        _x1, _y1 = T2(data.xValue, data.yValue)
        return {x=_x1, y=_y1}
    else
        T2_ = affine.scale(1, 1+(input / 2))
        _2T = affine.inverse(T2_)

        _x2, _y2 = _2T(data.xValue, data.yValue)
        return {x=_x2, y=_y2}
    end
end

local function rotateData (data, input, inverse)
    --Rotate function's algorithm inside affine library
    --x2 = x*math.cos(theta) - y*math.sin(theta)
    --y3 = x*math.sin(theta) + y*math.cos(theta)

    if (inverse == false) then
        -- keep the rotation to 60 degrees in order to show inside the graph
        T3 = affine.rotate((input / 360) * 60)
                    
        _x1, _y1 = T3(data.xValue, data.yValue)
        return {x=_x1, y=_y1}
    else
        -- keep the rotation to 60 degrees in order to show inside the graph
        T3_ = affine.rotate((input / 360) * 60)
        _3T = affine.inverse(T3_)

        _x2, _y2 = _3T(data.xValue, data.yValue)
        return {x=_x2, y=_y2}
    end
end

local function shearData (data, input, inverse)
    --Shearing function's algorithm inside affine library
    --x2 = x + kx*y
    --y2 = y + ky*x

    if (inverse == false) then
        T4 = affine.shear(input / 4, input / 4)
                    
        _x1, _y1 = T4(data.xValue, data.yValue)
        return {x=_x1, y=_y1}
    else
        T4_ = affine.shear(input / 4, input / 4)
        _4T = affine.inverse(T4_)

        _x2, _y2 = _4T(data.xValue, data.yValue)
        return {x=_x2, y=_y2}
    end
end

local function apply_transformation(data, transformation, input)
    if (rawequal(next(data), nil)) then
        print ("fail")
        return nil
    else
        if (transformation == "Translation") then
            for pos,val in pairs( data ) do
                trnData = transformData(val, input, inverse)
                val.xValue = trnData.x
                val.yValue = trnData.y
            end
            
        elseif (transformation == "Scaling") then  
            for pos,val in pairs( data ) do
                sclData = scaleData(val, input, inverse)
                val.xValue = sclData.x
                val.yValue = sclData.y
            end 
 
        elseif (transformation == "Rotation") then  
            for pos,val in pairs( data ) do
                rotData = rotateData(val, input, inverse)
                val.xValue = rotData.x
                val.yValue = rotData.y
            end
    
        elseif (transformation == "Shearing") then
            for pos,val in pairs( data ) do
                shrData = shearData(val, input, inverse)
                val.xValue = shrData.x
                val.yValue = shrData.y
            end
        else
            for pos,val in pairs( data ) do
                val.xValue = val.xValue
                val.yValue = val.yValue
            end
        end
        return data
    end
end

local function displayLegend()
    --label1 = display.newText("Linear Separability",display.contentCenterX,display.contentCenterY*0.20,"Arial",24)
    pointA = display.newCircle(_width * 0.7, _height * 0.2, 18)
    pointA:setFillColor(1, 0, 0.7)
    label9 = display.newText("Benign", _width * 0.82, _height * 0.2, "Arial", NORMAL)
    
    pointB = display.newCircle(_width * 0.7, _height * 0.25, 18)
    pointB:setFillColor(0, 0.75, 0.2)
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
            pointB1:setFillColor(0, 0.75, 0.2)
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
    --heading = display.newText("Linear Separability", _centerX, _height - ((_centerY * 2) - 180), FONT, HEADER)
end

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
        print("Graph is in scene")
        createButtons()
        inverse = assignInverseOperator(switch2.id)
        print (tostring(inverse))
        transform = assignTransformation(switch.id)
        print(userInputRange)
        input = assignUserInputRange(userInputRange)
        ReadDataFile()
        data = apply_transformation(data, transform, input)
        displayLegend()
        scatterGraph(data)
        Exit:addEventListener("touch",handleButtonEvent)
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


