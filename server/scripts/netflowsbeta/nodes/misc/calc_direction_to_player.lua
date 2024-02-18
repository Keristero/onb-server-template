return {
    global_object = 'Net',
    description = 'gets the current direction from a bot to a player',
    override_func = function (node,context)
        local bot_pos = Net.get_bot_position(context.bot_id)
        local player_pos = Net.get_player_position(context.player_id)
        local direction = Direction.from_points(bot_pos, player_pos)
        return direction
    end,
    arguments = {
        [1]={
            name='bot_id',
            type='string'
        },
        [2]={
            name='player_id',
            type='string'
        }
    }
}