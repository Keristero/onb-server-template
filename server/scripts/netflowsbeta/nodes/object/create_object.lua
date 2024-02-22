return {
    global_object = 'Net',
    description = 'Create an object',
    arguments = {
        [1]={
            name='area_id',
            type='string'
        },
        [2]={
            name='object_details',
            type='object',
            copy_from_target_class='object_details'
        }
    }
}