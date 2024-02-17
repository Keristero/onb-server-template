return {
    function_name = 'print',
    global_object = 'Net',
    description = 'print some values to the console',
    category = 'misc',
    override_func = function (node,context)
        local print_out = {}
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
        }
    }
}