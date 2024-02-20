local function try_add_property(keyframe_details,keyframe_detail_values_object,description,output)
    local anim_property = {
        property=description.name
    }
    if keyframe_details[description.name] then
        anim_property.ease = keyframe_details[description.name]
    end
    local val
    if description.special_name then
        val = keyframe_detail_values_object[description.special_name]
    end
    if keyframe_detail_values_object.custom_properties[description.name] then
        val = keyframe_detail_values_object.custom_properties[description.name]
    end
    if val then
        anim_property.value = description.anim_conversion(val)
    end
    if anim_property.ease ~= nil and anim_property.value ~= nil then
        table.insert(output,anim_property)
    end
end

return {
    global_object = 'Net',
    description = 'Animate bot, does not wait for the animation to end',
    override_func = function (node,context)
        local keyframes = {}
        local animation_compliled = false
        local next_keyframe_id = node.custom_properties.first_keyframe_details
        local total_duration = 0
        while animation_compliled == false do
            if not next_keyframe_id then
                animation_compliled = true
                goto continue
            end
            local keyframe_details = NetCached.get_object_by_id(context.area_id,next_keyframe_id)
            local keyframe_details_values = NetCached.get_object_by_id(context.area_id,keyframe_details.custom_properties._keyframe_detail_values)
            local properties = {}
            for index, arg in pairs(Keyframe_detail_handlers) do
                if arg.anim_conversion ~= nil then
                    try_add_property(keyframe_details.custom_properties,keyframe_details_values,arg,properties)
                end
            end
            local keyframe = {
                properties=properties,
                duration=tonumber(keyframe_details.custom_properties.duration)
            }
            table.insert(keyframes,keyframe)
            total_duration = total_duration + keyframe.duration
            next_keyframe_id = keyframe_details.custom_properties._next_keyframe
            ::continue::
        end
        Net.animate_bot_properties(context.bot_id, keyframes)
        async(function ()
            await(Async.sleep(math.max(total_duration-0.1,0)))
            local next_node_id = node.custom_properties.on_animation_duration_elapsed
            return netflow(node,context,next_node_id)
        end)
    end,
    arguments = {
        [1]={
            name='bot_id',
            type='string'
        }
    },
    handlers = {
        [1]={
            name='first_keyframe_details',
            type='object'
        },
        [2]={
            name='on_animation_duration_elapsed',
            type='object'
        },
    }
}