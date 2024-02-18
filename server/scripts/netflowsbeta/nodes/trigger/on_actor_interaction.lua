Net:on("actor_interaction", function(event)
    local player_area = Net.get_player_area(event.player_id)
    local triggers = NetCached.get_cached_objects_by_class(player_area,'actor_interaction')
    for key, object in pairs(triggers) do
        local context = {
            player_id = event.player_id,
            area_id = player_area,
            actor_id = event.actor_id,
            button = event.button
        }
        netflow(object,context)
    end
end)

return {
    function_name = 'on_actor_interaction',
    global_object = '',
    description = 'triggers when a player interacts with a actor',
    category = 'trigger'
}