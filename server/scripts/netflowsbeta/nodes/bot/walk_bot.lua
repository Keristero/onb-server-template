return {
    global_object = 'Async',
    description = 'walk bot to location',
    override_func = function (node,context)
        local promise = Async.create_promise(function (resolve)
            local placeholder_speed = 1

            local movement_interrupted = false
            local start_pos = Net.get_bot_position(context.bot_id)--for tracking overall progress
            local trip_distance = math.sqrt((context.x - start_pos.x) ^ 2 + (context.y - start_pos.y) ^ 2)
            local interrupted_handler
            --set up event handlers
            interrupted_handler = function(event)
                if event.bot_id == context.bot_id then
                    movement_interrupted = event.interrupted
                end
            end
            Net:on("bot_movement_interrupted",interrupted_handler)
            local tick_handler
            tick_handler = function(event)
                if movement_interrupted then
                    return
                end
                local bot_pos = Net.get_bot_position(context.bot_id)
                local distance = math.sqrt((context.x - bot_pos.x) ^ 2 + (context.y - bot_pos.y) ^ 2)
                local distance_remaining = trip_distance-distance
                local trip_progress = distance_remaining/trip_distance
                if distance <= (placeholder_speed * event.delta_time) then
                    --snap to final position, and resolve
                    Net.move_bot(context.bot_id, context.x, context.y, context.z)
                    Net:remove_listener("tick",tick_handler)
                    Net:remove_listener("bot_movement_interrupted",interrupted_handler)
                    return resolve()
                end
                local angle = math.atan(node.y - bot_pos.y, node.x - bot_pos.x)
                local vel_x = math.cos(angle) * placeholder_speed
                local vel_y = math.sin(angle) * placeholder_speed
                local new_pos = {
                    x=bot_pos.x + vel_x * event.delta_time,
                    y=bot_pos.y + vel_y * event.delta_time,
                    z=interpolate(start_pos.z,context.z,trip_progress)
                }
                Net.move_bot(context.bot_id, new_pos.x, new_pos.y, new_pos.z)
            end
            Net:on("tick", tick_handler)
        end)
        return promise
    end,
    arguments = {
        [1]={
            name='bot_id',
            type='string'
        },
        [2]={
            name='x',
            type='float'
        },
        [3]={
            name='y',
            type='float'
        },
        [4]={
            name='z',
            type='float'
        },
    }
}