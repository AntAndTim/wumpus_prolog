% --Initialization variables---------------------------------
width(X) :-
    X is 4.

height(H) :-
    H is 4.

world(W) :-
    W = [1:3-wumpus,2:3-gold,3:3-pit,3:1-pit,4:4-pit].

world_start(X:Y) :-
    X is 1,
    Y is 1.

wumpus(X:Y) :-
    X is 1,
    Y is 3.

% --Movement constraints-------------------------------------
no_pit(X:Y) :-
    world(World),
    not(member(X:Y-pit, World)).

in_borders(X:Y):-
    width(FX),
    height(FY),
    world_start(SX:SY),
    X >= SX,
    X =< FX,
    Y >= SY,
    Y =< FY.

no_wall(X:Y) :-
    in_borders(X:Y).

is_gold(X:Y, Steps) :-
    world(World),
    member(X:Y-gold, World),
    append(Steps, [X:Y], FinalSteps),
    wumpus(WX:WY),
    (member(WX:WY, Steps) -> write("Killed Wumpus on this way!\n"); true),
    write(FinalSteps).

may_enter(X:Y, Steps) :-
    no_pit(X:Y),
    no_wall(X:Y),
    not(visited(X:Y, Steps)).

visited(X:Y, Steps) :-
    member(X:Y, Steps);
    false.

% --Possible movements---------------------------------------
visit(X:Y, Steps, NewSteps) :-
    append(Steps, [X:Y], NewSteps);
    true.

move_right(X:Y, Steps) :-
    NX is X+1,
    may_enter(NX:Y, Steps),
    find_way(NX:Y, Steps).

move_left(X:Y, Steps) :-
    NX is X-1,
    may_enter(NX:Y, Steps),
    find_way(NX:Y, Steps).

move_up(X:Y, Steps) :-
    NY is Y+1,
    may_enter(X:NY, Steps),
    find_way(X:NY, Steps).

move_down(X:Y, Steps) :-
    NY is Y-1,
    may_enter(X:NY, Steps),
    find_way(X:NY, Steps).

% --Main methods---------------------------------------------
find_way(X:Y, Steps) :- (
    not(visited(X:Y, Steps)) -> (
        visit(X:Y, Steps, NewSteps),
        (move_right(X:Y, NewSteps);
        move_left(X:Y, NewSteps);
        move_up(X:Y, NewSteps);
        move_down(X:Y, NewSteps));
        is_gold(X:Y, Steps)
    )
).

start(X:Y) :-
    wumpus(WX:WY),
    world_start(X:Y),
    (X = WX, Y = WY) -> write("You was killed by Wumpus.") ; (
        find_way(X:Y, [])
    ).