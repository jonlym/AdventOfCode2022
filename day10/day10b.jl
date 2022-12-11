
function main()
    register_values = [1];
    crt_height = 6;
    crt_width = 40;
    sprite_width = 3;

    f_ptr = open("day10.txt", "r");
    while !eof(f_ptr)
        line = readline(f_ptr);
        adjustment, n_cycles = parse_line(line);
        for i = 1:1:n_cycles-1
            push!(register_values, register_values[end]);
        end
        push!(register_values, register_values[end] + adjustment);
    end
    close(f_ptr);
    crt_message = decode_crt_message(register_values, crt_height, crt_width,
                                     sprite_width);
    print_crt_message(crt_message, crt_height, crt_width);
end

function parse_line(line)
    if line == "noop"
        adjustment = 0;
        n_cycles = 1;
        return (adjustment, n_cycles)
    end

    adjustment = parse(Int64, split(line, " ")[2]);
    n_cycles = 2;
    return (adjustment, n_cycles)
end

function get_signal_strength(register_value, cycle)
    return register_value * cycle;
end

function calc_signal_strength_sum(register_values, important_cycles)
    return sum([get_signal_strength(register_values[important_cycle], important_cycle) 
                for important_cycle in important_cycles]);
end

function decode_crt_message(register_values, crt_height, crt_width,
                            sprite_width)
    crt_message = "";
    lit_pixel = "#";
    unlit_pixel = ".";
    for (cycle, register_value) in enumerate(register_values)
        crt_position = rem(cycle - 1, crt_width);

        sprite_offset = (sprite_width - 1) ÷ 2;
        sprite_start_position = register_value - sprite_offset;
        sprite_end_position = register_value + sprite_offset;

        if crt_position in sprite_start_position:sprite_end_position
            crt_message = string(crt_message, lit_pixel);
        else
            crt_message = string(crt_message, unlit_pixel);
        end            
    end
    return crt_message;
end

function print_crt_message(crt_message, crt_height, crt_width)
    for row in 1:crt_height
        println(crt_message[(row-1)*crt_width+1:row*crt_width]);
    end
end

main();