import 'package:flutter/material.dart';
import 'package:graph_ql/config/graphql_config.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      child: HomePage(),
      client: Config.initailizeClient(),
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
  var _formKey = GlobalKey<FormState>();

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Subscription(
              builder: (result, {fetchMore, refetch}) {
                if (result.isLoading) {
                  return SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator());
                } else if (result.data == null) {
                  return Text("No data found");
                }
                return SizedBox(
                  height: 400,
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
              builder: (runMutation, result) => Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 200,
                      child: TextFormField(
                        controller: c1,
                        validator: (val) {
                          if (val?.trim().isEmpty ?? false) {
                            return "Please enter Name";
                          } else {
                            return null;
                          }
                        },
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
                      height: 80,
                      width: 200,
                      child: TextFormField(
                        controller: c2,
                        validator: (val) {
                          if (val?.trim().isEmpty ?? false) {
                            return "Please enter Code";
                          } else {
                            return null;
                          }
                        },
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
                        if (_formKey.currentState?.validate() ?? false) {
                          runMutation(<String, dynamic>{
                            "Name": c1.text,
                            "Code": c2.text,
                          });
                          if (result?.hasException ?? false) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "${result?.exception}",
                                  style: TextStyle(color: Colors.red),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                    child: Text("Ok"),
                                  )
                                ],
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Data has been added"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: Text("Ok"))
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
  Countries(order_by: {Code: asc, Name: asc}) {
    Code
    Name
  }
}''';
