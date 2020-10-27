local aspectRatio = display.pixelHeight / display.pixelWigth
local width = display.pixelWigth
local height = width * aspectRatio

application = {
	content = {
		width = width,
		height = height,
		scale = "letterbox",
		fps = 60,
	}
}