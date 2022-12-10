function main()
    cd(@__DIR__);
    filename = "day8.txt"
    tree_map = get_tree_map(filename);
    n_trees_visible = 0;
    n_rows, n_cols = size(tree_map)
    scenic_score_map = zeros(Int64, n_rows, n_cols);
    for i in 1:n_rows
        for j in 1:n_cols
            scenic_score_map[i, j] = get_scenic_score(tree_map, i, j);
        end
    end
    println(maximum(scenic_score_map));
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

function get_scenic_score(tree_map, row, col)
    return prod([get_left_scenic_score(tree_map, row, col),
                 get_right_scenic_score(tree_map, row, col),
                 get_top_scenic_score(tree_map, row, col),
                 get_bottom_scenic_score(tree_map, row, col)]);
end

function get_left_scenic_score(tree_map, row, col)
    # Trees at edge have no scenic score
    if row == 1
        return 0;
    end

    score = 0
    for i in (row-1):-1:1
        if tree_map[i, col] > tree_map[row, col]
            break;
        elseif tree_map[i, col] == tree_map[row, col]
            score += 1;
            break;
        end
        score += 1        
    end
    return score;
end

function get_right_scenic_score(tree_map, row, col)
    n_rows = size(tree_map)[1]
    # Trees at edge have no scenic score
    if row == n_rows
        return 0;
    end

    score = 0
    for i in row+1:n_rows
        if tree_map[i, col] > tree_map[row, col]
            break;
        elseif tree_map[i, col] == tree_map[row, col]
            score += 1;
            break;
        end
        score += 1        
    end
    return score;
end

function get_top_scenic_score(tree_map, row, col)
    # Trees at edge have no scenic score
    if col == 0
        return 0;
    end

    score = 0
    for j in col-1:-1:1
        if tree_map[row, j] > tree_map[row, col]
            break;
        elseif tree_map[row, j] == tree_map[row, col]
            score += 1;
            break;
        end
        score += 1        
    end
    return score;
end


function get_bottom_scenic_score(tree_map, row, col)
    n_cols = size(tree_map)[2]
    # Trees at edge have no scenic score
    if col == n_cols
        return 0;
    end

    score = 0
    for j in col+1:n_cols
        if tree_map[row, j] > tree_map[row, col]
            break;
        elseif tree_map[row, j] == tree_map[row, col]
            score += 1;
            break;
        end
        score += 1        
    end
    return score;
end



main();