

return {
    global_object = '',
    description = 'describes an object',
    arguments = {
        [1]={
            name='name',
            type='string',
        },
        [2]={
            name='type',
            type='string',
        },
        [3]={
            name='visible',
            type='boolean',
        },
        [4]={
            name='x',
            type='float',
            default=0,
        },
        [5]={
            name='y',
            type='float',
            default=0,
        },
        [6]={
            name='z',
            type='float',
            default=0,
        },
        [7]={
            name='width',
            type='float',
            default=1,
        },
        [8]={
            name='height',
            type='float',
            default=1,
        },
        [9]={
            name='rotation',
            type='float',
            default=0
        },
        [10]={
            name='data',
            type='object',
            copy_from_target='data'
        },
        [11]={
            name='custom_properties',
            type='object',
            copy_from_target='custom_properties'
        },
    }
}