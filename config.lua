local aspectRatio = display.pixelHeight / display.pixelWigth
local width = 360
local height = width * aspectRatio

application = {
	content = {
		width = width,
		height = height,
		scale = "letterbox",
		fps = 60,
	}
}