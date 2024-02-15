local json = require('scripts/netflowsbeta/json')

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

function update_tiled_project(tiled_project_path, tiled_types)
    return async(function ()
        local project_json = await(Async.read_file(tiled_project_path))
        local project = json.decode(project_json)
        project.propertyTypes = tiled_types
        await(Async.write_file(tiled_project_path,json.encode(project)))
    end)
end

function export_tiled_types(nodes,project_path)
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

        --populate members
        if doc.arguments then
            for index, arg_doc in ipairs(doc.arguments) do
                local new_arg = {
                    name=arg_doc.name,
                    type=arg_doc.type,
                    value=arg_doc.default or 0
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
end

return export_tiled_types