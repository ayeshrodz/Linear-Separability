local composer = require( "composer" )
local scene = composer.newScene()

local function DataReadFromCSV()
    data = {}
    local DPath = system.pathForFile( "data.csv" , system.ResourceDirectory)
    local file,errorString = io.open(  DPath , "r")
    print ("\n----Reading data in data.csv----")

    local i = 1
    if not file then
        print("File error!!!")
    else 
       local i = 1
       for line in file:lines( ) do 
            local _xValue,_yValue,_class = string.match(line,"(%d+),(%-?%d*%.?%d+),(%a+)")  
            data[i] = {xValue=_xValue, yValue=_yValue, class=_class} 
            print(data[i].xValue..","..data[i].yValue..","..data[i].class)
            i = i + 1;
       end
       io.close(file)
    end
    file = nil
end

local function labelDisplay()
    label1 = display.newText("Linear Separability",display.contentCenterX,display.contentCenterY*0.20,"Arial",24)
    label9 = display.newText("Benign = Dark Blue",display.contentCenterX*1.50,display.contentCenterY*0.72,"Arial",13)
    label10 = display.newText("Malicious = Red",display.contentCenterX*1.50,display.contentCenterY*0.79,"Arial",13)
    label11 = display.newText("ZeroDAy = Green",display.contentCenterX*1.50,display.contentCenterY*0.86  ,"Arial",13)
end

local function scatterGraph(data)
    -- graph layout
    local graphSize = (math.min(display.contentHeight, display.contentWidth))*0.8
    local graphLocation = {x = (display.contentWidth - graphSize)/2, y = (display.contentHeight - graphSize)/2}
    graph = display.newGroup()
    graph.x = display.contentCenterX*0.1
    graph.y = display.contentCenterY*0.7
    local axisThickness = 2
    local graphThickness = 1

    -- y axis
    yAxis = display.newRect(0, 0, axisThickness, graphSize)
    yAxis.anchorX = 0
    yAxis.anchorY = 0
    yAxis.type = "wall"
    graph:insert(yAxis)

    --x axis
    xAxis = display.newRect(0, graphSize-axisThickness, graphSize, graphThickness)
    xAxis.anchorX = 0
    xAxis.anchorY = 0
    xAxis.type = "wall"
    graph:insert(xAxis)

    graphPoints = display.newGroup()
    pointA = display.newGroup(); graphPoints:insert(pointA)
    pointB = display.newGroup(); graphPoints:insert(pointB)
    for i=1, table.maxn(data) do
        if (data[i].class == "B") then
            pointA1 = display.newCircle(pointA,(data[i].xValue)*25,(display.contentHeight - data[i].yValue*20)*0.90,4)
            pointA1:setFillColor(0,0,1)
        else if (data[i].class == "M") then
            pointB1 = display.newCircle(pointB,(data[i].xValue)*25,(display.contentHeight - data[i].yValue*20)*0.90,4)
            pointB1:setFillColor(255, 0, 0)
            else 
                pointC1 = display.newCircle(pointB,(data[i].xValue)*25,(display.contentHeight - data[i].yValue*20)*0.90,4)
                pointC1:setFillColor(0, 255, 0)
        end
        end 
    end
end



function scene:createScene( event )
    local sceneGroup = self.view
end

function scene:enterScene( event )
    DataReadFromCSV()
    labelDisplay()
    scatterGraph(data)
end

function scene:exitScene( event )

end

function scene:destroyScene( event )

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene