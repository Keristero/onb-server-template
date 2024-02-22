local function toboolean(str)
    local bool = false
    if str == "true" then
        bool = true
    end
    return bool
end

Keyframe_detail_handlers = {
    [1]={
        name='Animation',
        type='string',
        enum='EasingType',
        default_value="Linear",
        anim_conversion=tostring
    },
    [2]={
        name='Animation Speed',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber
    },
    [3]={
        name='X',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber,
        special_name='x'
    },
    [4]={
        name='Y',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber,
        special_name='y'
    },
    [5]={
        name='Z',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber,
        special_name='z'
    },
    [6]={
        name='ScaleX',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber
    },
    [7]={
        name='ScaleY',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber
    },
    [8]={
        name='Rotation',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber
    },
    [9]={
        name='Direction',
        type='string',
        enum='EasingType',
        anim_conversion=tostring
    },
    [10]={
        name='Sound Effect',
        type='string',
        enum='EasingType',
        anim_conversion=tostring
    },
    [11]={
        name='Sound Effect Loop',
        type='string',
        enum='EasingType',
        anim_conversion=toboolean
    },
    [12]={
        name='_next_keyframe',
        type='object',
    },
    [13]={
        name='_keyframe_detail_values',
        type='object',
    }
}

return {
    global_object = '',
    description = '',
    arguments = {
        [1]={
            name='duration',
            type='float'
        }
    },
    handlers = Keyframe_detail_handlers
}