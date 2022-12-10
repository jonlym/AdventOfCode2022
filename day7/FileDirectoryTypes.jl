module FileDirectoryTypes

export Folder, File

struct File
    name::String
    size::Int64
end

mutable struct Folder
    const name::String
    child_folders::Dict{String, Folder}
    files::Dict{String, File}
    parent_folder::Folder

    function Folder(name, child_folders=Dict(), files=Dict(),
                    parent_folder=nothing)
        if isnothing(parent_folder)
            return new(name, child_folders, files);
        else
            return new(name, child_folders, files, parent_folder)
        end
    end
end

end