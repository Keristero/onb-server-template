return {
    function_name = 'move_bot',
    global_object = 'Net',
    description = 'set bot position',
    category = 'bot',
    arguments = {
        [1]={
            name='bot_id',
            type='string'
        },
        [2]={
            name='x',
            type='float'
        },
        [3]={
            name='y',
            type='float'
        },
        [4]={
            name='z',
            type='float'
        },
    }
}