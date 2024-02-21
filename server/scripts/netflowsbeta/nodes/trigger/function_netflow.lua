return {
    global_object = 'Net',
    description = 'can be triggered by any call_function node with a matching function_name',
    handlers = {
        [1]={
            name='function_name',
            type='string'
        }
    },
    after_plugin_load = function ()
        local function_netflows_by_name = {}
        local areas = Net.list_areas()
        for _, area_id in ipairs(areas) do
            local triggers = NetCached.get_cached_objects_by_class(area_id,'function_netflow')
            for key, object in pairs(triggers) do
                local function_name = object.custom_properties.function_name
                object.custom_properties.__execution_area_id = area_id
                if not function_netflows_by_name[function_name] then
                    function_netflows_by_name[function_name] = {}
                end
                table.insert(function_netflows_by_name[function_name],object)
            end
        end

        Net:on("function_netflow_call", function(event)
            if not event.function_name then
                return
            end
            local triggers = function_netflows_by_name[event.function_name]
            if not triggers then
                error('no function_netflows with name '..event.function_name)
                return
            end
            for key, object in pairs(triggers) do
                netflow(object,event)
            end
        end)
    end
}