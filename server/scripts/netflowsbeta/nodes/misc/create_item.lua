return {
    global_object = 'Net',
    description = 'create an item',
    arguments = {
        [1]={
            name='item_id',
            type='string'
        },
        [2]={
            name='item_details',
            type='object',
            list=true,
            copy_from_target_class='item_details'
        }
    }
}