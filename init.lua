local stackedWindows = {}

function iconFromAppName(app)
	local appBundle = hs.appfinder.appFromName(app):bundleID()
	return hs.image.imageFromAppBundle(appBundle)
end

function isWindowInScreen(screen, window)
	local margin = 5
	local R1 = screen:frame()
	local R2 = window:frame()
	return (R2.x + R2.w) <= (R1.x + R1.w) and R2.x >= R1.x and R2.y >= R1.y and (R2.y + R2.h) <= (R1.y + R1.h + margin)
end

function recreateStackWindow()
	print("cleaning stacked windows")
	for i, c in pairs(stackedWindows) do
		hs.inspect(c)
		c:delete()
	end

	stackedWindows = {}

	local visibleWindows = hs.window.visibleWindows()
	local windowCount = #visibleWindows
	local startAt = 300

	for i, screen in pairs(hs.screen.allScreens()) do
		if windowCount > 1 then
			for j, window in pairs(visibleWindows) do
				if isWindowInScreen(screen, window) then
					print(
						"adding: window = "
							.. window:title()
							.. ", app = "
							.. window:application():name()
							.. " to screen "
							.. screen:name()
					)
					local canvas = hs.canvas.new({ x = screen:frame().x - 3, y = startAt + 30 * j, h = 50, w = 50 })

					canvas:insertElement({
						type = "rectangle",
						action = "fill",
						fillColor = { green = 1 },
						frame = { x = 0, y = 0, h = 25, w = 25 },
						roundedRectRadii = { xRadius = 5, yRadius = 5 },
						withShadow = true,
						shadow = { blurRadius = 5.0, color = { alpha = 1 / 3 }, offset = { h = -5.0, w = 5.0 } },
					}, 1)
					canvas
						:insertElement({
							type = "image",
							image = iconFromAppName(window:application():title()),
							frame = { x = 0, y = 0, h = 25, w = 25 },
							imageAlpha = 1,
							fillColor = { red = 1.0 },
						}, 2)
						:show()
					table.insert(stackedWindows, canvas)
				end
			end
		end
	end
end

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "r", function()
	hs.reload()
end)

hs.spaces.watcher
	.new(function(s)
		recreateStackWindow(hs.spaces.focusedSpace())
	end)
	:start()
