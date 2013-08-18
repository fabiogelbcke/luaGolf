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
local ball = display.newCircle (_W/2, 400,25)

ball.alpha=0.01
local ballImage = display.newImage ("pequena.png",_W/2, 400)
physics.addBody(ball, {density = 1, friction = 0.1, bounce =0.2})
screenGroup:insert(ball)
ball.isBullet=true
local ob2 = display.newRect (70,250,180, 15 )
physics.addBody(ob2, {density=9999999})
ob2.angularVelocity=200
screenGroup:insert(ob2)
physics.setGravity(0,0)
system.activate( "multitouch" )
local function dragBody( event )
	return gameUI.gameUI.dragBody( event, { maxForce=600, frequency=5, dampingRatio=0.2 } )

	
	-- Substitute one of these lines for the line above to see what happens!
	--gameUI.dragBody( event, { maxForce=400, frequency=5, dampingRatio=0.2 } ) -- slow, elastic dragging
	--gameUI.dragBody( event, { maxForce=20000, frequency=1000, dampingRatio=1.0, center=true } ) -- very tight dragging, snaps to object center
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

	    local newvx=vx*(1 - (2000)/((vx*vx)+(vy*vy)))
	    local newvy=vy*(1 - (2000)/((vx*vx)+(vy*vy)))
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
	
	
end

function  handleButtonEvent( event )
	storyboard.gotoScene( "quartafase", "slideLeft", 1100  )
	Runtime:removeEventListener("enterScene", ballEnteredHole)
	Runtime:removeEventListener("enterFrame", ballFriction)
	-- body
end
ball:addEventListener( "touch", dragBody )
ball:addEventListener ("touch", increaseCounter)
Runtime:addEventListener( "enterFrame", ballFriction)


end
function scene:enterScene( event )
	
	-- remove previous scene's view
	storyboard.purgeScene( "segundafase" )
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


