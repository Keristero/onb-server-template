Net:on("object_interaction", function(event)
    local context = {
        player_id = event.player_id,
        object_id = event.object_id,
        button = event.button,
        area_id = Net.get_player_area(event.player_id),
    }
    local object = NetCached.get_object_by_id(context.area_id, event.object_id)
    if object.class ~= "Interactable" then
        return
    end
    if object.custom_properties.on_object_interaction == "" then
        return
    end
    local next_node_id = object.custom_properties.on_object_interaction
    return netflow(object,context,next_node_id)
end)

return {
    description = 'triggers when interacted with',
    arguments = {
        [1]={
            name='on_object_interaction',
            type='object'
        }
    }
}