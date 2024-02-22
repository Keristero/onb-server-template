return {
    global_object = '',
    description = '',
    handlers = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='health',
            type='int'
        },
        [3]={
            name='score',
            type='int',
        },
        [4]={
            name='time',
            type='float',
        },
        [5]={
            name='ran',
            type='bool',
        },
        [6]={
            name='emotion',
            type='int'
        },
        [7]={
            name='turns',
            type='int'
        },
        [8]={
            name='enemies',
            type='object',
            list=true,
            copy_from_target_class='enemy_details'
        }
    }
}