local function toboolean(str)
    local bool = false
    if str == "true" then
        bool = true
    end
    return bool
end

Keyframe_arguments = {
    [1]={
        name='Animation',
        type='string',
        enum='EasingType',
        default_value="Linear",
        anim_conversion=tostring,
        optional=true
    },
    [2]={
        name='Animation Speed',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber,
        optional=true
    },
    [3]={
        name='X',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber,
        special_name='x',
        optional=true
    },
    [4]={
        name='Y',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber,
        special_name='y',
        optional=true
    },
    [5]={
        name='Z',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber,
        special_name='z',
        optional=true
    },
    [6]={
        name='ScaleX',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber,
        optional=true
    },
    [7]={
        name='ScaleY',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber,
        optional=true
    },
    [8]={
        name='Rotation',
        type='string',
        enum='EasingType',
        anim_conversion=tonumber,
        optional=true
    },
    [9]={
        name='Direction',
        type='string',
        enum='EasingType',
        anim_conversion=tostring,
        optional=true
    },
    [10]={
        name='Sound Effect',
        type='string',
        enum='EasingType',
        anim_conversion=tostring,
        optional=true
    },
    [11]={
        name='Sound Effect Loop',
        type='string',
        enum='EasingType',
        anim_conversion=toboolean,
        optional=true
    },
    [12]={
        name='duration',
        type='float',
        optional=true
    },
    [13]={
        name='_next_keyframe',
        type='object',
        optional=true
    },
    [14]={
        name='_keyframe_detail_values',
        type='object',
        optional=true
    }
}

return {
    global_object = '',
    description = '',
    arguments = Keyframe_arguments
}