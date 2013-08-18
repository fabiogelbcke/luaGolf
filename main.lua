display.setStatusBar( display.HiddenStatusBar )

-- require controller module
local storyboard = require "storyboard"
local widget = require "widget"

-- load first scene
storyboard.gotoScene( "quartafase", "fade", 1500 )