return {
    global_object = 'Net',
    description = '',
    arguments = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='emotion',
            type='int',
            enum='Emotion',
            default=0
        }
    }
}