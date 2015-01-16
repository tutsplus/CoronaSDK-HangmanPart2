local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ("widget")
local growText = require("growtext") -- A module providing a pulsating text effect
local words5 = {} -- Holds words 5 characters or less in length
local words9 = {} -- Holds words 9 characters or less in length
local words13 = {} -- Holds words 13 characters or less in length
local hangmanGroup 
local alphabetArray = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
local guessWordText
local theWord
local guessWord
local numWrong = 0
local gameButtons = {}
local winLoseText
local wonGame = false
function scene:create( event )
	local group = self.view
	readTextFile()
	drawChalkBoard(1,1,1)
	hangmanGroup = display.newGroup()
	group:insert(hangmanGroup)
	hangmanGroup.x = 180
	hangmanGroup.y = 180
	drawGallows()	createGuessWordText()	createWinLoseText()	setupButtons()
end


function scene:show( event )
	local phase = event.phase
    local previousScene = composer.getSceneName( "previous" )
	if(previousScene~=nil) then

		composer.removeScene(previousScene)
	end
   if ( phase == "did" ) then
		Runtime:addEventListener( "gameOverEvent", gameOver )
   end
end

function scene:hide( event )
		local phase = event.phase
		if ( phase == "will" ) then
    		Runtime:removeEventListener( "gameOverEvent", gameOver )
		end
end


function drawChalkBoard(r,g,b)
local chalkBoard = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
		 chalkBoard:setFillColor(r,g,b)
		 chalkBoard.anchorX = 0
		chalkBoard.anchorY = 0
		scene.view:insert(chalkBoard)
end

function drawGallows()
	local gallows = display.newLine( hangmanGroup,20,380,360, 380)
	gallows:append(290,380,290,50,180,50,180,90)

    gallows:setStrokeColor(0, 0, 0)
     gallows.strokeWidth = 3
end

function drawHead()
 		local head = display.newCircle(hangmanGroup,150,90,30)
 		head:setStrokeColor(0,0,0)
 		head:setFillColor(0,0,0,0)
 		head.strokeWidth = 3
         head.anchorX = 0
 		head.anchorY = 0
 end
 
function drawBody()
	local body = display.newLine(hangmanGroup,180,150,180,300) 
	body:setStrokeColor(0, 0, 0)
    body.strokeWidth = 3
end

function drawArm1()
	local arm = display.newLine(hangmanGroup,180,200,130,190)
	arm:setStrokeColor(0, 0, 0)
    arm.strokeWidth = 3

end

function drawArm2()
	local arm= display.newLine(hangmanGroup,180,200,230,190)
	arm:setStrokeColor(0, 0, 0)
    arm.strokeWidth = 3

end

function drawLeg1()
	local leg = display.newLine(hangmanGroup,180,300,130,330)

	leg:setStrokeColor(0, 0, 0)
    leg.strokeWidth = 3
end

function drawLeg2()
	local leg = display.newLine(hangmanGroup,180,300,230,330)

	leg:setStrokeColor(0, 0, 0)
    leg.strokeWidth = 3
