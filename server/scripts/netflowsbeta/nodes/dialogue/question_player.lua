return {
    global_object = 'Async',
    description = 'Send a question to player, _next after answer',
    return_value = {
        name='question_answer',
        type='int'
    },
    arguments = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='question',
            type='string'
        },
        [3]={
            name='mug_texture_path',
            type='string',
            default=''
        },
        [4]={
            name='mug_animation_path',
            type='string',
            default=''
        },
    },
    handlers = {
        [1]={
            name='on_yes',
            type='object',
            setup = function(current_node,context)
                if context.question_answer == 1 then
                    local next_node_id = current_node.custom_properties.on_yes
                    return netflow(current_node,context,next_node_id)
                end
            end
        },
        [2]={
            name='on_no',
            type='object',
            setup = function(current_node,context)
                if context.question_answer == 0 then
                    local next_node_id = current_node.custom_properties.on_no
                    return netflow(current_node,context,next_node_id)
                end
            end
        },
    }
}