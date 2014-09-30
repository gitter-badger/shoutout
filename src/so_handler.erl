-module(so_handler).

-export(
  [ init/3
  , websocket_init/3
  , websocket_handle/3
  , websocket_terminate/3
  ]).

-record(state,
  {
  }).
-type state() :: #state{}.

-spec init(any(), cowboy_req:req(), proplists:proplists()) ->
  {upgrade, protocol, cowboy_websocket}.
init(_, _Req, _Opts) ->
  {upgrade, protocol, cowboy_websocket}.

-spec websocket_init(term(), cowboy_req:req(), proplists:proplists()) ->
  {ok, cowboy_req:req(), state()}.
websocket_init(_Type, Req, _Opts) ->
  {ok, Req, #state{}}.

-spec websocket_handle(term(), cowboy_req:req(), state()) ->
  {reply | ok, cowboy_req:req(), state()}.
websocket_handle(Frame = {text, _}, Req, State) ->
  lager:info("Recieved frame: ~n~p", [Frame]),
  {reply, Frame, Req, State};
websocket_handle(_Frame, Req, State) ->
  {ok, Req, State}.

-spec websocket_terminate(term(), cowboy_req:req(), state()) ->
  {ok, cowboy_req:req(), state()}.
websocket_terminate(Reason, Req, State) ->
  lager:info("Terminate reason: ~p", [Reason]),
  {ok, Req, State}.

