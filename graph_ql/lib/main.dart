import 'package:flutter/material.dart';
import 'package:graph_ql/config/graphql_config.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  static String _token =
      "U8bcmJUM441Zh0n8OaqQrTa3fEktZa4rVM33gdA9A4sSdIQdKDx0eBaUsQf7AjW1";
  //  static final AuthLink authLink = AuthLink(getToken: () => _token);

  @override
  Widget build(BuildContext context) {
    // Config.initailizeClient(_token);
    //final httpLink = HttpLink("https://pet-drake-49.hasura.app/v1/graphql");

    return GraphQLProvider(
      child: HomePage(),
      client: Config.initailizeClient(_token),
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
              Subscription(
                builder: (result, {fetchMore, refetch}) {
                  print(result.toString());
                  if (result.isLoading) {
                    return SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator());
                  } else if (result.data == null) {
                    return Text("No data found");
                  }
                  // print(result.toString());
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, index) => Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("${result.data?['Countries'][index]['Name']}"),
                            SizedBox(
                              width: 20,
                            ),
                            Text("${result.data?['Countries'][index]['Code']}"),
                          ],
                        ),
                      ),
                      itemCount: result.data?['Countries']?.length,
                    ),
                  );
                },
                onSubscriptionResult: (subscriptionResult, client) {
                  print(subscriptionResult.toString());
                },
                options: SubscriptionOptions(document: gql(subs)),
              ),
              SizedBox(
                height: 40,
              ),
              Mutation(
                options: MutationOptions(
                  document: gql(TodoFetch.addData),
                ),
                builder: (runMutation, result) => Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: TextFormField(
                        controller: c1,
                        decoration: InputDecoration(
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: 200,
                      child: TextFormField(
                        controller: c2,
                        decoration: InputDecoration(
                          hintText: "Code",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        runMutation(<String, dynamic>{
                          "Name": c1.text,
                          "Code": c2.text,
                        });
                      },
                      child: Text("Submit"),
                    ),
                    // if(result?.data!=null)
                    // SnackBar(content: Text(result.toString()))
                  ],
                ),
              ),
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
  static String addData = r"""mutation inserData($Name:bpchar!,$Code:bpchar!){
  insert_Countries(objects:[{Name:$Name, Code:$Code}]){
    returning{
      Name
      Code
    }
  }
}""";
}

String str = '''query getData{
  Countries {
    Code
    Name
  }
}
''';

String subs = '''subscription MyQuery{
  Countries {
    Code
    Name
  }
}''';