end
function readTextFile()
local path = system.pathForFile( "wordlist.txt",  	system.ResourceDirectory)
local file = io.open( path, "r" )
for line in file:lines() do
		--If targeting Windows Operating System comment the following line out
		-- line = string.sub(line,  1, #line - 1)
		 if(#line >=3 and #line <=5)then
			table.insert(words5,line)
		elseif (#line >=3 and #line<=9)then
			table.insert(words9,line)
		elseif (#line >=3 and #line<=13)then
			table.insert(words13,line)
		 end
end
	io.close( file )
    file = nil

endfunction createGuessWord()
			guessWord = {}
			local randomIndex = math.random(#words5)
			theWord = words5[randomIndex];
			print(theWord)
			for i=1, #theWord do
				local character= theWord:sub(i,i)

				if(character == "'")then
					guessWord[i] ="'";
				elseif(character=="-")then
					guessWord[i] = "-"
				else
				guessWord[i]="?";
				end
			end
			local newGuessWord = table.concat(guessWord)
			return newGuessWord;
endfunction createGuessWordText()
	local options = 
		{
			text = createGuessWord(),     
			x = 384,
	    	y = 70,
	    	width = 700,     --required for multi-line and alignment
	    	font = native.systemFontBold,   
	    	fontSize = 50,
	   	 align = "center"  --new alignment parameter
		}
	guessWordText = display.newText(options)
	guessWordText:setFillColor(0,0,0)
    scene.view:insert(guessWordText)
end
function createWinLoseText()
	winLoseText =  growText.new( "YOU WIN",display.contentCenterX,display.contentCenterY-100, native.systemFontBold, 20,scene.view)	winLoseText:setVisibility(false)
end
function setupButtons()
	local xPos=150
	local yPos = 600
	for i=1, #alphabetArray do
		if (i == 9 or i == 17) then
					yPos = yPos + 65
					xPos = 150
		end
		if (i == 25) then
					yPos = yPos + 65
					xPos = 330
		end
		local tempButton = widget.newButton{
			label = alphabetArray[i],
			labelColor = { default ={ 1,1,1}},
			onPress = checkLetter,
			 shape="roundedRect",
            width = 40,
   	 	height = 40,
    		cornerRadius = 2,
    		fillColor = { default={0, 0, 0, 1 }, over={ 0.5, 0.5, 0.5, 0.4 } },
    		strokeColor = { default={ 0.5, 0.5, 0.5, 0.4 }, over={ 0, 0, 0, 1  } },
    		strokeWidth = 5
		}
		tempButton.x = xPos
		tempButton.y = yPos
				xPos = xPos + 60
		table.insert(gameButtons,tempButton)
	end
endfunction checkLetter(event)
			local tempButton = event.target
			local theLetter = tempButton:getLabel()
			theLetter = string.lower(theLetter)
			local correctGuess  = false
			local newGuessWord = ""
			tempButton.isVisible = false
			
			for  i =1 ,#theWord do
				local character= theWord:sub(i,i)
				if(character == theLetter)then
					guessWord[i] = theLetter
					correctGuess = true
				end
			end
				newGuessWord = table.concat(guessWord)
				guessWordText.text = newGuessWord
				
				if(correctGuess == false)then
					numWrong = numWrong +1

					drawHangman(numWrong);
				end
				
				if(newGuessWord == theWord)then 
						wonGame = true
						didWinGame(true)	
				end
				
				if(numWrong == 6) then
					hideButtons()
					for i =1 , #theWord do
						guessWord[i] = theWord:sub(i,i)

						newGuessWord = table.concat(guessWord)
						guessWordText.text = newGuessWord;
					end
					didWinGame(false)
				end
endfunction didWinGame(gameWon)
	hideButtons()
	winLoseText:setVisibility(true)
	if(gameWon == true)then
		winLoseText:setText("YOU WIN!!")
		winLoseText:setColor(0,0,1)
	else
		winLoseText:setText("YOU LOSE!!")
		winLoseText:setColor(1,0,0)
	end
     winLoseText:grow()
endfunction hideButtons()
	for i=1, #gameButtons do
		gameButtons[i].isVisible = false
	end
end

function showButtons()
	for i=1, #gameButtons do
		gameButtons[i].isVisible = true
	end
endfunction drawHangman(drawNum)
		  if(drawNum== 0) then
				drawGallows();
		elseif(drawNum ==1)then
				drawHead();
		elseif(drawNum == 2) then
				drawBody();
		elseif(drawNum == 3) then
				drawArm1();
		elseif(drawNum == 4) then
			 	drawArm2();
		elseif(drawNum == 5) then
			 	drawLeg1();
		elseif(drawNum == 6) then
			 	drawLeg2();
		  end
endfunction gameOver()
	winLoseText:setVisibility(false)
	if(wonGame == true)then
		composer.gotoScene("gameoverscreen")
	else
		newGame()
	end
endfunction newGame()
	clearHangmanGroup()
	drawHangman(0)
	numWrong = 0
	guessWordText.text = createGuessWord()
	showButtons()
endfunction clearHangmanGroup()
	for i = hangmanGroup.numChildren, 1 ,-1 do
		hangmanGroup[i]:removeSelf()
    	hangmanGroup[i]=nil
	end endscene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
