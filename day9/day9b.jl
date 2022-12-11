using LinearAlgebra

function main()
    cd(@__DIR__);
    rope_length = 10
    positions = repeat([[0, 0]], rope_length);
    unique_tail_positions = Set([positions[end]]);

    f_ptr = open("day9.txt", "r");
    while !eof(f_ptr)
        line = readline(f_ptr);
        direction, distance = parse_line(line);
        unit_displacement_vector = get_unit_displacement_vector(direction);
        for i in 1:distance
            positions[1] += unit_displacement_vector;
            for j = 2:rope_length
                positions[j] = update_tail_position(positions[j],
                                                    positions[j-1]);
            end
            push!(unique_tail_positions, positions[end]);
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