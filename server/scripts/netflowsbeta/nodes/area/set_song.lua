return {
    function_name = 'set_song',
    global_object = 'Net',
    description = 'Set the background music for a map',
    category = 'area',
    arguments = {
        [1]={
            name='area_id',
            type='string'
        },
        [2]={
            name='song_path',
            type='string'
        }
    }
}