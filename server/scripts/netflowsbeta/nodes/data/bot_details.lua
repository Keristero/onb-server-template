

return {
    global_object = '',
    description = 'describes a bot',
    arguments = {
        [1]={
            name='area_id',
            type='string',
        },
        [2]={
            name='warp_in',
            type='boolean',
            default=true,
        },
        [3]={
            name='texture_path',
            type='string',
        },
        [4]={
            name='animation_path',
            type='string',
        },
        [5]={
            name='animation',
            type='string',
        },
        [6]={
            name='x',
            type='float',
            default=0,
        },
        [7]={
            name='y',
            type='float',
            default=0,
        },
        [8]={
            name='z',
            type='float',
            default=0,
        },
        [9]={
            name='direction',
            type='string',
            enum='Direction',
            default="Down Left",
            custom_property="Direction",
        },
        [10]={
            name='solid',
            type='boolean',
            default=true,
        },
        [11]={
            name='name',
            type='string'
        },
    }
}