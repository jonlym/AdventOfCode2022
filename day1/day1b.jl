function main()
    cd(@__DIR__)

    all_elf_calories = [];
    n_top_elves = 3;
    top_n_elf_calories = [];
    single_elf_calories = 0;

    f_ptr = open("./day1a.txt")
    while !eof(f_ptr)
        line = readline(f_ptr);
        
        if length(line) == 0
            # Encountered new line. Store total value and reset counter
            push!(all_elf_calories, single_elf_calories);
            single_elf_calories = 0;
        else
            # Add on calories to current elf
            single_elf_calories += parse(Int64, line);
        end
    end
    close(f_ptr)
    
    sort!(all_elf_calories, rev=true);
    println(sum(all_elf_calories[1:n_top_elves]));
end

main()