return {
    global_object = 'Async',
    description = 'Prompt player for text, _next after answer',
    return_value = {
        name='prompt_answer',
        type='string'
    },
    arguments = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='character_limit',
            type='int'
        },
        [3]={
            name='default_text',
            type='string',
            default=''
        }
    }
}