function async(p)
    local co = coroutine.create(p)
    return Async.promisify(co)
end

function await(v) return Async.await(v) end

function interpolate(a, b, t)
  return a * (1 - t) + b * t
end

function listFilesByType(path, fileType)
    local files = {}
    local cmd
  
    -- Check if running on Windows or Unix-like system
    if package.config:sub(1,1) == '\\' then
      -- Windows command
      cmd = 'dir "' .. path .. '\\*.' .. fileType .. '" /b'
    else
      -- Unix-like command
      cmd = 'find "' .. path .. '" -maxdepth  1 -type f -name "*.' .. fileType .. '" -exec basename {} \\;'
    end
  
    -- Execute the command and read the output line by line
    local handle = io.popen(cmd)
    for filename in handle:lines() do
      table.insert(files, filename)
    end
    handle:close()
  
    return files
end

function getFirstPart(str)
    return (str:match('^(.*)%.')) or str
end

function get_nested_table_value(table, nested_keys)
  local value = table
  for _, key in ipairs(nested_keys) do
      if type(value) == "table" then
          value = value[key]
      else
          return nil
      end
  end
  return value
end

function get_nested_table_value(table, nested_keys)
  local value = table
  for _, key in ipairs(nested_keys) do
      if type(value) == "table" then
          value = value[key]
      else
          return nil
      end
  end
  return value
end

function set_nested_table_value(table, nested_keys, value,allow_overwriting_tables)
  local current_table = table
  for i, key in ipairs(nested_keys) do
      if i == #nested_keys then
          if type(current_table[key]) == "table" and not allow_overwriting_tables then
            error('cant set value of '..key..' because it may result in big data loss')
            return
          end
          current_table[key] = value
      else
          if not current_table[key] then
              current_table[key] = {}
          end
          current_table = current_table[key]
      end
  end
end