local M = {}

local home_bedroom_arch_desktop = 'MILDRED'
local home_bedroom_win_desktop = nil
local home_workbench_win_desktop = nil
local home_bedroom_arch_laptop = 'vault'
local home_livingroom_debian_sbc = 'rpi'
local work_timewarp_mac_laptop = 'Mac'
local work_veranex_dell_laptop = 'DESKTOP_PVH59MR'


function M.is_personal_computer()
    local personal_hosts = {work_timewarp_mac_laptop,
                            home_bedroom_arch_desktop}
    return vim.tbl_contains(personal_hosts, vim.fn.hostname())
end


function M.is_external_computer()
    local work_hosts = {work_veranex_dell_laptop}
    return vim.tbl_contains(work_hosts, vim.fn.hostname())
end


function M.build_path(env_var, folder)
  local var = vim.env[env_var]
  if not var or var == "" then
    return nil
  end
  return var .. '/' .. folder
end


function M.check_env_var(var_name, description)
    local value = vim.env[var_name]
    if not value or value == "" then
      local error_msg = string.format("Environment variable '%s' is required%s",
        var_name,
        description and (" for " .. description) or "")
      vim.api.nvim_err_writeln(error_msg)
      error(error_msg)
    end
end

return M
