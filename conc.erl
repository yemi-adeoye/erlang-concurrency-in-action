-module(conc).
-compile(export_all).

start(Foodlist) ->
    io:format("Processess started!"),
    spawn(?MODULE, loop, [Foodlist]).

loop(FoodList) -> 
    receive
        {From, {append, Food}} ->
            From ! {self(), ok},
            loop([Food|FoodList]);
        {From, {get, Food}} -> 
            case lists:member(Food, FoodList) of
                true ->
                    From ! {self(), Food},
                    loop(lists:delete(Food, FoodList));
                false ->
                    From ! {self(), not_found},
                    loop(FoodList)
            end;
        terminate ->
            ok
    end.
            

append(Pid, Food) ->
    Pid ! {self(), {append, Food}},
    receive
        {Pid, Response} -> Response
    end.

get(Pid, Food) -> 
    Pid ! {self(), {get, Food}},
    receive
        {Pid, Response} -> Response
    end.