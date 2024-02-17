local helpers = require('scripts/netflowsbeta/helpers')
local exporters = require('scripts/netflowsbeta/export/export')
NetCached = require('scripts/netflowsbeta/NetCached')

local classes = {}

--dynamic imports
--require all scripts from these folders

local nodes_folder_path = 'scripts/netflowsbeta/nodes/'
--folders for each category of node script
local node_script_folders = {
    'area',
    'bot',
    'data',
    'dialogue',
    'flow',
    'misc',
    'player',
    'tile',
    'trigger',
    'object'
}
--actually require the scripts
for index, category_folder in ipairs(node_script_folders) do
    local files = listFilesByType(nodes_folder_path..category_folder,'lua')
    for index, file_name in ipairs(files) do
        local script_name = getFirstPart(file_name)
        local class_definition = require(nodes_folder_path..category_folder..'/'..script_name)
        --set the category and function name, from the folder and filename
        class_definition.category = category_folder
        class_definition.function_name = script_name
        classes[script_name] = class_definition
    end
end

NetCached.cache_supported_classes(classes)

--export tiled map editor type definitions
local category_colors = exporters.export_tiled_types(classes,'server.tiled-project')
exporters.export_readme(classes,'readme.md',category_colors)

function copy_mapped_keys_to_target(target,object,definition)
    for arg_index, argument_docs in pairs(definition.arguments) do
        local arg_name = argument_docs.name
        local property_name = argument_docs.property or arg_name
        local custom_property_name = argument_docs.custom_property_name or arg_name
        local defined_custom_property = object.custom_properties[custom_property_name]
        if defined_custom_property then
            target[arg_name] = defined_custom_property
        end
        local defined_property = object[property_name]
        if defined_property then
            target[arg_name] = defined_property
        end
    end
end

function load_context(object,context,definition)
    if not definition.arguments then
        return
    end
    copy_mapped_keys_to_target(context,object,definition)
    local target_object_id = object.custom_properties._target_object
    if target_object_id then
        local target_object = NetCached.get_object_by_id(context.area_id,target_object_id)
        copy_mapped_keys_to_target(context,target_object,definition)
    end
    --copy any values that we need to copy from other objects
    for key, argument in pairs(definition.arguments) do
        if argument.copy_from_target then
            local sub_definition = classes[argument.copy_from_target]
            local target_object_id = context[argument.name]
            if target_object_id then
                local target_object = NetCached.get_object_by_id(context.area_id,target_object_id)
                copy_mapped_keys_to_target(context,target_object,sub_definition)
            end
        end
    end
end

function copy_arguments_from_context(context,arguments,ignore_missing,use_real_names)
    local arg_table = {}
    if arguments == nil then
        return arg_table
    end
    for index, _ in ipairs(arguments) do
        local argument_docs = arguments[index]
        if not argument_docs.copy_from_target then
            local value = context[argument_docs.name]
            if argument_docs.type == "float" or argument_docs.type == "int" then
                value = tonumber(value)
            end
            if not value then
                if argument_docs.default == nil and not ignore_missing then
                    error('mandatory argument missing ('..argument_docs.name..')!')
                end
                value = argument_docs.default
            end
            if use_real_names then
                arg_table[argument_docs.name] = value
            else
                table.insert(arg_table,value)
            end
        else
            local sub_definition = classes[argument_docs.copy_from_target]
            table.insert(arg_table,copy_arguments_from_context(context,sub_definition.arguments,true,true))
        end
    end
    return arg_table
end

function execute_action(object,context,definition)
    return async(function ()
        load_context(object,context,definition)
        local args = copy_arguments_from_context(context,definition.arguments)
        local target_function = _ENV[definition.global_object][definition.function_name]
        local result
        if definition.global_object == "Async" then
            if definition.override_func then
                result = await(definition.override_func(object,context))
            else
                result = await(target_function(table.unpack(args)))
            end
        else
            if definition.override_func then
                result = definition.override_func(object,context)
            else
                result = target_function(table.unpack(args))
            end
        end
        if definition.return_value then
            context[definition.return_value.name] = result
        end
    end)
end

function netflow(previous_node,context,node_id)
    return async(function ()
        --first make a new context object, so that we dont run into weird issues
        local new_context = {}
        for key, value in pairs(context) do
            new_context[key] = value
        end
        --do the before action, if it exists
        local before_node_id = previous_node.custom_properties._before
        if before_node_id then
            --find the node
            local before_node = NetCached.get_object_by_id(new_context.area_id, before_node_id)
            --find a function for it
            local function_definition = classes[before_node.class]
            if function_definition then
                --run the function
                await(execute_action(before_node,new_context,function_definition))
            end
        end
        --do the next action
        local current_node_id = node_id or previous_node.custom_properties._then
        if not current_node_id then
            --no node to flow to
            return
        end
        --find the node
        local current_node = NetCached.get_object_by_id(new_context.area_id, current_node_id)
        if not current_node then
            return
        end
        --find a function for it
        local function_definition = classes[current_node.class]
        if function_definition then
            --run the function
            await(execute_action(current_node,new_context,function_definition))
        end
        --always run this if it is present
        if function_definition.after_execute_func then
            function_definition.after_execute_func(current_node,new_context)
        end
        --initialize the handlers
        if function_definition.handlers then
            for key, handler in pairs(function_definition.handlers) do
                if handler.setup then
                    handler.setup(current_node,new_context)
                end
            end
        end

        return netflow(current_node,new_context)
    end)
end

--on load
local areas = Net.list_areas()
for _, area_id in ipairs(areas) do
    local triggers = NetCached.get_cached_objects_by_class(area_id,'on_start')
    for key, object in pairs(triggers) do
        local context = {
            area_id = area_id,
        }
        netflow(object,context)
    end
end