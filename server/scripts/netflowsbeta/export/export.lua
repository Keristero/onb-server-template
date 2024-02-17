local json = require('scripts/netflowsbeta/export/json')
local table_gen = require('scripts/netflowsbeta/export/table_gen')

local distinct_colors = {'#e6194B', '#3cb44b', '#ffe119', '#4363d8', '#f58231', '#911eb4', '#42d4f4', '#f032e6', '#bfef45', '#fabed4', '#469990', '#dcbeff', '#9A6324', '#fffac8', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#a9a9a9', '#ffffff', '#000000'}

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
        short_description='data storage nodes, often referenced by other nodes'
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
        nodes_of_category="tile",
        short_description='nodes that the player actually interacts with on the map, all other types are removed from the map on boot.'
    },
    [10]={
        nodes_of_category="trigger",
        short_description='used for beginning flows from server events'
    }
}

function update_tiled_project(tiled_project_path, tiled_types)
    return async(function ()
        local project_json = await(Async.read_file(tiled_project_path))
        local project = json.decode(project_json)
        project.propertyTypes = tiled_types
        await(Async.write_file(tiled_project_path,json.encode(project)))
    end)
end

local function document_parameters(collection)
    local parameters = ''
    if collection then
        parameters = parameters..'<pre>'
        for i, arg in ipairs(collection) do
            local arg_text = arg.name
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

exporters.export_readme = function(nodes,readme_path,category_colors)
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
                    local row = {node_def.function_name,node_def.description,document_parameters(node_def.arguments),document_parameters(node_def.handlers),document_return(node_def.return_value)}
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

exporters.export_tiled_types = function(nodes,project_path)
    local category_colors = {}
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
        if not category_colors[doc.category] then
            category_colors[doc.category] = table.remove(distinct_colors,  1)
        end
        new_type.color = category_colors[doc.category]

        --add member for all categories
        local new_arg = {
            name='_then',
            type='object'
        }
        table.insert(new_type.members,new_arg)

        local new_arg = {
            name='_before',
            type='object'
        }
        table.insert(new_type.members,new_arg)

        --populate members
        if doc.arguments then
            for index, arg_doc in ipairs(doc.arguments) do
                local new_arg = {
                    name=arg_doc.name,
                    type=arg_doc.type,
                    value=arg_doc.default
                }
                if arg_doc.propertyType then
                    new_arg.propertyType = arg_doc.propertyType
                end
                table.insert(new_type.members,new_arg)
            end
        end

        --add handlers
        if doc.handlers then
            for index, handler_doc in ipairs(doc.handlers) do
                local new_arg = {
                    name=handler_doc.name,
                    type='object',
                }
                table.insert(new_type.members,new_arg)
            end
        end

        id_index = id_index + 1
        table.insert(output,new_type)
    end
    update_tiled_project(project_path,output)
    return category_colors
end

return exporters