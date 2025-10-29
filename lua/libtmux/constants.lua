local M = {}

M.SESSION_FORMAT = "#{session_attached},#{session_id},#{session_name}"

M.generate_session_format_list = function()
	local sessions = string.gsub(M.SESSION_FORMAT, "#{session_", "")
	sessions = string.gsub(sessions, "}", "")
	sessions = vim.fn.split(sessions, ",")
	return sessions
end

return M
