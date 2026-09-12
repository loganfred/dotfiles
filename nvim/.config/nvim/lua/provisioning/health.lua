local M = {}

local function is_macos()
  return vim.fn.has('mac') == 1
end

local function is_windows()
  return vim.fn.has('win32') == 1 or vim.fn.has('win64')
end

local function is_linux()
  return vim.fn.has('linux') == 1
end


-- Helper function to check if a command exists
local function command_exists(cmd)
  local handle = io.popen("which " .. cmd .. " 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result ~= ""
  end
  return false
end

-- Helper function to get command version
local function get_version(cmd, version_flag)
  version_flag = version_flag or "--version"
  local handle = io.popen(cmd .. " " .. version_flag .. " 2>/dev/null")
  if handle then
    local result = handle:read("*l") -- Read first line only
    handle:close()
    return result
  end
  return nil
end

-- Helper function to check environment variables
local function check_env_var(var_name, expected_value)
  local value = vim.env[var_name]
  if not value then
    return false, "not set"
  elseif expected_value and value ~= expected_value then
    return false, "set to '" .. value .. "' but expected '" .. expected_value .. "'"
  else
    return true, value
  end
end

local function check_binary(bin_name, remediation)
  -- bin_name is a string (e.g. git)
  -- remediation is a table of strings, one per line

  if command_exists(bin_name) then

    local version = get_version(bin_name)
    local version_str = version and version or "unknown"
    local out_str = ""

    vim.health.ok(string.format("%s is installed (version: %s)", bin_name, version))

  else
    vim.health.error(bin_name .. " not found", remediation)
  end
end

-- Main health check function
function M.check()
  vim.health.start("Binaries")

  check_binary("git", {"install it"})
  check_binary("jq", {"install it"})
  check_binary("yq", {"install it"})
  check_binary("fzf", {"install it"})
  check_binary("pandoc", {"install it"})
  check_binary("pdflatex", {"install it"})
  check_binary("ffmpeg", {"install it"})
  check_binary("uv", {"install it"})

  if is_macos() or is_linux() then
    check_binary("zathura", {"install it"})
  else
    check_binary("sioyek", {"install it (windows only)"})
  end

  vim.health.start("Environment Variables")

  -- Check some common development environment variables
  local env_checks = {
    { "EDITOR", vim.env.EDITOR },
    { "SHELL", nil }, -- Just check if it exists, don't care about value
    { "PATH", nil },
    { "HOME", nil },
    { "USERPROFILE", nil },
    { "NOTES", nil },
    { "NOTES_QA", nil },
    { "NOTES_LINKS", nil },
    { "NOTES_PROVISIONING", nil },
    { "NOTES_WINS", nil },
    { "VIMWIKI_PATH", nil }
  }

  for _, check in ipairs(env_checks) do
    local var_name, expected = check[1], check[2]
    local exists, value = check_env_var(var_name, expected)

    if exists then
      if var_name == "PATH" then
        local path_count = 0
        for _ in value:gmatch("[^:]+") do
          path_count = path_count + 1
        end
        vim.health.ok(var_name .. ": " .. path_count .. " paths configured")
      else
        vim.health.ok(var_name .. ": " .. (value or "set"))
      end
    else
      if var_name == "EDITOR" then
        vim.health.warn(var_name .. ": " .. value, {
          "Set EDITOR environment variable to your preferred editor",
          "Example: export EDITOR=nvim"
        })
      else
        vim.health.error(var_name .. ": " .. value)
      end
    end
  end

  vim.health.start("System Information")

  -- Display some useful system info
  vim.health.info("OS: " .. vim.loop.os_uname().sysname)
  vim.health.info("Hostname: " .. vim.fn.hostname())
  vim.health.info("Neovim version: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch)
  vim.health.warn("System classification: UNKNOWN")
  vim.health.warn("Terminal Font: UNKNOWN")
  vim.health.warn("Terminal App: UNKNOWN")
  vim.health.warn("Hotkey Software: UNKNOWN")
  vim.health.warn("Ipython Terminal: UNKNOWN")

  -- Check if we're in a terminal that supports true color
  if vim.env.COLORTERM == "truecolor" or vim.env.COLORTERM == "24bit" then
    vim.health.ok("Terminal supports true color")
  else
    vim.health.warn("Terminal may not support true color", {
      "Set COLORTERM=truecolor in your terminal or shell profile",
      "This enables better syntax highlighting"
    })
  end
end

return M
