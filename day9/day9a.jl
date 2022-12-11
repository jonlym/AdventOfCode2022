using LinearAlgebra

function main()
    cd(@__DIR__);
    head_position = [0, 0];
    tail_position = [0, 0];
    unique_tail_positions = Set([tail_position]);

    f_ptr = open("day9.txt", "r");
    while !eof(f_ptr)
        line = readline(f_ptr);
        direction, distance = parse_line(line);
        unit_displacement_vector = get_unit_displacement_vector(direction);
        for i in 1:distance
            head_position += unit_displacement_vector;
            tail_position = update_tail_position(tail_position, head_position);
            push!(unique_tail_positions, tail_position);
        end
    end
    close(f_ptr);
    println(length(unique_tail_positions));
end

function parse_line(line)
    direction, distance = split(line, " ");
    return direction, parse(Int64, distance);
end

function get_unit_displacement_vector(direction)
    if direction == "U"
        unit_displacement_vector = [0, 1];
    elseif direction == "D"
        unit_displacement_vector = [0, -1];
    elseif direction == "L"
        unit_displacement_vector = [-1, 0];
    elseif direction == "R"
        unit_displacement_vector = [1, 0];
    else
        error("Invalid direction")
    end
    return unit_displacement_vector;
end

function update_tail_position(tail_position, head_position)
    position_difference = head_position - tail_position;
    if norm(position_difference) < 2
        return tail_position;
    end

    tail_displacement_vector = map(x -> sign(x), position_difference);
    return tail_position + tail_displacement_vector
end

main();