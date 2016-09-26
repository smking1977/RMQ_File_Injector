-module(fileread_amqp_client).
-include("amqp_client.hrl").

-export([send/2,
	connect/0,
	close/2]).


send(Channel, Payload) ->

    Key = <<"test">>,
    MY_EXCH = <<"test">>,
    Publish = #'basic.publish'{exchange = MY_EXCH , routing_key = Key},
    Props = #'P_basic'{delivery_mode = 2}, %% persistent message
    Msg = #amqp_msg{props = Props, payload = Payload},
    amqp_channel:cast(Channel, Publish, Msg).
   


connect() ->     
    {ok, Connection} = amqp_connection:start(#amqp_params_network{}),
    {ok, Channel} = amqp_connection:open_channel(Connection),
    {Channel, Connection}.

close(Channel, Connection) ->
    amqp_channel:close(Channel),
    amqp_connection:close(Connection).
