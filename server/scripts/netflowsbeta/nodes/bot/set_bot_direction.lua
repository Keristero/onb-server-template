return {
    global_object = 'Net',
    description = 'set bot position',
    arguments = {
        [1]={
            name='bot_id',
            type='string'
        },
        [2]={
            name='direction',
            type='string',
            propertyType='Direction',
            default="Down"
        }
    }
}