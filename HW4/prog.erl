-module(prog).
-import(lists, [seq/2, sum/1]).
-export([main/2]).
-record(person, {name = "", phone = "", age = 0}).

main(N, Name) ->
    get_list_square_sum(N),
    PersonsList =[
        #person{name  = "Alex", phone = "88005553535", age = 42},
        #person{name  = "Kiril", phone = "82312345223", age = 23},
        #person{name  = "Vladimir", phone = "81231555333", age = 15},
        #person{name  = "Dmitry", phone = "85553332341", age = 27},
        #person{name  = "Nina", phone = "82322256666", age = 32},
        #person{name  = "Masha", phone = "82342424666", age = 31},
        #person{name  = "Vasily", phone = "88555563234", age = 19}
        ],

    io:format("Result of a phone finding operation: ~p~n",[find_phone(PersonsList, Name)]),
    io:format("Average age of all persons: ~p~n",[average_age(PersonsList)]).

get_list_square_sum(N) when N < 1 ->
    error;
get_list_square_sum(N) ->
    List = seq(1, N),
    List2 = multiply_list(List, []),
    io:format("The sum of a multiplied list with ~p elements = ~p~n",[N, sum(List2)]).

multiply_list([], List2) ->
    List2;
multiply_list([H|T], List1) ->
    List2 = List1 ++ [H * H],
    multiply_list(T, List2).

find_phone([], _) ->
    no_such_person;
find_phone([H|T], Name) ->
    if
        H#person.name == Name -> H#person.phone;
        true -> find_phone(T, Name)
    end.

average_age([H|T]) ->
    if
        H == [] -> list_is_empty;
        true -> Sum = H#person.age, Count = 1, average_age(T, Sum, Count)
    end.

average_age([], Sum, Count) ->
    Sum / Count;
average_age([H|T], Sum, Count) ->
    Sum1 = Sum + H#person.age,
    Count1 = Count + 1,
    average_age(T, Sum1, Count1).





