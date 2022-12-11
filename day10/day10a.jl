
function main()
    register_values = [1];
    important_cycles = [20, 60, 100, 140, 180, 220];
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

    signal_strength_sum = calc_signal_strength_sum(register_values,
                                                   important_cycles);
    println(signal_strength_sum);
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

main();