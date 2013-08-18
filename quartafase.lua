-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local physics = require("physics")
local gameUI = require("gameUI")
local widget = require("widget")

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local ball
local taxaDesaceleracao = 1


function scene:createScene( event )
    local screenGroup = self.view
    local _W = display.contentWidth
    local _H = display.contentHeight

    local strokeNumber = 0


    display.setStatusBar ( display.HiddenStatusBar)


    physics.start()
    local bg = display.newImage ("grassbg.png", true)
    --physics.addBody(bg)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY
    screenGroup:insert(bg)
    local hole = display.newCircle (_W/2, 80, 17)
    hole:setFillColor(0,0,0)
    screenGroup:insert(hole)
    local strokeCounter = display.newText ("0",15, 15, native.systemFont, 50)
    screenGroup:insert(strokeCounter)
    ball = display.newCircle (_W/2, 400,15)

ball.alpha=0.01
local ballImage = display.newImage ("pequena.png",_W/2, 400)
    physics.addBody(ball, {density = 1, friction = 0.1, bounce =0.2})
    screenGroup:insert(ball)
    local obCaixa = display.newGroup()
        local parteE1 = display.newRect(obCaixa, 00, 195, 130, 5)
        local parteE2 = display.newRect(obCaixa, 00, 200, 90, 20)
        local parteE3 = display.newRect(obCaixa, 00, 220, 130, 5)
        local parteD1 = display.newRect(obCaixa, 190, 195, 130, 5)
        local parteD2 = display.newRect(obCaixa, 230, 200, 90, 20)
        local parteD3 = display.newRect(obCaixa, 190, 220, 130, 5)
        parteMovel = display.newRect(obCaixa, 90, 200, 140, 20)
        parteMovel:setFillColor(255, 100, 0, 150)
            botao = display.newRect(obCaixa, 200, 222, 40, 10)
            botao:setFillColor(255, 0, 0, 255)
            botao.isOpen = false
            screenGroup:insert(botao)
        screenGroup:insert(parteE1)
        screenGroup:insert(parteE2)
        screenGroup:insert(parteE3)
        screenGroup:insert(parteD1)
        screenGroup:insert(parteD2)
        screenGroup:insert(parteD3)
        screenGroup:insert(parteMovel)
        physics.addBody(parteE1, "static")
        physics.addBody(parteE2, "static")
        physics.addBody(parteE3, "static")
        physics.addBody(parteD1, "static")
        physics.addBody(parteD2, "static")
        physics.addBody(parteD3, "static")
        physics.addBody(parteMovel, "static")
        physics.addBody(botao, {isSensor = true})
        physics.addBody(obCaixa, "static")
    physics.setGravity(0,0)
    system.activate( "multitouch" )
    local function dragBody( event )
        return gameUI.gameUI.dragBody( event, { maxForce=600, frequency=5, dampingRatio=0.2 } )


    -- Substitute one of these lines for the line above to see what happens!
    --gameUI.dragBody( event, { maxForce=400, frequency=5, dampingRatio=0.2 } ) -- slow, elastic dragging
    --gameUI.dragBody( event, { maxForce=20000, frequency=1000, dampingRatio=1.0, center=true } ) -- very tight dragging, snaps to object center
    end
    local function abrePorta()
        parteMovel:setReferencePoint(display.CenterLeftReferencePoint)
        while (not isOpen) do
            transition.to(parteMovel, {time=1500, x=190})
            isOpen = true
        end
            

    end
    local function  increaseCounter( event )
    phase = event.phase
    if phase == "began"then
        strokeNumber = strokeNumber + 1
        strokeCounter.text = (strokeNumber)
    end
    end
    local function ballFriction()
        ball.angularVelocity=0
        ballImage.x=ball.x
    ballImage.y=ball.y

        local vx, vy=ball:getLinearVelocity()
        if (vx ~=0 or vy ~=0)then

            local newvx=vx*(1 - (10000)/((vx*vx)+(vy*vy)))
            local newvy=vy*(1 - (10000)/((vx*vx)+(vy*vy)))
            if ((newvy/vy)<0 or (newvx/vx)<0)then
                newvy=0
                newvx=0
            end
            if (ball.x > display.contentWidth - 10 or ball.x < 10) then
                    if (ball.x<30 and vx<0) then
                    newvx = newvx * -0.8
                    elseif ball.x>30 and vx>0 then
                    newvx = newvx * -0.8
                    end
            end
            if (ball.y > display.contentHeight - 10 or ball.y < 10) then
                    if (ball.y<30 and vy<0) then
                    newvy = newvy * -0.8
                    elseif ball.y>30 and vy>0 then
                    newvy = newvy * -0.8
                    end
                
            end




            ball:setLinearVelocity(newvx,newvy)
        end

        if (math.abs(hole.x-ball.x)<12 and math.abs(hole.y-ball.y)<17)then
            ball.alpha=0
            ballImage.alpha=0
            goodOne = display.newText ("Strokes: ", _W/2-90, _H/2-20,native.systemFont,40)
            goodOne:setTextColor(255,255,0)
            screenGroup:insert(goodOne)
            transition.to (strokeCounter, { time=800 , x=(_W/2 + 80) , y=(_H/2)} )
            local myButton = widget.newButton
        {
        left = 100,
        top = 300,
        width = 150,
        height = 50,
        --defaultFile = "default.png",
        --overFile = "over.png",
        --id = "button_1",
        label = "Next",
        onEvent = handleButtonEvent,
        }
        screenGroup:insert(myButton)
            
        end
        botao:setReferencePoint(display.BottomCenterReferencePoint)
        if (math.abs(botao.x - ball.x) < 20 and math.abs(botao.y - ball.y) < 20) then
                    abrePorta()
        end
    end
    function constroiBancoAreia(x, y)
    local areia = display.newImage("areia.png")
    screenGroup:insert(areia)
    areia:setReferencePoint(display.TopRightReferencePoint)
    areia.x = x --130
    areia.y = y --240
    ball:toFront()
    ballImage:toFront()
    local limite1 = display.newRect(35, 250, 15, 70)
    limite1.isVisible = false
    local limite2 = display.newRect(50, 240, 30, 100)
    limite2.isVisible = false
    local limite3 = display.newRect(80, 260, 15, 80)
    limite3.isVisible = false
    local limite4 = display.newRect(95, 280, 15, 55)
    limite4.isVisible = false  
    local limite5 = display.newRect(110, 290, 15, 40)
    limite5.isVisible = false
    screenGroup:insert(limite1)
    screenGroup:insert(limite2)
    screenGroup:insert(limite3)
    screenGroup:insert(limite4)
    screenGroup:insert(limite5)
