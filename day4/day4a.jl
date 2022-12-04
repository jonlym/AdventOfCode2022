function main()
    cd(@__DIR__);

    n_subsets = 0;
    f_ptr = open("day4.txt", "r");
    while !eof(f_ptr)
        line = readline(f_ptr);
        assignments1, assignments2 = parse_line(line);
        is_subset = check_if_subset(assignments1, assignments2);
        if is_subset
            n_subsets += 1;
        end
    end
    close(f_ptr);

    println(n_subsets);
end

function parse_line(line)
    assignment_range1, assignment_range2 = split(line, ",");
    assignments1 = parse_assignment_range(assignment_range1);
    assignments2 = parse_assignment_range(assignment_range2);
    return (assignments1, assignments2)
end

function parse_assignment_range(assignment_range)
    assignments = [parse(Int64, assignment) for assignment in split(assignment_range, "-")];
    return assignments;
end

function check_if_subset(assignments1, assignments2)
    is_subset = false;
    if (assignments1[1] <= assignments2[1]) && (assignments1[2] >= assignments2[2])
        is_subset = true;
    elseif (assignments2[1] <= assignments1[1]) && (assignments2[2] >= assignments1[2])
        is_subset = true;
    end
    return is_subset;
end

main();