Net:on("custom_warp", function(event)
    local context = {
        player_id = event.player_id,
        object_id = event.object_id,
        area_id = Net.get_player_area(event.player_id),
    }
    local object = NetCached.get_object_by_id(context.area_id, event.object_id)
    if object.class ~= "Custom Warp" then
        return
    end
    if object.custom_properties.on_custom_warp == "" then
        return
    end
    local next_node_id = object.custom_properties.on_custom_warp
    return netflow(object,context,next_node_id)
end)

return {
    function_name = 'Custom Warp',
    description = 'triggers when stepped on',
    category = 'tile',
    arguments = {
        [1]={
            name='on_custom_warp',
            type='object'
        }
    }
}