-module(fileread_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    fileread_reader:start(),
    Procs = [],
    {ok, {{one_for_one, 1, 5}, Procs}}.
