return {
    function_name = 'remove_bot',
    global_object = 'Net',
    description = 'Remove a bot',
    category = 'bot',
    arguments = {
        [1]={
            name='bot_id',
            type='string'
        },
        [2]={
            name='warp_out',
            type='boolean',
            default=true
        },
    },
    after_execute_func = function (node,context)
        if context.on_actor_interaction_handler then
            Net:remove_listener('actor_interaction',context.on_actor_interaction_handler)
        end
    end
}