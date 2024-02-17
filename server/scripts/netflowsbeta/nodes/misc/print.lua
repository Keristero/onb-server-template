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
    function_name = 'print',
    global_object = 'Net',
    description = 'print some values to the console, you can set the color too',
    category = 'misc',
    override_func = function (node,context)
        local print_out = {}
        table.insert(print_out,colors[context.console_color])
        if context.print_label then
            table.insert(print_out,"\nLABEL\n")
            table.insert(print_out,context.print_label)
        end
        if context.print_node then
            table.insert(print_out,"\nNODE\n")
            table.insert(print_out,node)
        end
        if context.print_context then
            table.insert(print_out,"\nCONTEXT\n")
            table.insert(print_out,context)
        end
        table.insert(print_out,"\27[0m")
        print(table.unpack(print_out))
    end,
    arguments = {
        [1]={
            name='print_label',
            type='string',
            default=''
        },
        [2]={
            name='print_context',
            type='boolean',
            default=false
        },
        [3]={
            name='print_node',
            type='boolean',
            default=false
        },
        [4]={
            name='console_color',
            type='string',
            propertyType='console_color',
            default="yellow"
        }
    }
}