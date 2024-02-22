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
        local cp = node.custom_properties
        table.insert(print_out,colors[cp.console_color])
        if cp.print_label then
            table.insert(print_out,"\nLABEL\n")
            table.insert(print_out,cp.print_label)
        end
        if cp.print_parameter then
            table.insert(print_out,"\n"..cp.print_parameter.."\n")
            table.insert(print_out,cp[cp.print_parameter])
        end
        if cp.print_node then
            table.insert(print_out,"\nNODE\n")
            table.insert(print_out,node)
        end
        if cp.print_context then
            table.insert(print_out,"\nCONTEXT\n")
            table.insert(print_out,context)
        end
        table.insert(print_out,"\27[0m")
        print(table.unpack(print_out))
    end,
    handlers = {
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
            enum='console_color',
            default="yellow"
        },
        [5]={
            name='print_parameter',
            type='string'
        }
    }
}