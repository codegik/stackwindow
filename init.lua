local stackedWindows = {}

function iconFromAppName(app)
	local appBundle = hs.appfinder.appFromName(app):bundleID()
	return hs.image.imageFromAppBundle(appBundle)
end

function recreateStackWindow(space)
	print("cleanning stacked windows")
	for i, c in pairs(stackedWindows) do
		hs.inspect(c)
		c:delete()
	end

	stackedWindows = {}

	local size = #hs.window.visibleWindows()
	local startAt = 300

	if size > 1 then
		for i, window in pairs(hs.window.visibleWindows()) do
			print("adding: window = " .. window:title() .. ", id = " .. window:id())
			local canvas = hs.canvas.new({ x = 0, y = startAt + 40 * i, h = 50, w = 50 })
			canvas
				:insertElement({
					type = "image",
					image = iconFromAppName(window:application():title()),
					frame = { x = 0, y = 10, h = 30, w = 30 },
					imageAlpha = 0.5,
					fillColor = { red = 1.0 },
				})
				:show()
			if window:id() == hs.window.focusedWindow():id() then
				print("hightlighing: window = " .. window:title() .. ", id = " .. window:id())
				canvas[1].imageAlpha = 1
			end
			table.insert(stackedWindows, canvas)
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
