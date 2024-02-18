local colors = {
    none = '\27[0m',
    red = '\27[31m',
    green = '\27[32m',
    yellow = '\27[33m',
    blue = '\27[34m',
    magenta = '\27[35m',
    cyan = '\27[36m'
}

return {
    global_object = 'table',
    description = 'specify an object type parameter, its values will be added to the context, you can also specify new name mappings for each unpacked value. the original table will be removed from the context.',
    override_func = function (node,context)
        if context.parameter_name and context[context.parameter_name] then
            for key, value in pairs(context[context.parameter_name]) do
                local out_name = key
                if node.custom_properties[key] then
                    out_name = node.custom_properties[key]
                end
                context[out_name] = value
            end
            context[context.parameter_name] = nil
        end
    end,
    arguments = {
        [1]={
            name='parameter_name',
            type='string'
        }
    }
}