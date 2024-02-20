
local function overlapping_elipse(object,x,y)
    local rad_x = object.width/2
    local rad_y = object.height/2
    local center_x = object.x+rad_x
    local center_y = object.y+rad_y
    if (rad_x == 0 or rad_y == 0) then
        return false
    end
    local axis_1 = ((x - center_x)*(x - center_x))/(rad_x*rad_x)
    local axis_2 = ((y - center_y)*(y - center_y))/(rad_y*rad_y)
    if (axis_1 + axis_2) <= 1.0 then
        return true
    else
        return false
    end
end

local function overlapping_rectangle(object,x,y)
    local obj_x = object.x
    local obj_y = object.y
    local obj_w = object.width
    local obj_h = object.height
    local inside_aabb = x >= obj_x
        and y >= obj_y
        and x <= obj_x + obj_w
        and y <= obj_y + obj_h
    return inside_aabb
end

local overlapping_colliders = {}

Net:on("player_move", function(event)
    local player_area = Net.get_player_area(event.player_id)
    local triggers = NetCached.get_cached_objects_by_class(player_area,'collider_trigger')
    if not overlapping_colliders[player_area] then
        --init area colliders
        overlapping_colliders[player_area] = {}
    end
    for key, object in pairs(triggers) do
        local on_enter = object.custom_properties.on_player_enters_collider
        local on_exit = object.custom_properties.on_player_exits_collider
        local on_move = object.custom_properties.on_player_movement_within_collider
        --return early if this collider has no data, or no way to handle collisions
        if not object.data or not (on_enter or on_exit or on_move)then
            error('Collider has no data',object)
            goto continue
        end
        if not overlapping_colliders[player_area][object.id] then
            --init object overlaps
            overlapping_colliders[player_area][object.id] = {}
        end
        local existing_overlaps = overlapping_colliders[player_area][object.id]
        local overlapping = false
        if object.z == event.z then
            if object.data.type == "ellipse" then
                overlapping = overlapping_elipse(object,event.x,event.y)
            elseif object.data.type == "rect" then
                overlapping = overlapping_rectangle(object,event.x,event.y)
            end
        end

        local crossed_boundary = false
        if overlapping then
            if not existing_overlaps[event.player_id] then
                --player has entered collider
                crossed_boundary = true
                existing_overlaps[event.player_id] = true
            end
        else
            if existing_overlaps[event.player_id] then
                --player has left collider
                crossed_boundary = true
                existing_overlaps[event.player_id] = nil
            end
        end

        local target_id
        if crossed_boundary and overlapping and on_enter then
            target_id = on_enter
        elseif crossed_boundary and not overlapping and on_exit then
            target_id = on_exit
        elseif overlapping and on_move then
            target_id = on_move
        else
            --we dont care if no event is set up
            goto continue
        end
        local context = {
            area_id = player_area,
            player_id = event.player_id
        }
        netflow(object,context,target_id)
        :: continue :: --defining a label
    end
end)

return {
    global_object = '',
    description = 'triggers when a player enters the collider',
    handlers = {
        [1]={
            name='on_player_enters_collider',
            type='object',
        },
        [2]={
            name='on_player_exits_collider',
            type='object',
        },
        [3]={
            name='on_player_movement_within_collider',
            type='object',
        }
    }
}