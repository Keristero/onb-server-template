return {
    global_object = 'Net',
    description = 'Kick player from server',
    arguments = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='reason',
            type='string',
            default=''
        },
        [3]={
            name='warp_out',
            type='boolean',
            optional=true
        }
    }
}