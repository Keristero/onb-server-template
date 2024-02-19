return {
    global_object = 'Net',
    description = 'start an encounter for a player',
    arguments = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='package_path',
            type='string'
        }
    },
    handlers = {
        [1]={
            name='data',
            type='object'
        }
    }
}