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
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );
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
  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GraphQl"),
      ),
      extendBody: true,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Query(
                builder: (result, {fetchMore, refetch}) {
                  
                  if (result.isLoading) {
                    return SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator());
                  }
                  else if (result.data == null) {
                    return Text("No data found");
                  }
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
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
                    ),
                  );
                },
                options: QueryOptions(document: gql(TodoFetch.fetchAll)),
              ),
              SizedBox(
                height: 40,
              ),
              // Mutation(
              //   options: MutationOptions(
              //     document: gql(TodoFetch.addData),
              //   ),
              //   builder: (runMutation, result) => Column(
              //     children: [
              //       SizedBox(
              //         height: 50,
              //         width: 200,
              //         child: TextFormField(
              //           controller: c1,
              //           decoration: InputDecoration(
              //             hintText: "Name",
              //             border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         height: 20,
              //       ),
              //       SizedBox(
              //         height: 50,
              //         width: 200,
              //         child: TextFormField(
              //           controller: c2,
              //           decoration: InputDecoration(
              //             hintText: "Code",
              //             border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         height: 20,
              //       ),
              //       ElevatedButton(
              //         onPressed: () {
              //           runMutation(<String, dynamic>{
              //             "Name":c1.text,
              //             "Code":c2.text,
              //           });
              //         },
              //         child: Text("Submit"),
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
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