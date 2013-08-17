-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local _W = display.contentWidth
local _H = display.contentHeight
local physics = require("physics")
local gameUI = require("gameUI")


physics.start()
local bg = display.newImage ("grassbg.png", true)
--physics.addBody(bg)
bg.x = display.contentCenterX
bg.y = display.contentCenterY
local hole = display.newCircle (_W/2, 100, 15)
hole:setFillColor(0,0,0)
local ball = display.newCircle (_W/2, 400, 10)
physics.addBody(ball, {density = 1, friction = 1})
physics.setGravity(0,0)

system.activate( "multitouch" )
local function dragBody( event )
	return gameUI.dragBody( event )
	
	-- Substitute one of these lines for the line above to see what happens!
	--gameUI.dragBody( event, { maxForce=400, frequency=5, dampingRatio=0.2 } ) -- slow, elastic dragging
	--gameUI.dragBody( event, { maxForce=20000, frequency=1000, dampingRatio=1.0, center=true } ) -- very tight dragging, snaps to object center
end
function ballFriction()
	ball.angularVelocity=0
	local vx, vy=ball:getLinearVelocity()
	if (vx ~=0 or vy ~=0)then

	    local newvx=vx*(1 - (10000)/((vx*vx)+(vy*vy)))
	    local newvy=vy*(1 - (10000)/((vx*vx)+(vy*vy)))
	    if ((newvy/vy)<0 or (newvx/vx)<0)then
	    	newvy=0
	    	newvx=0
	    end
	    if (ball.x > display.contentWidth - 10 or ball.x < 10) then
                newvx = newvx * -1;
        end
        if (ball.y > display.contentHeight - 10 or ball.y < 10) then
                newvy = newvy * -1;
        end




	    ball:setLinearVelocity(newvx,newvy)
	end
	
end

function ballEnteredHole()
	if (math.abs(hole.x-ball.x)<8 and math.abs(hole.y-ball.y)<5)then
		ball.alpha=0
		goodOne = display.newText ("You Win!", _W/2, _H/2)
	end
end
ball:addEventListener( "touch", dragBody )
Runtime:addEventListener( "enterFrame", ballFriction)
Runtime:addEventListener( "enterFrame", ballEnteredHole)




