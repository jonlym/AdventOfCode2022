function main()
    cd(@__DIR__);
    f_ptr = open("day6.txt", "r");
    message = readline(f_ptr);
    close(f_ptr);

    packet_marker_length = 4
    final_position = 0;
    for end_position in packet_marker_length:length(message)
        start_position = end_position - packet_marker_length + 1;
        unique_characters = Set(message[start_position:end_position]);
        if length(unique_characters) == packet_marker_length
            final_position = end_position;
            break;
        end
    end
    println(final_position);
end

main();