-module(serv_mysql).
-author("hillaru").
-export([passive/1, thread_send/1]).

split_string(String) ->
    [_, Action, Id | _] = string:lexemes(binary_to_list(String), "/ " ++ [[$\r,$\n]]).

generate_html("favicon.ico", _) ->
    ok;
generate_html("getallstaff", _) ->
    {ok, _, List} = mysql:query(db, <<"SELECT * FROM staff">>),
    List;
generate_html("getstaff", Id) ->
    {ok, _, [List]} = mysql:query(db, <<"SELECT * FROM staff WHERE Staff_id = ?">>, [Id]),
    [List];
generate_html(_, _) ->
    "Invalid command".

thread_send(Socket) ->
    {ok, Msg} = gen_tcp:recv(Socket,0),
    io:format("~p~n",[Msg]),
    [_, Action, Id | _] = split_string(Msg),
    io:format("Action = ~p~n",[Action]),
    io:format("Id = ~p~n",[Id]),

    Html = generate_html(Action, Id),
    Response = "HTTP/1.1 200 OK\nContent-Type: text/html; charset=utf-8\n\n\n<html>\n<body\n<p>" ++ Html,
    gen_tcp:send(Socket, Response),

    gen_tcp:close(Socket).

cycle(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    spawn(serv_mysql, thread_send, [Socket]),
    cycle(ListenSocket).

passive(Port) ->
    {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {active, false}, {reuseaddr, true}]),
    {ok, Pid} = mysql:start_link([{host, "localhost"}, {user, "hillaru"}, {database, "test_db"}]),
    erlang:register(db, Pid),
    cycle(ListenSocket).
