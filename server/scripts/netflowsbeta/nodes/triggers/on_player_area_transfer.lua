Net:on("player_area_transfer", function(event)
    local player_area = Net.get_player_area(event.player_id)
    local triggers = NetCached.get_cached_objects_by_class(player_area,'on_player_area_transfer')
    for key, object in pairs(triggers) do
        local context = {
            player_id = event.player_id,
            area_id = player_area
        }
        local next_node_id = object.custom_properties.on_player_area_transfer
        netflow(object,context,next_node_id)
    end
end)

return {
    function_name = 'on_player_area_transfer',
    global_object = '',
    description = 'triggers when a player transfers area',
    category = 'trigger',
    handlers = {
        [1]={
            name='on_player_area_transfer',
            type='object'
        }
    }
}