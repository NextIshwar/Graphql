import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Config {
  static final HttpLink httpLink =
      HttpLink('https://pet-drake-49.hasura.app/v1/graphql', defaultHeaders: {
    'x-hasura-admin-secret':
        "U8bcmJUM441Zh0n8OaqQrTa3fEktZa4rVM33gdA9A4sSdIQdKDx0eBaUsQf7AjW1",
    "content-type": "application/json",
  });

  static final WebSocketLink socketLink = WebSocketLink(
    'wss://pet-drake-49.hasura.app/v1/graphql',
    
    config: SocketClientConfig(
      initialPayload: () {
        return {
          'headers': {
            'x-hasura-admin-secret':
                "U8bcmJUM441Zh0n8OaqQrTa3fEktZa4rVM33gdA9A4sSdIQdKDx0eBaUsQf7AjW1"
          },
        };
      },
    ),
    
  );
  // static String _token =
  //     "U8bcmJUM441Zh0n8OaqQrTa3fEktZa4rVM33gdA9A4sSdIQdKDx0eBaUsQf7AjW1";
  //static final AuthLink authLink = AuthLink(getToken: () => _token);
  // static final WebSocketLink websocketLink = WebSocketLink(
  //   'wss://hasura.io/learn/graphql',
  //   config: SocketClientConfig(
  //     autoReconnect: true,
  //     inactivityTimeout: Duration(seconds: 30),
  //     initialPayload: () async {
  //       return {
  //         'headers': {'x-hasura-admin-secret': _token},
  //       };
  //     },
  //   ),
  // );
  // static final Link link = authLink.concat(httpLink).concat(websocketLink);
  static ValueNotifier<GraphQLClient> initailizeClient(String token) {
    //  _token = token;
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: GraphQLCache(),
        link: socketLink,
      ),
    );
    return client;
  }
}
