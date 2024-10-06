return {
	entry = function()
		local h = cx.active.current.hovered
		if h and h.cha.is_dir then
			ya.manager_emit("enter", {})
			ya.manager_emit("create", {})
			ya.manager_emit("leave", {})
		else
			ya.manager_emit("create", {})
		end
	end,
}
