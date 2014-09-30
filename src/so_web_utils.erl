-module(so_web_utils).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export(
  [ start_webserver/0
  ]).

-define(WEB_SERVER_TYPE, http).
-define(WEB_PORT, 8080).
-define(WEB_LISTENERS, 1).
-define(WEB_MAX_CONN, 1024).
-define(WEB_TIMEOUT, 12000).

-spec start_webserver() -> ok.
start_webserver() ->
  lager:info("Starting cowboy"),
  WebServerType = application:get_env(shoutout, web_server_type, ?WEB_SERVER_TYPE),
  WebPort       = application:get_env(shoutout, web_port, ?WEB_PORT),
  WebListeners  = application:get_env(shoutout, web_listeners, ?WEB_LISTENERS),
  WebMaxConns   = application:get_env(shoutout, web_max_connections, ?WEB_MAX_CONN),
  WebTimeout    = application:get_env(shoutout, web_timeout, ?WEB_TIMEOUT),

  Routes =
    [ { '_'
      , [ {<<"/shoutout">>, so_handler, []}
        , {<<"/test">>, cowboy_static, {file, <<"./priv/websocket_test.html">>}}
        ]
      }
    ],
  Dispatch = cowboy_router:compile(Routes),

  TransOpts =
    [ {port,            WebPort}
    , {max_connections, WebMaxConns}
    ],
  ProtoOpts =
    [ {env,       [{dispatch, Dispatch}]}
    , {compress,  true}
    , {timeout,   WebTimeout}
    ],
  case WebServerType of
    http ->
      cowboy:start_http(shoutout_http, WebListeners, TransOpts, ProtoOpts);
    https ->
      cowboy:start_https(shoutout_https, WebListeners, TransOpts, ProtoOpts)
  end.

% -spec stop_cowboy() -> ok | {missing, cowboy_sup}.
% stop_cowboy() ->
%   case whereis(cowboy_sup) of
%     undefined -> {missing, cowboy_sup};
%     _Pid      -> cowboy:stop_listener(min_cowboy)
%   end.
