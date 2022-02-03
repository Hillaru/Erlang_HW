%%%-------------------------------------------------------------------
%% @doc mysqlserver public API
%% @end
%%%-------------------------------------------------------------------

-module(mysqlserver_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    mysqlserver_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
