local M = {}

M.notify = function(message)
	hl.exec_cmd("notify-send --transient " .. message)
end

return M
