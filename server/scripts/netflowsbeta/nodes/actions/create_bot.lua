--Net.create_bot({ name?, area_id?, warp_in?, texture_path?, animation_path?, animation?, x?, y?, z?, direction?, solid? })

return {
    function_name = 'create_bot',
    global_object = 'Net',
    description = 'Create a bot',
    category = 'bot',
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
            setup = function(current_node,context)
                --remember to remove this when we remove the bot
                print('created bot, added handler',context)
                Net:on("actor_interaction", function(event)
                    context.player_id = event.player_id
                    context.button = event.button
                    print('this is the bots handler',context.bot_id)
                    if event.actor_id == context.bot_id then
                        local next_node_id = current_node.custom_properties.on_actor_interaction
                        return netflow(current_node,context,next_node_id)
                    end
                end)
            end
        },
    }
}