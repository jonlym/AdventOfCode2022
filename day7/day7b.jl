include("./FileDirectoryTypes.jl")
using .FileDirectoryTypes

root_folder = Folder("/", Dict(), Dict(), nothing);


function main()
    cd(@__DIR__);
    build_file_system();
    print_file_tree(root_folder);

    total_space = 70000000;
    used_space = get_folder_size(root_folder);
    space_required = 30000000;
    free_space = total_space - used_space;
    min_folder_size = space_required - free_space;

    target_folder = get_first_largest_folder(min_folder_size);
    println(get_folder_size(target_folder));
end

function build_file_system()
    current_folder = root_folder;

    f_ptr = open("day7.txt", "r");
    while !eof(f_ptr)
        line = readline(f_ptr);

        is_list_requested = check_if_list_requested(line);
        if is_list_requested
            # Move to next line
            continue
        end

        is_folder_changed = check_if_folder_changed(line);
        if is_folder_changed
            folder_name = get_folder_name(line);
            current_folder = change_current_folder(current_folder, folder_name);
            continue
        end

        is_folder = check_if_folder(line);
        if is_folder
            folder_name = get_folder_name(line);
            folder_exists = check_if_folder_exists(current_folder, folder_name);
            if !folder_exists
                new_folder = Folder(folder_name, Dict(), Dict(), current_folder);
                add_child_folder!(current_folder, new_folder);            
            end
            continue
        end

        # Otherwise, the line is a file
        name, size = parse_file_line(line);
        new_file = File(name, size);
        add_file!(current_folder, new_file);
    end
    close(f_ptr);
end


function check_if_command(line)
    return line[1] == '$';
end

function check_if_list_requested(line)
    return occursin("\$ ls", line);
end

function check_if_folder_changed(line)
    return occursin("\$ cd", line)
end

function check_if_folder(line)
    return startswith(line, "dir");
end

function get_folder_name(line)
    return split(line, " ")[end]
end

function check_if_folder_exists(parent_folder, child_folder_name)
    return haskey(parent_folder.child_folders, child_folder_name);
end


function get_child_folder(parent_folder, child_folder_name)
    return parent_folder.child_folders[child_folder_name];
end

function add_child_folder!(parent_folder, child_folder)
    parent_folder.child_folders[child_folder.name] = child_folder;
end

function change_current_folder(current_folder, folder_name)
    if folder_name == ".."
        return current_folder.parent_folder;
    end

    if folder_name == "/"
        return root_folder;
    end

    folder_exists = check_if_folder_exists(current_folder, folder_name);
    if folder_exists
        return get_child_folder(current_folder, folder_name);
    end

    new_folder = Folder(folder_name, Set(), Set(), current_folder);
    add_child_folder!(parent_folder, new_folder);
    return new_folder;
end

function parse_file_line(line)
    size_str, name = split(line, " ");
    size = parse(Int64, size_str);
    return (name, size);
end

function add_file!(parent_folder, file)
    parent_folder.files[file.name] = file;
end

function get_folder_size(folder)
    size = 0;
    for file in values(folder.files)
        size += file.size
    end
    for child_folder in values(folder.child_folders)
        size += get_folder_size(child_folder);
    end
    return size;
end


function print_file_tree(folder, level=0)
    println(repeat("  ", level), "- ", folder.name, " (dir, size=", get_folder_size(folder), ")");
    for file in values(folder.files)
        println(repeat("  ", level + 1), "- ", file.name, " (file, size=", file.size, ")");
    end
    for child_folder in values(folder.child_folders)
        print_file_tree(child_folder, level+1);
    end
end

function calc_prompt_size()
    max_folder_size = 100000;
    folders = get_small_folders(root_folder, max_folder_size);
    total_size = sum([get_folder_size(folder) for folder in folders]);
    return total_size;
end

function get_small_folders(folder, max_folder_size)
    folders_out = [];
    for child_folder in values(folder.child_folders)
        folders_out = vcat(folders_out, get_small_folders(child_folder, max_folder_size));
        if get_folder_size(child_folder) <= max_folder_size
            push!(folders_out, child_folder);
        end
    end
    return folders_out;
end

function get_large_folders(folder, min_folder_size)
    folders_out = [];
    for child_folder in values(folder.child_folders)
        folders_out = vcat(folders_out, get_large_folders(child_folder, min_folder_size));
        if get_folder_size(child_folder) >= min_folder_size
            push!(folders_out, child_folder);
        end
    end
    return folders_out;
end


function get_first_largest_folder(min_folder_size)
    folders = get_large_folders(root_folder, min_folder_size);
    min_i = argmin([get_folder_size(folder) for folder in folders]);
    return folders[min_i];
end

main();
