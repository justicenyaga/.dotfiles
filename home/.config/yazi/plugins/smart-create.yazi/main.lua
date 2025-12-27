--- @sync entry

return {
	entry = function()
		local h = cx.active.current.hovered
		if h and h.cha.is_dir then
			ya.emit("enter", {})
			ya.emit("create", {})
			ya.emit("leave", {})
		else
			ya.emit("create", {})
		end
	end,
}
