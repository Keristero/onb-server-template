return {
    global_object = 'Net',
    description = 'Do all the things',
    override_func = function (node,context)
        return
    end,
    handlers = {
        [1]={
            name='next2',
            type='object',
            setup=function(current_node,context)
                local next_node_id = current_node.custom_properties.next2
                return netflow(current_node,context,next_node_id)
            end
        }
    }
}