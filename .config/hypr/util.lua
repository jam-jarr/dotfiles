local M = {}

ICON_FILE_ON = os.getenv("HOME") .. "/.config/hypr/icons/hypr.ico"
ICON_FILE_OFF = os.getenv("HOME") .. "/.config/hypr/icons/hypr_desaturated.ico"

local notify_send = function(message, icon)
	local fstr = string.format("notify-send --transient --icon=%s 'Hyprland' '%s'", icon, message)
	hl.exec_cmd(fstr)
end

M.notify = function(message, opts)
	local icon
	if opts ~= nil and opts.negative == true then
		icon = ICON_FILE_OFF
	else
		icon = ICON_FILE_ON
	end
	notify_send(message, icon)
end

return M
