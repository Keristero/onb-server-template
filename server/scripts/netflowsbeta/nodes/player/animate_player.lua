return {
    global_object = 'Net',
    description = 'Animate player, does not wait for the animation to end.',
    arguments = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='state_name',
            type='string'
        },
        [3]={
            name='loop',
            type='bool',
            optional=true
        }
    }
}