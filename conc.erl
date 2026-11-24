-module(conc).
-compile(export_all).

start(Foodlist) ->
    io:format("Processess started!"),
    spawn(?MODULE, conc, [Foodlist]).

loop(Foodlist) -> 
    receive
        {From, {append, Food}} ->
            loop([Food|FoodList]);
        {From, {get, Food}} -> 
            case list:member(Food, FoodList) of
                true ->
                    From ! {}

append(Pid, Food) ->
    io:format("Appending ~p~n", [Food]),
    receive
        {Pid, Food} -> Food
    end.