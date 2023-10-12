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
	print("cleanning stacked windows")
	for i, c in pairs(stackedWindows) do
		hs.inspect(c)
		c:delete()
	end

	stackedWindows = {}

	local visibleWindows = hs.window.visibleWindows()
	local size = #visibleWindows
	local startAt = 300

	for i, screen in pairs(hs.screen.allScreens()) do
		if size > 1 then
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
					local canvas = hs.canvas.new({ x = screen:frame().x, y = startAt + 40 * j, h = 50, w = 50 })
					canvas
						:insertElement({
							type = "image",
							image = iconFromAppName(window:application():title()),
							frame = { x = 0, y = 0, h = 30, w = 30 },
							imageAlpha = 1,
							fillColor = { red = 1.0 },
						})
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
