local textobject = require '../plugin/textobject'

local function extent_test(template)
  local str = ''
  local col = 0
  local start_extent, end_extent, pos = 1, 1, 0
  for i = 1, template:len() do
    local c = template:sub(i, i)
    if c == '|' then
      col = pos + 1
    elseif c == '[' then
      start_extent = pos + 1
    elseif c == ']' then
      end_extent = pos
    else
      str = str .. c
      pos = pos + 1
    end
  end

  local startpos, endpos = textobject.find_extent(str, col)
  assert.are.equal(start_extent, startpos, 'startpos for ' .. template)
  assert.are.equal(end_extent, endpos, 'endpos for ' .. template)
end

describe('find_extent', function()
  it('should handle snake case', function()
    extent_test '[|some]_snake_case'
    extent_test 'some_[snak|e]_case'
    extent_test 'some_[SNAK|E]_case'
    extent_test 'some_[|snake]_case'
  end)
  it('should handle kebab case', function()
    extent_test 'some-[keba|b]_case'
    extent_test 'some_[|kebab]_case'
  end)
  it('should handle camel case', function()
    extent_test 'Some[|Camel]Case'
    extent_test 'Some[|CCamel]Case'
    extent_test 'Some[Came|l]Case'
    extent_test 'Some[CCame|l]Case'
    extent_test 'SomeCamel[C|ase]'
    extent_test '-- [|Some]CamelCase'
  end)
end)
