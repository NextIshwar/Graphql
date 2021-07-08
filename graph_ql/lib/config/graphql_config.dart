// import "package:flutter/material.dart";
// import "package:graphql_flutter/graphql_flutter.dart";

// class GraphQLConfiguration {
//   static HttpLink httpLink = HttpLink("https://examplegraphql.herokuapp.com/graphql",
//   );

//   ValueNotifier<GraphQLClient> client = ValueNotifier(
//     GraphQLClient(
//       link: httpLink,
//       cache: GraphQLCache(dataIdFromObject: typenameDataIdFromObject),
//     ),
//   );

//   GraphQLClient clientToQuery() {
//     return GraphQLClient(
//       cache: GraphQLCache(dataIdFromObject: typenameDataIdFromObject),
//       link: httpLink,
//     );
//   }
// }