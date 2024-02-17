

return {
    global_object = '',
    description = 'object data',
    arguments = {
        [1]={
            name='type',
            type='string',
            default='tile'
        },
        [2]={
            name='gid',
            type='int',
        },
        [3]={
            name='flipped_horizontally',
            type='boolean',
            default=false
        },
        [4]={
            name='flipped_vertically',
            type='boolean',
            default=false
        },
        [5]={
            name='rotated',
            type='boolean',
            default=false,
        }
    }
}