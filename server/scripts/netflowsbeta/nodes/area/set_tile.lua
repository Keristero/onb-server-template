return {
    global_object = 'Net',
    description = 'set a specific tile GID',
    arguments = {
        [1]={
            name='area_id',
            type='string'
        },
        [2]={
            name='x',
            type='int'
        },
        [3]={
            name='y',
            type='int'
        },
        [4]={
            name='z',
            type='int'
        },
        [5]={
            name='tile_gid',
            type='int'
        },
        [6]={
            name='flip_h',
            type='boolean'
        },
        [7]={
            name='flip_v',
            type='boolean'
        },
        [8]={
            name='rotate',
            type='boolean'
        }
    }
}