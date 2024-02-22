return {
    global_object = 'Async',
    description = 'start pvp between two players',
    arguments = {
        [1]={
            name='player_1_id',
            type='string'
        },
        [2]={
            name='player_2_id',
            type='string'
        },
        [3]={
            name='field_script_path',
            type='string',
            optional=true
        }
    },
    return_value = {
        name='encounter_results',
        type='object'
    },
}