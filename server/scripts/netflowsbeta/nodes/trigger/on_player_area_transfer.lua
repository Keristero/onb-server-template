Net:on("player_area_transfer", function(event)
    local player_area = Net.get_player_area(event.player_id)
    local triggers = NetCached.get_cached_objects_by_class(player_area,'on_player_area_transfer')
    for key, object in pairs(triggers) do
        local context = {
            player_id = event.player_id,
            area_id = player_area
        }
        netflow(object,context)
    end
end)

return {
    global_object = '',
    description = 'triggers when a player transfers area',
}