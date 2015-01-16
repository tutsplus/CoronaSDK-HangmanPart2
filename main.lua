display.setStatusBar(display.HiddenStatusBar)display.setDefault( "anchorX",0.5)
display.setDefault( "anchorY", 0.5)math.randomseed( os.time() ) local composer = require ("composer")

composer.gotoScene( "gamescreen" )

