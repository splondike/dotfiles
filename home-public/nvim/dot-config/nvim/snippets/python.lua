-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#functionnode
local ts_utils = require 'nvim-treesitter.ts_utils'

-- gsplit: iterate over substrings in a string separated by a pattern
--
-- Parameters:
-- text (string)    - the string to iterate over
-- pattern (string) - the separator pattern
-- plain (boolean)  - if true (or truthy), pattern is interpreted as a plain
--                    string, not a Lua pattern
--
-- Returns: iterator
--
-- Usage:
-- for substr in gsplit(text, pattern, plain) do
--   doSomething(substr)
-- end
--
-- See https://stackoverflow.com/a/43582076
local function gsplit(text, pattern, plain)
  local splitStart, length = 1, #text
  return function()
    if splitStart then
      local sepStart, sepEnd = string.find(text, pattern, splitStart, plain)
      local ret
      if not sepStart then
        ret = string.sub(text, splitStart)
        splitStart = nil
      elseif sepEnd < sepStart then
        -- Empty separator!
        ret = string.sub(text, splitStart, sepStart)
        if sepStart < length then
          splitStart = sepStart + 1
        else
          splitStart = nil
        end
      else
        ret = sepStart > splitStart and string.sub(text, splitStart, sepStart - 1) or ''
        splitStart = sepEnd + 1
      end
      return ret
    end
  end
end

local function unpluralise(args)
  local plural_name = args[1][1]
  if plural_name:match 'ies$' then
    return plural_name:sub(0, -#'ies' - 1) .. 'y'
  elseif plural_name:match 's$' then
    return plural_name:sub(0, -#'s' - 1)
  else
    return 'item'
  end
end

local function calculate_assignments(args)
  local params = args[1][1]
  local rtn = {}
  for match in gsplit(params, ', *', false) do
    if match ~= '' then
      -- gsplit returns iterator
      for raw_variable in gsplit(match, ': *', false) do
        table.insert(rtn, '\tself.' .. raw_variable .. ' = ' .. raw_variable)
        break
      end
    end
  end
  return rtn
end

local function build_for_snippet(trigger, content)
  return s(
    trigger,
    fmta(content, {
      item = f(unpluralise, { 1 }),
      items = i(1, 'items'),
      finish = i(0),
    })
  )
end

return {
  build_for_snippet(
    'f',
    [[
        for <item> in <items>:
            <finish>
    ]]
  ),
  build_for_snippet(
    'fi',
    [[
        for idx, <item> in enumerate(<items>):
            <finish>
    ]]
  ),
  build_for_snippet(
    'fa',
    [[
        [
            {
                <finish>
            }

            for <item> in <items>
        ]
    ]]
  ),
  build_for_snippet(
    'fd',
    [[
        {
            <finish>

            for <item> in <items>
        }
    ]]
  ),
  build_for_snippet(
    'rf',
    [[
        return [
            {
                <finish>
            }

            for <item> in <items>
        ]
    ]]
  ),
  build_for_snippet(
    'rrtn',
    [[
        rtn = []

        for <item> in <items>:
            <finish>

        return rtn
    ]]
  ),
  s(
    'fni',
    fmta(
      [[
          def __init__(self, <args>):
          <assignments>
  ]],
      {
        args = i(1),
        assignments = f(calculate_assignments, 1),
      }
    )
  ),
}
