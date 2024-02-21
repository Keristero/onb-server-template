return {
    global_object = 'Async',
    description = 'Quiz player, _next after answer',
    return_value = {
        name='prompt_answer',
        type='string'
    },
    arguments = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='option_a',
            type='string',
            optional=true
        },
        [3]={
            name='option_b',
            type='string',
            optional=true
        },
        [4]={
            name='option_c',
            type='string',
            optional=true
        },
        [6]={
            name='mug_texture_path',
            type='string',
            optional=true
        },
        [7]={
            name='mug_animation_path',
            type='string',
            optional=true
        },
    },
    handlers = {
        [1]={
            name='on_a',
            type='object',
            setup = function(current_node,context)
                if context.prompt_answer == 0 then
                    local next_node_id = current_node.custom_properties.on_a
                    return netflow(current_node,context,next_node_id)
                end
            end
        },
        [2]={
            name='on_b',
            type='object',
            setup = function(current_node,context)
                if context.prompt_answer == 1 then
                    local next_node_id = current_node.custom_properties.on_b
                    return netflow(current_node,context,next_node_id)
                end
            end
        },
        [3]={
            name='on_c',
            type='object',
            setup = function(current_node,context)
                if context.prompt_answer == 2 then
                    local next_node_id = current_node.custom_properties.on_c
                    return netflow(current_node,context,next_node_id)
                end
            end
        }
    }
}