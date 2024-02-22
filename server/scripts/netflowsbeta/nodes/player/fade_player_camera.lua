return {
    global_object = 'Net',
    description = 'fade camera to color for player',
    arguments = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='color',
            type='object',
            copy_from_target_class='color_details'
        },
        [3]={
            name='durationInSeconds',
            type='float'
        }
    }
}