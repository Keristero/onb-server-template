return {
    global_object = 'Net',
    description = 'details for transfer_player',
    arguments = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='area_id',
            type='string'
        },
        [3]={
            name='warp_in',
            type='boolean',
            default=true
        },
        [4]={
            name='x',
            type='float',
            default=0
        },
        [5]={
            name='y',
            type='float',
            default=0
        },
        [6]={
            name='z',
            type='float',
            default=0
        },
        [7]={
            name='direction',
            type='string',
            enum='Direction',
            default="Down",
            custom_property="Direction"
        }
    }
}