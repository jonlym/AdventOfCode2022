function main()
    cd(@__DIR__);

    n_elves_per_group = 3;
    f_ptr = open("day3.txt", "r");
    total_priority = 0;
    while !eof(f_ptr)
        rucksacks = [];
        for i in range(1, n_elves_per_group)
            push!(rucksacks, readline(f_ptr));
        end

        common_badges = get_common_badges(rucksacks);
        badge_priority = get_items_priority(common_badges);
        total_priority += badge_priority;
    end
    close(f_ptr);

    println(total_priority);
end

"""Splits the rucksack into two compartments"""
function split_rucksack(rucksack)
    n_items = length(rucksack);
    middle_index = convert(Int64, n_items/2);
    compartment1 = rucksack[1:middle_index];
    compartment2 = rucksack[(middle_index+1):end];
    return (compartment1, compartment2);
end

"""Gets the common items between the compartments"""
function get_common_items(compartments...)
    compartments_unique_items = [];
    for compartment in compartments
        push!(compartments_unique_items, Set(compartment));
    end
    common_items = intersect(compartments_unique_items);
    return common_items;
end

"""Gets the common badge among the rucksacks"""
function get_common_badges(rucksacks)
    rucksack_unique_items = [];
    for rucksack in rucksacks
        push!(rucksack_unique_items, Set(rucksack));
    end
    common_badges = intersect(rucksack_unique_items...);
    return common_badges;
end

"""Totals the priority of a list of items"""
function get_items_priority(items)
    total_priority = 0;
    for item in items
        priority = get_priority(item);
        total_priority += priority;
    end
    return total_priority;
end

"""Converts item character to numerical priority equivalent"""
function get_priority(item)
    priority_offset = 0;
    if isuppercase(item)
        item = lowercase(item);
        priority_offset = 26;
    end

    priority = convert(Int64, item) - convert(Int64, 'a') + priority_offset + 1;
    return priority
end

main();