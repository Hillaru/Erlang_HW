%%%-------------------------------------------------------------------
%%% @author hillaru
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Dec 2021 12:55 PM
%%%-------------------------------------------------------------------
-module(serv_multistream).
-author("hillaru").
-export([passive/1, thread_send/2, receive_msg/0]).

receive_msg() ->
    User_list = #{1 => "Ivan", 2 => "Vasya", 3 => "Kirill", 4 => "Stass", 5 => "Oleg"},
    receive
        {PID, {get_user_by_id, ID}} -> io:format("~p send request ~p with parameter ~p~n", [PID, get_user_by_id, ID]),
            Result = maps:get(ID, User_list),
            PID ! {username, Result}
    end.

fileread(Filename) ->
    {Ans,Bin} = file:read_file(Filename),
    if
        Ans == ok -> erlang:binary_to_list(Bin);
        Ans == error -> error
    end.

thread_send(Msg, Socket) ->
    Path = string:trim(string:nth_lexeme(Msg, 2, " "), both, "/"),
    if  Path == "" -> gen_tcp:send(Socket, fileread("MainMenu"));
        Path == "favicon.ico" -> ok;
        true -> String = fileread(Path),
            if  String == error -> gen_tcp:send(Socket, fileread("MainMenu"));
                true -> gen_tcp:send(Socket, fileread(Path))
            end
    end,
    io:format("~p~n",[Path]),
    gen_tcp:close(Socket).

cycle(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    {ok, Msg} = gen_tcp:recv(Socket,0),
    io:format("~p~n",[Msg]),
    spawn(serv_multistream, thread_send, [Msg, Socket]),
    cycle(ListenSocket).

passive(Port) ->
    {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, false}, {reuseaddr, true}]),
    cycle(ListenSocket).