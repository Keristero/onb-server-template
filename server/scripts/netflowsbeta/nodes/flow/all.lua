return {
    global_object = 'Net',
    description = 'Do all the things',
    override_func = function (node,context)
        return
    end,
    handlers = {
        [1]={
            name='_then2',
            type='object',
            setup=function(current_node,context)
                local next_node_id = current_node.custom_properties._then2
                return netflow(current_node,context,next_node_id)
            end
        },
        [2]={
            name='_then3',
            type='object',
            setup=function(current_node,context)
                local next_node_id = current_node.custom_properties._then3
                return netflow(current_node,context,next_node_id)
            end
        }
    }
}