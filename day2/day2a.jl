function main()
    cd(@__DIR__)
 
    f_ptr = open("day2.txt", "r");
    score = 0;
    while !eof(f_ptr)
        line = readline(f_ptr)
        player1_move, player2_move = parse_line(line);
        move_score = get_move_score(player2_move);
        match_outcome_score = get_match_outcome_score(player1_move,
                                                      player2_move);
        score += move_score + match_outcome_score;
    end
    close(f_ptr);

    println(score);
end

"""Converts the line to each player's symbol equivalents"""
function parse_line(line)
    player1_code, player2_code = split(line, " ");
    player1_move = translate_move(player1_code);
    player2_move = translate_move(player2_code);
    return (player1_move, player2_move)
end

"""Converts a single code to a rock/paper/scissors symbol"""
function translate_move(code)
    move_dict = Dict("X" => :rock,
                     "Y" => :paper,
                     "Z" => :scissors,
                     "A" => :rock,
                     "B" => :paper,
                     "C" => :scissors);
    return(move_dict[code]);
end

"""Calculates the number of points based on player's move"""
function get_move_score(move)
    move_points = Dict(:rock => 1,
                       :paper => 2,
                       :scissors => 3);
    return move_points[move];
end

"""Calculates the number of points based on match outcome"""
function get_match_outcome_score(player1_move, player2_move)
    match_outcome_points = Dict(:win => 6,
                                :draw => 3,
                                :loss => 0);

    win_dict = Dict(:rock => :scissors,
                    :paper => :rock,
                    :scissors => :paper);

    if player1_move == player2_move
        outcome = :draw;
    elseif win_dict[player2_move] == player1_move
        outcome = :win;
    else
        outcome = :loss;
    end

    return(match_outcome_points[outcome]);
end

main()