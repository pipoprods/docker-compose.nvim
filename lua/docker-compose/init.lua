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

-- Run through podman-compose if available, fallback to docker-compose
local command = nil
if vim.fn.executable("podman-compose") == 1 then
	command = "podman-compose"
else
	if vim.fn.executable("docker-compose") == 1 then
		command = "docker-compose"
	end
end

-- Start services
function M.up()
	if command == nil then
		vim.notify("docker-compose.nvim requires docker-compose or podman-compose to be installed", vim.log.levels.ERROR)
		return
	end

	vim.notify("Starting containers...")

	local t = Terminal:new({ cmd = command .. " up", hidden = false })
	t:spawn()

	state = STATES.UP
end

-- Stop services
function M.down()
	if state == STATES.UP then
		print("Stopping containers...")
		vim.cmd("silent !" .. command .. " down")
		vim.cmd([[echon '']])
		state = STATES.DOWN
	end
end

-- Kill services
function M.kill()
	if state == STATES.UP then
		print("Killing containers...")
		vim.cmd("silent !" .. command .. " kill")
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
