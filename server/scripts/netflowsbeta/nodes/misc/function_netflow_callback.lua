return {
    global_object = 'Net',
    description = 'if this node was reached from a call_function_netflow, this node will return all the values in its context back to the _on_callback handler of the call_function_netflow',
    override_func = function (node,context)
        --copy all other custom properties from function call node
        if context.function_caller_callback then
            local callback = context.function_caller_callback
            context.function_caller_callback = nil
            return callback(context)
        end
    end
}