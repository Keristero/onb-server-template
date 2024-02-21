local memory_store = {}

local json = require('scripts/netflowsbeta/libs/json')

--config
local json_path = 'netflows_memory.json'
local backup_json_path = 'netflows_memory_backup.json'
local settings = {
    write_to_disk_cooldown_seconds = 1,--dont write to disk any more frequently than this
}

--state
local last_write_time = 0

local data

memory_store.initialize = function()
    return async(function ()
        pcall(function()
            data = json.decode(await(Async.read_file(json_path)))
            return
        end)
        pcall(function()
            data = json.decode(await(Async.read_file(backup_json_path)))
            return
        end)
        if not data then
            data = {}
        end
    end)
end

local function write_to_disk()
    return async(function ()
        local json = json.encode(data)
        await(Async.write_file(backup_json_path,json))
        await(Async.write_file(json_path,json))
    end)
end

memory_store.get_value = function (keys)
    return get_nested_table_value(data,keys)
end

memory_store.set_value = function (keys,value)
    set_nested_table_value(data,keys,value)
    
    local should_write_to_disk = true
    local current_time = os.time()
    if last_write_time > 0 then
        local seconds_passed = os.difftime(current_time, last_write_time)
        if seconds_passed < settings.write_to_disk_cooldown_seconds then
            should_write_to_disk = false
        end
    end
    if should_write_to_disk then
        write_to_disk()
        --maybe we should wait till the write is finished before setting?
        last_write_time = current_time
    end
end

return memory_store