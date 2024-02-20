local data_store = require('scripts/netflowsbeta/data_store')

return {
    global_object = '',
    description = 'load variable from the  data store to the context, you can load values with an alias using saved_variable_name',
    override_func = function (node,context)
        local player_secret
        local area_id
        local keys = {}
        if context.unique_to_area_id then
            area_id = context.area_id
            table.insert(keys,area_id)
        end
        if context.unique_to_player_secret then
            player_secret = Net.get_player_secret(context.player_id)
            table.insert(keys,player_secret)
        end
        if context.table_key then
            table.insert(keys,context.table_key)
        end
        if context.variable_name then
            if context.saved_variable_name then
                --use the alias if there is one
                table.insert(keys,context.saved_variable_name)
            else
                --otherwise just use the variable name
                table.insert(keys,context.variable_name)
            end
            local value = data_store.get_value(keys)
            if value ~= nil then
                context[context.variable_name] = value
            end
        else
            error('no variable name provided')
        end

    end,
    arguments = {
        [1]={
            name='unique_to_player_secret',
            type='boolean',
            default = false
        },
        [2]={
            name='unique_to_area_id',
            type='boolean',
            default = false
            
        },
        [3]={
            name='saved_variable_name',
            type='string'
        },
        [4]={
            name='variable_name',
            type='string'
        },
        [5]={
            name='table_key',
            type='string'
        }
    }
}