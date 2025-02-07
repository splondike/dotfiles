local function calc_commit_prefix()
  local result = io.popen('git rev-parse --abbrev-ref HEAD', 'r')
  if result == nil then
    return ''
  end

  for line in result:lines() do
    local options = { { 'feature', 'feat' }, { 'fix', 'fix' } }
    for _, option in ipairs(options) do
      local matcher = '^' .. option[1] .. '/([a-zA-Z]+)-([0-9]+)'
      local _, _, proj, num = line:find(matcher)
      if proj ~= nil then
        return option[2] .. '(' .. string.upper(proj) .. '-' .. num .. '): '
      end
    end
  end
  return ''
end

return {
  s('tt', f(calc_commit_prefix)),
}
