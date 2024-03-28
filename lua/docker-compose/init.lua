local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local STATES = {
	UP = "up",
	DOWN = "down",
}
local state = STATES.DOWN

-- Check if file exists
function M.file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

-- Start services
function M.up()
	vim.notify("Starting containers...")

	local t = Terminal:new({ cmd = "docker-compose up", hidden = false })
	t:spawn()

	state = "up"
end

-- Stop services
function M.down()
	if state == STATES.UP then
		print("Stopping containers...")
		vim.cmd([[silent !docker-compose down]])
		vim.cmd([[echon '']])
		state = STATES.DOWN
	end
end

-- Kill services
function M.kill()
	if state == STATES.UP then
		print("Killing containers...")
		vim.cmd([[silent !docker-compose kill]])
		vim.cmd([[echon '']])
		state = STATES.DOWN
	end
end

-- Setup plugin
function M.setup()
	vim.api.nvim_create_autocmd("DirChangedPre", {
		callback = function()
			if M.file_exists("docker-compose.yaml") or M.file_exists("docker-compose.yml") then
				M.kill()
			end
		end,
	})
	vim.api.nvim_create_autocmd("DirChanged", {
		callback = function()
			if M.file_exists("docker-compose.yaml") or M.file_exists("docker-compose.yml") then
				M.up()
			end
		end,
	})

	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			if M.file_exists("docker-compose.yaml") or M.file_exists("docker-compose.yml") then
				M.up()
			end
		end,
	})
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			if M.file_exists("docker-compose.yaml") or M.file_exists("docker-compose.yml") then
				M.kill()
			end
		end,
	})
end

return M
