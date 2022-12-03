function main()
    cd(@__DIR__)
 
    f_ptr = open("day2.txt", "r");
    score = 0;
    while !eof(f_ptr)
        line = readline(f_ptr)
        player1_move, outcome = parse_line(line);
        player2_move = get_player2_move(player1_move, outcome);

        move_score = get_move_score(player2_move);
        match_outcome_score = get_match_outcome_score(outcome);
        score += move_score + match_outcome_score;
    end
    close(f_ptr);

    println(score);
end

"""Converts the line to each player's symbol equivalents"""
function parse_line(line)
    player1_code, outcome_code = split(line, " ");
    player1_move = translate_move(player1_code);
    outcome = translate_outcome(outcome_code);
    return (player1_move, outcome);
end

"""Converts a single code to a rock/paper/scissors symbol"""
function translate_move(code)
    move_dict = Dict("A" => :rock,
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

function translate_outcome(outcome_code)
    outcome_dict = Dict("X" => :loss,
                        "Y" => :draw,
                        "Z" => :win);
    return(outcome_dict[outcome_code]);
end

function get_player2_move(player1_move, outcome)
    loss_dict = Dict(:rock => :scissors,
                     :paper => :rock,
                     :scissors => :paper);
    win_dict = Dict(:rock => :paper,
                    :paper => :scissors,
                    :scissors => :rock);

    if outcome == :draw
        player2_move = player1_move
    elseif outcome == :loss
        player2_move = loss_dict[player1_move]
    else
        player2_move = win_dict[player1_move]
    end

    return(player2_move);
end

"""Calculates the number of points based on match outcome"""
function get_match_outcome_score(outcome)
    match_outcome_points = Dict(:win => 6,
                                :draw => 3,
                                :loss => 0);

    return(match_outcome_points[outcome]);
end

main()