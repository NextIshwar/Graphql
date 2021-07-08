import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final httpLink = HttpLink("https://countries.trevorblades.com/");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
        GraphQLClient(link: httpLink, cache: GraphQLCache()));
    return GraphQLProvider(
      child: HomePage(),
      client: client,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GraphQl"),
        ),
        body: Query(
          builder: (result, {fetchMore, refetch}) {
            if (result.data == null) {
              return Text("No data found");
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, index) => Card(
                child: Row(
                  children: [
                    Text("${result.data?['continents'][index]['name']}"),
                    SizedBox(width: 20,),
                    Text("${result.data?['continents'][index]['countries'][index]['name']}"),
                  ],
                ),
              ),
              itemCount: result.data?['continents'].length,
            );
          },
          options: QueryOptions(document: gql(TodoFetch.fetchAll)),
        ));
  }
}

class TodoFetch {
  static String fetchAll = """query getConti{
  continents{
    name
    countries{
      name
    }
  }
}""";
}
