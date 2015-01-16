local composer = require( "composer" )
local scene = composer.newScene()
local hangmanSprite 
local hangmanAudio
function scene:create( event )
	local group = self.view
	drawChalkBoard()
	local options = { width = 164,height = 264,numFrames = 86}
	local hangmanSheet = graphics.newImageSheet( "hangmanSheet.png", options )
	local sequenceData = {
  	 {  start=1, count=86, time=8000,   loopCount=1 }
	}
	hangmanSprite = display.newSprite( hangmanSheet, sequenceData )
	hangmanSprite.x = display.contentCenterX
    hangmanSprite.y = display.contentCenterY
    hangmanSprite.xScale = 1.5
    hangmanSprite.yScale = 1.5
    group:insert(hangmanSprite)

end

function scene:show( event )
	local phase = event.phase

       local previousScene =  composer.getSceneName("previous")
		composer.removeScene(previousScene)

	 if ( phase == "did" ) then
	    hangmanSprite:addEventListener( "sprite", hangmanListener )
		hangmanSprite:play()
        hangmanAudio = audio.loadSound( "danceMusic.mp3" )
		audio.play(hangmanAudio)
   end

end

function scene:hide( event )
		local phase = event.phase
		if ( phase == "will" ) then
			hangmanSprite:removeEventListener( "sprite", hangmanListener )			audio.stop(hangmanAudio)			audio.dispose(hangmanAudio)
		end
end

function drawChalkBoard()
local chalkBoard = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
		 chalkBoard:setFillColor(1,1,1 )
		 chalkBoard.anchorX = 0
		chalkBoard.anchorY = 0
		scene.view:insert(chalkBoard)
end



function hangmanListener( event )
 	if ( event.phase == "ended" ) then
	 	timer.performWithDelay(1000,newGame,1)
	end
end
function newGame()
	composer.gotoScene("gamescreen")
end
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene
