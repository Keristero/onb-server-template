return {
    global_object = 'Net',
    description = 'call a function_netflow by name, it can be in any area - and there can be multiple with the same name, as an extra convenience you can define any custom properties you want on this node and they will be added to the context',
    override_func = function (node,context)
        --copy all other custom properties from function call node
        for key, value in pairs(node.custom_properties) do
            if key ~= 'function_name' and key ~= '_then' then
                context[key] = value
            end
        end
        Net:emit('function_netflow_call',context)
    end,
    arguments = {
        [1]={
            name='function_name',
            type='string'
        }
    }
}