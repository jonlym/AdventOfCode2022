using DataStructures

function main()
    cd(@__DIR__);
    f_ptr = open("day5.txt", "r");
    stacks = get_initial_stacks(f_ptr);
    # Skip empty line
    line = readline(f_ptr);
    rearrange_crates_on_stacks!(stacks, f_ptr);
    close(f_ptr);

    for stack in stacks
        print(first(stack))
    end
end

"""Parse initial stacks"""
function get_initial_stacks(f_ptr)
    n_stacks = 0;
    reading_initial_stacks = true;
    reversed_stacks = nothing;
    while reading_initial_stacks
        line = readline(f_ptr);

        # Find number of stacks at first line
        if n_stacks == 0
            n_stacks = get_number_of_stacks(line);
            reversed_stacks = [Stack{Char}() for i in 1:n_stacks];
        end

        reading_initial_stacks = check_for_end_of_initial_stacks(line,
            reading_initial_stacks);
    
        # Break out of loop if initial section completed
        if !(reading_initial_stacks)
            break;
        end

        # Add the crates to the reversed stacks
        crates_in_row = parse_crates(line, n_stacks);
        add_crates_to_reversed_stacks!(reversed_stacks, crates_in_row);
    end

    stacks = copy_crates_to_stacks(reversed_stacks);
    return stacks;
end

"""Determine the number of stacks by the length of the initial line"""
function get_number_of_stacks(line)
    return convert(Int64, 0.25 * length(line) + 0.25);
end

"""Checks whether the line only has numbers to determine if the end of the 
initial stacks section has been reached"""
function check_for_end_of_initial_stacks(line, reading_initial_stacks)
    # No need to check if you've passed the initial stack section
    if reading_initial_stacks == false
        return false
    end

    # Check if line contains only spaces and numbers
    if all([isnumeric(x) || x == ' ' for x in line])
        return false;
    end

    # Otherwise, still parsing initial stacks
    return true;
end

"""Parse the input file for the crates belonging to each stack"""
function parse_crates(line, n_stacks)
    crates_in_row = [];
    for stack_number in 1:n_stacks
        crate_position = convert(Int64, 4 * stack_number - 2);
        crate = line[crate_position];
        push!(crates_in_row, crate);
    end
    return crates_in_row;
end

"""Adds the crates to the reversed stacks"""
function add_crates_to_reversed_stacks!(reversed_stacks, crates)
    for (reversed_stack, crate) in zip(reversed_stacks, crates)
        # Skip row if no crate in the row
        if crate == ' '
            continue
        end

        push!(reversed_stack, crate)
    end
end

"""Copies the content of the initial reversed_stack (i.e. crates) to stacks"""
function copy_crates_to_stacks(reversed_stacks)
    n_stacks = length(reversed_stacks);
    stacks = [Stack{eltype(reversed_stacks[1])}() for i in 1:n_stacks];

    for (stack, reversed_stack) in zip(stacks, reversed_stacks)
        for crate in reversed_stack
            push!(stack, crate);
        end
    end

    return stacks;
end

function rearrange_crates_on_stacks!(stacks, f_ptr)
    # i = 11
    while !eof(f_ptr)
        line = readline(f_ptr);
        n_crates, source_stack, dest_stack = parse_move_instruction(line);
        move_crates!(n_crates, source_stack, dest_stack, stacks);
    end
end

function parse_move_instruction(line)
    separated_line = split(line, " ");
    n_crates = parse(Int64, separated_line[2]);
    source_stack = parse(Int64, separated_line[4]);
    dest_stack = parse(Int64, separated_line[6]);

    return (n_crates, source_stack, dest_stack);
end

function move_crates!(n_crates, source_stack, dest_stack, stacks)
    for i in 1:n_crates
        crate = pop!(stacks[source_stack]);
        push!(stacks[dest_stack], crate);
    end
end

main();