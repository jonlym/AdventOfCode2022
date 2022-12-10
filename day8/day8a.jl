function main()
    cd(@__DIR__);
    filename = "day8.txt"
    tree_map = get_tree_map(filename);
    n_trees_visible = 0;
    n_rows, n_cols = size(tree_map)
    for i in 1:n_rows
        for j in 1:n_cols
            if check_if_visible(tree_map, i, j)
                n_trees_visible += 1
            end
        end
    end
    println(n_trees_visible);
end

function get_tree_map(filename::String)
    f_ptr = open(filename, "r");
    tree_map_str = readlines(f_ptr);
    close(f_ptr);

    tree_map = zeros(Int64, length(tree_map_str), length(tree_map_str[1]));
    for (i, row) in enumerate(tree_map_str)
        tree_map[i, :] = [parse(Int64, tree_height) for tree_height in row];
    end
    return tree_map
end

function check_if_visible(tree_map, row, col)
    if check_if_edge(tree_map, row, col)
        return true;
    end

    if check_if_visible_from_left(tree_map, row, col)
        return true;
    end

    if check_if_visible_from_right(tree_map, row, col)
        return true;
    end

    if check_if_visible_from_top(tree_map, row, col)
        return true;
    end

    if check_if_visible_from_bottom(tree_map, row, col)
        return true;
    end

    return false;
end

function check_if_edge(tree_map, row, col)
    if row == 1
        return true
    end

    if row == size(tree_map)[1]
        return true
    end

    if col == 1
        return true
    end

    if col == size(tree_map)[2]
        return true
    end

    return false;
end

function check_if_visible_from_left(tree_map, row, col)
    all(tree_map[1:row-1, col] .< tree_map[row, col])
end

function check_if_visible_from_right(tree_map, row, col)
    all(tree_map[row+1:end, col] .< tree_map[row, col])
end

function check_if_visible_from_top(tree_map, row, col)
    all(tree_map[row, 1:col-1] .< tree_map[row, col])
end

function check_if_visible_from_bottom(tree_map, row, col)
    all(tree_map[row, col+1:end] .< tree_map[row, col])
end

main();