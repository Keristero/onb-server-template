return {
    global_object = 'Net',
    description = 'call a function_netflow by name, it can be in any area - and there can be multiple with the same name',
    override_func = function (node,context)
        Net:emit('function_netflow_call',context)
    end,
    arguments = {
        [1]={
            name='function_name',
            type='string'
        }
    }
}