import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:networking_example/model/Album.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'model/CreateAlbum.dart';
import 'model/Photo.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Networking"),
      ),
      body: const FetchingDataExample(),
    );
  }
}

class FetchingDataExample extends StatefulWidget {
  const FetchingDataExample({super.key});

  @override
  State<StatefulWidget> createState() => Fetch();
}

class Fetch extends State<FetchingDataExample> {
  late Future<Album> futureAlbum;
  late Future<List<Photo>> photosFuture;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    photosFuture = fetchPhotos(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    //Album Fetch (GET METHOD)
    // return Center(
    //     child: DisplayFutureAlbum(
    //   album: futureAlbum,
    // ));
    //List Photo Fetch (GET METHOD)
    // return Center(
    //   child: DisplayPhotos(photosFuture: photosFuture),
    // );
    //Create album (POST METHOD)
    // return const Center(
    //   child: CreateAlbumExample(),
    // );
    //Update album (UPDATE METHOD)
    // return const Center(
    //   child: UpdateAlbumExample(),
    // );
    //Delete album (DELETE METHOD)
    // return const Center(
    //   child: DeleteAlbumExample(),
    // );
    //Web Socket
    return const Center(
      child: WebSocketExample(),
    );
  }
}

//GET Method
//GET without token header
Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

//GET with token header
// Future<Album> fetchAlbum() async {
//   final response = await http.get(
//     Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
//     // Send authorization headers to the backend.
//     headers: {
//       HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
//     },
//   );
//   final responseJson = jsonDecode(response.body);

//   return Album.fromJson(responseJson);
// }

class DisplayFutureAlbum extends StatelessWidget {
  final Future<Album> album;

  const DisplayFutureAlbum({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Album>(
      future: album,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

// List Photo
Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class DisplayPhotos extends StatelessWidget {
  final Future<List<Photo>> photosFuture;

  const DisplayPhotos({Key? key, required this.photosFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Photo>>(
      future: photosFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Image.network(snapshot.data![index].thumbnailUrl);
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

//Post method
Future<CreateAlbum> createAlbum(String title) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return CreateAlbum.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class CreateAlbumExample extends StatefulWidget {
  const CreateAlbumExample({super.key});

  @override
  State<CreateAlbumExample> createState() => CreateAlbumDisplay();
}

class CreateAlbumDisplay extends State<CreateAlbumExample> {
  final TextEditingController _controller = TextEditingController();

  Future<CreateAlbum>? _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: (_futureAlbum == null) ? buildColumn() : buildFutureBuilder(),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Title'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAlbum = createAlbum(_controller.text);
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<CreateAlbum> buildFutureBuilder() {
    return FutureBuilder<CreateAlbum>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.title);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

//Update method
Future<CreateAlbum> updateAlbum(String title) async {
  final response = await http.put(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return CreateAlbum.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to update album.');
  }
}

Future<CreateAlbum> fetchAlbumUpdate() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return CreateAlbum.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class UpdateAlbumExample extends StatefulWidget {
  const UpdateAlbumExample({super.key});

  @override
  State<StatefulWidget> createState() => UpdateAlbumDisplay();
}

class UpdateAlbumDisplay extends State<UpdateAlbumExample> {
  final TextEditingController _controller = TextEditingController();
  late Future<CreateAlbum> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbumUpdate();
  }

  @override
  Widget build(Object context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: FutureBuilder<CreateAlbum>(
        future: _futureAlbum,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(snapshot.data!.title),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter Title',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureAlbum = updateAlbum(_controller.text);
                      });
                    },
                    child: const Text('Update Data'),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

//Delete method
Future<CreateAlbum> deleteAlbum(String id) async {
  final http.Response response = await http.delete(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON. After deleting,
    // you'll get an empty JSON `{}` response.
    // Don't return `null`, otherwise `snapshot.hasData`
    // will always return false on `FutureBuilder`.
    return CreateAlbum.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a "200 OK response",
    // then throw an exception.
    throw Exception('Failed to delete album.');
  }
}

class DeleteAlbumExample extends StatefulWidget {
  const DeleteAlbumExample({super.key});

  @override
  State<StatefulWidget> createState() => DeleteAlbumDisplay();
}

class DeleteAlbumDisplay extends State<DeleteAlbumExample> {
  late Future<CreateAlbum> _futureAlbum;
  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbumUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CreateAlbum>(
      future: _futureAlbum,
      builder: (context, snapshot) {
        // If the connection is done,
        // check for response data or an error.
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(snapshot.data?.title ?? 'Deleted'),
                ElevatedButton(
                  child: const Text('Delete Data'),
                  onPressed: () {
                    setState(() {
                      _futureAlbum = deleteAlbum(snapshot.data!.id.toString());
                    });
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

//Web socket
class WebSocketExample extends StatefulWidget {
  const WebSocketExample({super.key});

  @override
  State<StatefulWidget> createState() => WebSocketDisplay();
}

class WebSocketDisplay extends State<WebSocketExample> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            ),
            FloatingActionButton(
              onPressed: _sendMessage,
              tooltip: 'Send message',
              child: const Icon(Icons.send),
            ),
          ],
        ));
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
