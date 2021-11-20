-module(rec).

-export([fib/1, fact/1, num_sum/1, prime_num/1]).

fib(N) ->
    if
        N > 1 -> fib(N-1) + fib(N-2);
        N == 1 -> 1;
        N == 0 -> 0;
        true -> io:format("Error~n")
    end.

fact(N) ->
    if
        N > 1 -> fact(N-1) * N;
        N == 1 -> 1;
        true -> io:format("Error~n")
    end.

num_sum(N) ->
    if
        N >= 10 -> num_sum(N div 10) + N rem 10;
        N < 10 -> N
    end.

task_h(N, I) ->
    if
        N < 2 -> io:format("Odd~n");
        N == 2 -> io:format("Even~n");
        N rem I == 0 -> io:format("Odd~n");
        (N div 2) > I -> task_h(N, I + 1);
        true -> io:format("Even~n")
    end.

prime_num(N) ->
    if
        N < 0 -> io:format("Error~n");
        true -> task_h(N, 2)
    end.

