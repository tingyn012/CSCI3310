-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local start = false

local objects = {}
local objectCount = 10

-- include Corona's "physics" library
local physics = require "physics"

local count = 0

if finish ~= true then
	score = 0
--	level = 1
	finish = false
end

local scoreshow = display.newText(score, 280, 20 , String , 16)
--local levelshow = display.newText("Level : " .. level, 170, 20 , String , 16)



--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local grass = display.newRect( 0 , 0, 75, 15 )

-- create wall objects
local topWall = display.newRect( 0 , 0, screenW * 2, 10 )
local bottomWall = display.newRect(0 , screenH, screenW * 2, 10 )
bottomWall:setFillColor( 0.5 )
local leftWall = display.newRect( 0, 0, 10, display.contentHeight * 2 )
local rightWall = display.newRect( screenW , 0, 10, screenH * 2 )

function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	-- We need physics started to add bodies, but we don't want the simulaton
	-- running until the scene is on the screen.

	physics.start()
	physics.setGravity( 0 , 0 )
	physics.pause()

	-- create a grey rectangle as the backdrop
	-- the physical screen will likely be a different shape than our defined content area
	-- since we are going to position the background from it's top, left corner, draw the
	-- background at the real top, left corner.
	local background = display.newRect( display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 0 )

	-- make them physics bodies
	physics.addBody(topWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	physics.addBody(bottomWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	physics.addBody(leftWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})
	physics.addBody(rightWall, "static", {density = 1.0, friction = 0, bounce = 1, isSensor = false})

	count = 0;

	crate = display.newCircle( 0 , 0 , 10 )

	local function onCollision(event)
		local vx, vy = crate:getLinearVelocity()
			if vy < 0 then
			crate:setLinearVelocity( vx , -300 )
			else
			crate:setLinearVelocity( vx , 300 )
			end
	end

	crate:addEventListener("collision", onCollision)

	-- make a crate (off-screen), position it, and rotate slightly
	crate.x, crate.y = display.screenOriginX + 150, display.actualContentHeight + display.screenOriginY - 110
	crate.rotation = 0
		
	-- create a grass object and add physics (with custom shape)
	grass.anchorX = 0
	grass.anchorY = 1
	--  draw the grass at the very bottom of the screen
	grass.x, grass.y = display.screenOriginX + 115, display.actualContentHeight + display.screenOriginY - 80
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -75/2,-15/2, 75/2,-15/2, 75/2,15/2, -75/2,15/2 }
	physics.addBody( grass, "static", { friction=0.0 , bounce=1.0 , shape=grassShape } )
	

	local function BoxOnCollision(event)
		event.target:removeSelf()
		count = count + 1
		score = score + 100
		scoreshow.text = score

		-- if break all box, reset level
		if count > 39 then
		finish = true
		display.remove( scoreshow )
		composer.removeScene("level1"); 
		composer.gotoScene("level1")
		end
	end

	for i = 1, objectCount do

		objects[i] = display.newRect(40 + 27 * (i - 1) , 40 , 25 , 10)
	    objects[i]:setFillColor( 1, 0, 0 )
	    physics.addBody(objects[i], "static", {density = 1.0, friction = 0, bounce = 1.0})
	    objects[i]:addEventListener("collision", BoxOnCollision)

	    objects[i] = display.newRect(40 + 27 * (i - 1) , 60 , 25 , 10)
	    objects[i]:setFillColor( 1, 0, 1 )
	    physics.addBody(objects[i], "static", {density = 1.0, friction = 0, bounce = 1.0})
	    objects[i]:addEventListener("collision", BoxOnCollision)

	    objects[i] = display.newRect(40 + 27 * (i - 1) , 80 , 25 , 10)
	    objects[i]:setFillColor( 0, 1, 0 )
	    physics.addBody(objects[i], "static", {density = 1.0, friction = 0, bounce = 1.0})
	    objects[i]:addEventListener("collision", BoxOnCollision)


	    objects[i] = display.newRect(40 + 27 * (i - 1) , 100 , 25 , 10)
	    objects[i]:setFillColor( 0, 0, 1)
	    physics.addBody(objects[i], "static", {density = 1.0, friction = 0, bounce = 1.0 })
	    objects[i]:addEventListener("collision", BoxOnCollision)

	end

	local function myTouchListener( event )
 
		-- print( "Touch X location" .. event.x )
		-- print( "Touch Y location" .. event.y )

		if start == false then
			if event.y > screenW then
    		physics.addBody( crate, { density=1.0, friction=0.0, bounce=1.0 } )
    		crate:setLinearVelocity( 200 , -300 )
			else
    		physics.addBody( crate, { density=1.0, friction=0.0, bounce=1.0 } )
    		crate:setLinearVelocity( -200 , -300 )
			end
    		start = true
		end

		if event.x > 0 and event.x < 245 then
		grass.x = event.x
		elseif event.x > 245 then
		grass.x = 245
		end
	end

	local function BottomOnCollision(event)
		score = 0
		display.remove( scoreshow )

		for i = 1, objectCount do
			if objects[i] ~= nil then
			display.remove( objects[i] )
			end
		end

		composer.removeScene("level1")
		composer.gotoScene("level1")
	end

	-- Touch control
	Runtime:addEventListener("touch", myTouchListener)

	-- Box Collision
	bottomWall:addEventListener("collision", BottomOnCollision)

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( grass)
	sceneGroup:insert( crate )
	sceneGroup:insert( topWall )
	sceneGroup:insert( bottomWall )
	sceneGroup:insert( leftWall )
	sceneGroup:insert( rightWall )


end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	package.loaded[physics] = nil
	physics = nil
end


---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


-----------------------------------------------------------------------------------------

return scene