return {
    global_object = 'Net',
    description = 'Create a bot',
    return_value = {
        name='bot_id',
        type='string'
    },
    arguments = {
        [1]={
            name='bot',
            type='object',
            copy_from_target='bot_details'
        },
    },
    handlers = {
        [1]={
            name='on_actor_interaction',
            type='object',
            setup=function (node,context)
                --remove any existing handler from context
                if context.on_actor_interaction_handler then
                    Net.remove_listener('actor_interaction',context.on_actor_interaction_handler)
                end
                context.on_actor_interaction_handler = function(event)
                    return async(function ()
                        context.player_id = event.player_id
                        context.button = event.button
                        if context.bot_id == event.actor_id then
                            local next_node_id = node.custom_properties.on_actor_interaction
                            Net:emit("bot_movement_interrupted",{bot_id=context.bot_id,interrupted=true})
                            await(netflow(node,context,next_node_id))
                            Net:emit("bot_movement_interrupted",{bot_id=context.bot_id,interrupted=false})
                        end
                    end)
                end
                --add new handler to context
                Net:on("actor_interaction", context.on_actor_interaction_handler)
            end
        }
    }
}