return {
    global_object = 'Net',
    description = 'map some variable names to new names, the key should be the current name, and the value should be the new name',
    override_func = function (node,context)
        local temporary_values = {}
        for key, value in pairs(node.custom_properties) do
            if context[key] and key ~= '_next' then
                temporary_values[key] = {
                    new_name = node.custom_properties[key],
                    value = context[key]
                }
            end
        end
        for key, temp_info in pairs(temporary_values) do
            context[temp_info.new_name] = temp_info.value
        end
    end
}