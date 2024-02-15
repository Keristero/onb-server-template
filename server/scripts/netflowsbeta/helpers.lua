function async(p)
    local co = coroutine.create(p)
    return Async.promisify(co)
end

function await(v) return Async.await(v) end

function listFilesByType(path, fileType)
    local files = {}
    local cmd
  
    -- Check if running on Windows or Unix-like system
    if package.config:sub(1,1) == '\\' then
      -- Windows command
      cmd = 'dir "' .. path .. '\\*.' .. fileType .. '" /b'
    else
      -- Unix-like command
      cmd = 'find "' .. path .. '" -maxdepth  1 -type f -name "*.' .. fileType .. '"'
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