local json = require('scripts/netflowsbeta/libs/json')
local table_gen = require('scripts/netflowsbeta/libs/table_gen')

local distinct_colors = {'#e6194B', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#42d4f4', '#f032e6', '#bfef45', '#fabed4', '#469990', '#dcbeff', '#9A6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#a9a9a9', '#ffffff', '#000000'}

local category_colors = {
    area='#ffe119',
    trigger='#e6194B',
    misc='#f032e6',
    flow='#f58231',
    bot='#42d4f4',
    player='#3cb44b',
    dialogue='#d4c9ba',
    data='#000075',
    object='#aaffc3',
    storage='#800000',
    tile='#911eb4'
}


local hardcoded_enums = {
    {
        name='Direction',
        storageType='string',
        type='enum',
        values={
            "Left",
            "Right",
            "Up",
            "Down",
            "Up Left",
            "Up Right",
            "Down Left",
            "Down Right"
        },
        valuesAsFlags=false
    },
    {
        name='console_color',
        storageType='string',
        type='enum',
        values={
            "red",
            "green",
            "yellow",
            "blue",
            "magenta",
            "cyan"
        },
        valuesAsFlags=false
    },
    {
        name='EasingType',
        storageType='string',
        type='enum',
        values={
            "Linear",
            "In",
            "Out",
            "InOut",
            "Floor"
        },
        valuesAsFlags=false
    },
    {
        name='Emotion',
        storageType='int',
        type='enum',
        values={
            "normal",
            "full_synchro",
            "angry",
            "evil",
            "anxious",
            "tired",
            "exhausted",
            "pinch",
            "focus",
            "happy"
        },
        valuesAsFlags=false
    }
}

local exporters = {}

local readme_layout = {
    [1]={
        read_from_file="./scripts/netflowsbeta/readme_template/readme_header.md"
    },
    [2]={
        nodes_of_category="area",
        short_description='nodes that affect the map'
    },
    [3]={
        nodes_of_category="bot",
        short_description='bot nodes'
    },
    [4]={
        nodes_of_category='data',
        short_description='data storage nodes, often referenced by other nodes - not for use in flows'
    },
    [5]={
        nodes_of_category="dialogue",
        short_description='dialogue related nodes'
    },
    [6]={
        nodes_of_category="flow",
        short_description='flow control nodes'
    },
    [7]={
        nodes_of_category="misc",
        short_description='various other nodes, for debugging etc'
    },
    [8]={
        nodes_of_category="player",
        short_description='player related nodes'
    },
    [9]={
        nodes_of_category="storage",
        short_description='use the data store and save/load context variables'
    },
    [10]={
        nodes_of_category="tile",
        short_description='nodes that the player actually interacts with on the map, all other types are removed from the map on boot.'
    },
    [11]={
        nodes_of_category="trigger",
        short_description='used for beginning flows from server events'
    },
    [12]={
        nodes_of_category="object",
        short_description='interacting with objects'
    }
}

function update_tiled_project(tiled_project_path, tiled_types)
    return async(function ()
        local project_json = await(Async.read_file(tiled_project_path))
        local project = json.decode(project_json)
        project.enums = tiled_types
        await(Async.write_file(tiled_project_path,json.encode(project)))
    end)
end

function update_property_types_json(property_types_path, tiled_types)
    return async(function ()
        await(Async.write_file(property_types_path,json.encode(tiled_types)))
    end)
end

local function document_parameters(collection)
    local parameters = ''
    if collection then
        parameters = parameters..'<pre>'
        for i, arg in ipairs(collection) do
            local arg_text = arg.name
            if arg.list == true then
                arg_text = arg_text.."[]"
            end
            if arg.optional == true then
                arg_text = arg_text.."?"
            end
            if arg.copy_from_target_class then
                arg_text = arg_text.." ["..arg.copy_from_target_class.."](#"..arg.copy_from_target_class..")"
            end
            parameters = parameters..arg_text..'<br>'
        end
        parameters = parameters..'</pre>'
    end
    return parameters
end

local function document_return(return_doc)
    local parameters = ''
    if return_doc then
        parameters = parameters..'<pre>'
        parameters = parameters..return_doc.name..'<br>'
        parameters = parameters..'</pre>'
    end
    return parameters
end

exporters.export_readme = function(nodes,readme_path)
    return async(function ()
        local txt = ""
        --sort node by category
        local category = {}
        for key, node in pairs(nodes) do
            if not category[node.category] then
                category[node.category] = {}
            end
            category[node.category][key] = node
        end
        for i, section in ipairs(readme_layout) do
            if section.read_from_file then
                local section_text = await(Async.read_file(section.read_from_file))
                txt = txt..section_text..'\n'
            end
            if section.nodes_of_category then
                local section_text = '## $${\\color{'..category_colors[section.nodes_of_category]..'}'..section.nodes_of_category..'}$$\n'
                --now generate a table, for example:
                local headings = {"class", "description", "arguments", "handlers","output"}
                local rows = {}
                
                section_text = section_text..''..section.short_description..'\n\n'

                for name, node_def in pairs(category[section.nodes_of_category]) do
                    local name = node_def.function_name..'<a id="'..node_def.function_name..'"></a>'
                    local row = {name,node_def.description,document_parameters(node_def.arguments),document_parameters(node_def.handlers),document_return(node_def.return_value)}
                    table.insert(rows,row)
                end

                local table_string = table_gen(rows, headings, {
                    style = "Markdown (Github)"
                })
                section_text = section_text..table_string..'\n'

                txt = txt.. section_text..'\n'
            end
        end
        await(Async.write_file(readme_path,txt))
    end)
end

exporters.export_tiled_types = function(nodes,property_types_path,project_path)
    local output = {}
    local id_index = 1
    --add enums first
    for key, enum in pairs(hardcoded_enums) do
        enum.id = id_index
        id_index = id_index + 1
        table.insert(output,enum)
    end
    --now add classes
    for key, doc in pairs(nodes) do
        local new_type = {
            color='#FFFFFF',
            drawFill=true,
            id=id_index,
            name=doc.function_name,
            type='class',
            useAs={'object','project'},
            members={}
        }
        --pick a color
        new_type.color = category_colors[doc.category]

        --add member for all categories, except data
        if doc.category ~= "data" then
            local new_arg = {
                name='_then',
                type='object'
            }
            table.insert(new_type.members,new_arg)
        end

        --populate members
        if doc.arguments then
            for index, arg_doc in ipairs(doc.arguments) do
                local new_arg = {
                    name=arg_doc.name,
                    type=arg_doc.type,
                    value=arg_doc.default
                }
                if arg_doc.enum then
                    new_arg.propertyType = arg_doc.enum--name for enum in tiled
                end
                table.insert(new_type.members,new_arg)
            end
        end

        --add handlers
        if doc.handlers then
            for index, handler_doc in ipairs(doc.handlers) do
                local new_arg = {
                    name=handler_doc.name,
                    type=handler_doc.type,
                    value=handler_doc.default
                }
                if handler_doc.enum then
                    new_arg.enum = handler_doc.enum
                end
                table.insert(new_type.members,new_arg)
            end
        end

        id_index = id_index + 1
        table.insert(output,new_type)
    end
    return async(function ()
        await(update_property_types_json(property_types_path,output))
        await(update_tiled_project(project_path,output))
    end)
end

return exporters