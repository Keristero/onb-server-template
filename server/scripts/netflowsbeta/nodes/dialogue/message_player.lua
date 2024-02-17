return {
    function_name = 'message_player',
    global_object = 'Async',
    description = 'Send a textbox to player, _next after textbox is closed',
    category = 'dialogue',
    arguments = {
        [1]={
            name='player_id',
            type='string'
        },
        [2]={
            name='message',
            type='string'
        },
        [3]={
            name='mug_texture_path',
            type='string',
            default=''
        },
        [4]={
            name='mug_animation_path',
            type='string',
            default=''
        },
    }
}