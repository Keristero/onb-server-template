return {
    global_object = 'Async',
    description = 'start an encounter for a player',
    arguments = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='package_path',
            type='string'
        },
        [3]={
            name='data',
            type='object'
        }
    }
}