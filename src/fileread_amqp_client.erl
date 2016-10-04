-module(fileread_amqp_client).
-behaviour(gen_server).


-include("amqp_client.hrl").

-export([start/1, start/0, send/2]).

%% gen_server callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

start() ->
    gen_server:start({local, ?MODULE}, ?MODULE, [], []).

start(Name) ->
    gen_server:start({local, Name}, ?MODULE, [], []).

send(Name, File) ->
    gen_server:cast( Name, {send, File}).

init([]) ->
    io:fwrite("Initialized ~n"),
    Host = "127.0.0.1",
    {ok, Connection} = amqp_connection:start(#amqp_params_network{host = Host}),
    {ok, Channel} = amqp_connection:open_channel(Connection),
    {ok, #{connection => Connection, channel => Channel}}.
   

handle_call(_Request, _From, State) ->
    {reply, ignored, State}.

handle_cast({send, _Msg},  #{ channel := Channel } = State) ->
    Key = <<"test">>,
    MY_EXCH = <<"test">>,
    Publish = #'basic.publish'{exchange = MY_EXCH, routing_key = Key},
    Props = #'P_basic'{delivery_mode = 2}, %% persistent message,
    Msg = #amqp_msg{props = Props, payload = <<"hello">>},
    amqp_channel:cast(Channel, Publish, Msg),
%    io:fwrite("MSG SENT ~n"),
    {noreply, State};
handle_cast(_Msg, State) ->
    io:fwrite("Initialized wrong cast ~n"),
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, #{connection := Connection, channel := Channel}) ->
    amqp_channel:close(Channel),
    amqp_connection:close(Connection),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

