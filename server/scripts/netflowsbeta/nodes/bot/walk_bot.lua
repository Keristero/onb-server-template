return {
    function_name = 'walk_bot',
    global_object = 'Async',
    description = 'walk bot to location',
    category = 'bot',
    override_func = function (node,context)
        return async(function ()
            local wait_time = 0.05
            local placeholder_speed = 1.5
            while true do
                local bot_pos = Net.get_bot_position(context.bot_id)
                local distance = math.sqrt((context.x - bot_pos.x) ^ 2 + (context.y - bot_pos.y) ^ 2)
                if distance == 0 then
                    return
                end
                local angle = math.atan(node.y - bot_pos.y, node.x - bot_pos.x)
                local vel_x = math.cos(angle) * placeholder_speed
                local vel_y = math.sin(angle) * placeholder_speed
                local new_pos = {
                    x=bot_pos.x + vel_x * wait_time,
                    y=bot_pos.y + vel_y * wait_time,
                    z=bot_pos.z
                }
                if distance <= placeholder_speed * wait_time then
                    new_pos.x = node.x
                    new_pos.y = node.y
                end
                Net.move_bot(context.bot_id, new_pos.x, new_pos.y, new_pos.z)
                await(Async.sleep(wait_time))
            end
        end)
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