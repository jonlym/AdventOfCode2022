function main()
    cd(@__DIR__)

    all_elf_calories = [];
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
    
    println(maximum(all_elf_calories));
end

main()