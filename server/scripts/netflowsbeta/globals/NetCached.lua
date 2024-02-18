local NetCached = {
    cache={},
    classes={}
}

--cache all the classes supported by netflows on server start
function NetCached.cache_supported_classes(classes)
    local areas = Net.list_areas()
    for i, area_id in pairs(areas) do
        local objects = Net.list_objects(area_id)
        for index, object_id in pairs(objects) do
            object_id = tostring(object_id)
            local object = Net.get_object_by_id(area_id, object_id)
            local class_definition = classes[object.class]
            if class_definition then
                if class_definition.category ~= 'tile' then
                    --add to the area cache
                    if not NetCached.cache[area_id] then
                        NetCached.cache[area_id] = {}
                    end
                    NetCached.cache[area_id][object_id] = object
                    --add to the class cache
                    if not NetCached.classes[object.class] then
                        NetCached.classes[object.class] = {}
                    end
                    local areas = NetCached.classes[object.class]
                    --add to object's area
                    if not areas[area_id] then
                        areas[area_id] = {}
                    end
                    areas[area_id][object_id] = object
                    --remove from map
                    Net.remove_object(area_id, object_id)
                end
            end
        end
    end
end

function NetCached.get_cached_objects_by_class(area_id,class_name)
    --gets all the objects for the target area
    area_id = tostring(area_id)
    class_name = tostring(class_name)
    if not NetCached.classes[class_name] then
        NetCached.classes[class_name] = {}
    end
    local areas = NetCached.classes[class_name]
    if not areas[area_id] then
        areas[area_id] = {}
    end
    return areas[area_id]
end

function NetCached.get_object_by_id(area_id, object_id)
    area_id = tostring(area_id)
    object_id = tostring(object_id)
    --same as Net.get_object_by_id except it uses objects from a cache and caches them if they are not already cached
    if not NetCached.cache[area_id] then
        return nil
    end
    if NetCached.cache[area_id][object_id] then
        return NetCached.cache[area_id][object_id]
    else
        return Net.get_object_by_id(area_id, object_id)
    end
end
return NetCached