end

function alteraFriccao()
    xbegin, ybegin, xend, yend = 35, 240, 125, 340
--    local limiteExterno = display.newRect(xbegin, ybegin, xend - xbegin, yend - ybegin)
--    limiteExterno:setFillColor(255, 255, 255, 100)
    -- verifica se a bola esta na area maior (quadrada)
    if (ball.x > xbegin and ball.x < xend and ball.y > ybegin and ball.y < yend) then
        --verifica se a bola esta dentro da area mais aproximada da figura irregular
            xbeginl1, ybeginl1, xendl1, yendl1 = 35, 250, 50, 320
            xbeginl2, ybeginl2, xendl2, yendl2 = 50, 240, 80, 340
            xbeginl3, ybeginl3, xendl3, yendl3 = 80, 260, 95, 340
            xbeginl4, ybeginl4, xendl4, yendl4 = 95, 280, 110, 335
            xbeginl5, ybeginl5, xendl5, yendl5 = 110, 290, 125, 330
        if (ball.x>xbeginl1 and ball.x<xendl1 and ball.y>ybeginl1 and ball.y<yendl1 or 
            ball.x>xbeginl2 and ball.x<xendl2 and ball.y>ybeginl2 and ball.y<yendl2 or 
            ball.x>xbeginl3 and ball.x<xendl3 and ball.y>ybeginl3 and ball.y<yendl3 or 
            ball.x>xbeginl4 and ball.x<xendl4 and ball.y>ybeginl4 and ball.y<yendl4 or 
            ball.x>xbeginl5 and ball.x<xendl5 and ball.y>ybeginl5 and ball.y<yendl5) then
                taxaDesaceleracao = 2
        else
            taxaDesaceleracao = 1
        end
    else
        taxaDesaceleracao = 1
    end
end
constroiBancoAreia(130, 240)

    function  handleButtonEvent( event )
        
        Runtime:removeEventListener("enterScene", ballEnteredHole)
        Runtime:removeEventListener("enterFrame", ballFriction)
        Runtime:removeEventListener("enterFrame", alteraFriccao)
        storyboard.gotoScene( "quintafase", "slideLeft", 1100  )
        -- body
    end
    ball:addEventListener( "touch", dragBody )
    ball:addEventListener ("touch", increaseCounter)
    Runtime:addEventListener( "enterFrame", ballFriction)
    Runtime:addEventListener("enterFrame", alteraFriccao)


end
function scene:enterScene( event )
    
    -- remove previous scene's view
    storyboard.purgeScene( "terceirafase" )
end

---------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------


return scene


