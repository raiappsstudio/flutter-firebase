import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/scrore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<FootballScore> _footballscorelist = [];
  bool inProgress = false;

  @override
  void initState() {
    super.initState();
    _getLiveScoreList();
  }

  Future<void> _getLiveScoreList() async {
    inProgress = true;
    setState(() {});
    _footballscorelist.clear();
    QuerySnapshot<Map<String, dynamic>> snapshots =
        await db.collection('football').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshots.docs) {
      _footballscorelist.add(FootballScore.fromJson(doc.data(), doc.id));
      inProgress = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Scrore List"),
        backgroundColor: Colors.blue,
      ),
      body: Visibility(
        visible: inProgress == false,
        replacement: Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.builder(
          itemCount: _footballscorelist.length,
          itemBuilder: (context, index) {
            FootballScore score = _footballscorelist[index];
            return ListTile(
              title: Text(
                score.matchName,
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${score.team1_name} vs ${score.team2_name}'),
                  if (score.is_running == false)
                    Text('Winner team is ${score.winner}')
                ],
              ),
              trailing: Text(
                '${score.team1_score}-${score.team2_score}',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              leading: CircleAvatar(
                backgroundColor: score.is_running ? Colors.green : Colors.grey,
                radius: 15,
              ),
            );
          },
        ),
      ),
    );
  }
}
