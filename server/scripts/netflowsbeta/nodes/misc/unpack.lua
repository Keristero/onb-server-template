return {
    global_object = 'Net',
    description = 'specify an table type value from the context, its values will be added to the context, you can also specify new name mappings for each unpacked value. the original table will be removed from the context.',
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