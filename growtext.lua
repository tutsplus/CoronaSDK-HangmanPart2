local growText = {}
local growText_mt = {__index = growText}


function growText.new(theText,positionX,positionY,theFont,theFontSize,theGroup)
	  local theTextField = display.newText(theText,positionX,positionY,theFont,theFontSize)
	  
local newGrowText = {
     theTextField = theTextField}
     if(theGroup ~=nil)then
     theGroup:insert(theTextField) 
     end                                       
	return setmetatable(newGrowText,growText_mt)
end

function growText:setColor(r,b,g)
  self.theTextField:setFillColor(r,g,b)
end

function growText:grow()
	transition.to( self.theTextField, { xScale=4.0, yScale=4.0, time=2000, iterations = 1,onComplete=function()
			local event = {
						name = "gameOverEvent",
			}
			self.theTextField.xScale = 1
			self.theTextField.yScale = 1
	Runtime:dispatchEvent( event )
end
	} )
end

function growText:setVisibility(visible)
  if(visible == true)then
  	self.theTextField.isVisible = true
  else
  	self.theTextField.isVisible = false
  end
  self.theTextField.xScale = 1
  self.theTextField.yScale = 1
end

function growText:setText(theText)
	self.theTextField.text = theText
end
return growText
