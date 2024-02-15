local helpers = require('scripts/netflowsbeta/helpers')
local export = require('scripts/netflowsbeta/export')
NetCached = require('scripts/netflowsbeta/NetCached')

local classes = {}

--dynamic imports
--require all scripts from these folders
local node_script_folders = {
    'scripts/netflowsbeta/properties',
    'scripts/netflowsbeta/nodes/actions',
    'scripts/netflowsbeta/nodes/triggers',
    'scripts/netflowsbeta/tiles'
}
--actually require the scripts
for index, folder_path in ipairs(node_script_folders) do
    local files = listFilesByType(folder_path,'lua')
    for index, file_name in ipairs(files) do
        local script_name = getFirstPart(file_name)
        local class_definition = require(folder_path..'/'..script_name)
        classes[script_name] = class_definition
    end
end

NetCached.cache_supported_classes(classes)

--export tiled map editor type definitions
export(classes,'server.tiled-project')

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
    for index, _ in ipairs(arguments) do
        local argument_docs = arguments[index]
        print('copying',argument_docs.name)
        if not argument_docs.copy_from_target then
            local value = context[argument_docs.name]
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
        print('calling global func',definition.function_name,args)
        local target_function = _ENV[definition.global_object][definition.function_name]
        local result
        if definition.global_object == "Async" then
            result = await(target_function(table.unpack(args)))
        else
            result = target_function(table.unpack(args))
        end
        if definition.return_value then
            context[definition.return_value.name] = result
        end
    end)
end

function netflow(previous_node,context,node_id)
    print('netflow',context,node_id)
    local current_node_id = node_id or previous_node.custom_properties._then
    if not current_node_id then
        --no node to flow to
        return
    end
    --find the node
    local current_node = NetCached.get_object_by_id(context.area_id, current_node_id)
    print('thenode=',current_node)
    if not current_node then
        return
    end
    --find a function for it
    local function_definition = classes[current_node.class]
    if function_definition then
        --run the function
        execute_action(current_node,context,function_definition)
    end
    --initialize the handlers
    if function_definition.handlers then
        print('woah, there are handlers',function_definition.handlers)
        for key, handler in pairs(function_definition.handlers) do
            if handler.setup then
                handler.setup(current_node,context)
            end
        end
    end

    return netflow(current_node,context)
end