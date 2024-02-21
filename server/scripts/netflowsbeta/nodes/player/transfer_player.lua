return {
    global_object = 'Net',
    description = 'Transfer player to a location on a map',
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
            optional=true
        },
        [5]={
            name='y',
            type='float',
            optional=true
        },
        [6]={
            name='z',
            type='float',
            optional=true
        },
        [7]={
            name='direction',
            type='string',
            propertyType='Direction',
            default="Down",
            custom_property="Direction",
            optional=true
        },
        [8]={
            name='target_object_id',
            type='int',
            copy_from_target='transfer_details',
            use_area_id = true
        }
    }
}