local stackMap = {}


function iconFromAppName(app)
	local appBundle = hs.appfinder.appFromName(app):bundleID()
	return hs.image.imageFromAppBundle(appBundle)
end


function createStack(space)
	if stackMap[space] then
		for i, c in pairs(stackMap[space]) do
			c:delete()
		end
	end

	local canvas = {}
	local size = #hs.window.visibleWindows()
	local startAt = 300

	if size > 1 then
		for i, window in pairs(hs.window.visibleWindows()) do
			print("adding icon for " .. window:application():title())
			canvas[i] = hs.canvas.new({ x = 0, y = startAt + 40 * i, h = 50, w = 50 })
			canvas[i]:insertElement({
				type = "image",
				image = iconFromAppName(window:application():title()),
				frame = {x = 0, y = 10, h = 30, w = 30},
				imageAlpha = 0.5,
				fillColor = { red = 1.0 }
			})
			canvas[i]:show()
		end

		canvas[1][1].imageAlpha = 1
		stackMap[space] = canvas
		print("added in space " .. space)
	else
		print("space is empty " .. space)
	end
end


hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "r", function()
	hs.reload()
end)


hs.spaces.watcher.new(function(s)
	createStack(hs.spaces.focusedSpace())
end):start()




