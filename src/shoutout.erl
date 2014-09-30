
-module(shoutout).

-behaviour(application).

%% Public API
-export(
  [ start/0
  , stop/0
  ]).
%% Application callbacks
-export(
  [ start/2
  , stop/1
  ]).

-type startlink_err() :: {already_started, pid()} | {shutdown, term()} | term().
-type startlink_ret() :: {ok, pid()} | ignore | {error, startlink_err()}.

%% Public API

-spec start() -> startlink_ret().
start() ->
  {ok, _Started} = application:ensure_all_started(shoutout).

-spec stop() -> ok.
stop() ->
  application:stop(shoutout).

%% Application callbacks

-spec start(any(), list()) -> startlink_ret().
start(normal, []) ->
  {ok, Pid} = so_sup:start_link(),
  so_web_utils:start_webserver(),
  {ok, Pid}.

-spec stop(any()) -> ok.
stop(_State) ->
  ok.

%% Auxiliary functions

