import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/Home/pages/createNewStory.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with TickerProviderStateMixin  {
  final PageController pageController =
      new PageController(viewportFraction: 0.9);
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Stream slides;

  String activeTag = 'all stories';

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _queryDB();
    pageController.addListener(() {
      int next = pageController.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  void _queryDB({String tag = 'all stories'}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Query query = db
        .collection('users')
        .doc(sharedPreferences.get('uid'))
        .collection('stories')
        .where('tags', arrayContains: tag);

    slides = query.snapshots();

    setState(() {
      activeTag = tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    ParticleOptions particleOptions = ParticleOptions(
      baseColor: Teal,
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.05,
      maxOpacity: 0.1,
      spawnMinSpeed: 30.0,
      spawnMaxSpeed: 50.0,
      spawnMinRadius: 4.0,
      spawnMaxRadius: 10.0,
      particleCount: 15,
    );

    return SafeArea(
        child: Scaffold(
          backgroundColor: LightGrey,
          body: Stack(
            children: [
              AnimatedBackground(
                behaviour: RandomParticleBehaviour(options: particleOptions),
                vsync: this, child: Container(),
              ),
              StreamBuilder(
                stream: slides,
                initialData: [],
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return PageView.builder(
                      controller: pageController,
                      itemCount: snapshot.data.documents.length + 1,
                      itemBuilder: (context, int currentIndex) {
                        if (currentIndex == 0) {
                          return _buildTagPage();
                        } else {
                          DocumentSnapshot documentSnapshot =
                              snapshot.data.documents[currentIndex - 1];
                          bool active = currentIndex == currentPage;
                          return _buildStoryPages(documentSnapshot, active);
                        }
                        return Container();
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ));
  }

  _buildTagPage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Stories',
            style: TextStyle(
                color: BottleGreen,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                fontSize: 34),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Filters:',
            style: TextStyle(
                color: BottleGreen.withOpacity(0.8),
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                fontSize: 20),
          ),
          _buildButton('all stories'),
          _buildButton('favourites'),
          _buildButton('adventure'),
          _buildButton('personal'),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateNewStory(
                        storyMode: StoryModes.Adding,
                      )));
            },
            child: Container(
              decoration: BoxDecoration(
                color: BottleGreen,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.create,
                      color: White,
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Create New',
                      style: TextStyle(
                          color: White,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildStoryPages(DocumentSnapshot data, bool active) {
    final double blur = active ? 6 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreateNewStory(
              storyMode: StoryModes.Editing,
              documentSnapshot: data,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.only(top: top, bottom: 50, right: 10),
        decoration: BoxDecoration(
          color: White,
          boxShadow: [
            BoxShadow(
                color: BottleGreen.withOpacity(0.1),
                blurRadius: blur,
                offset: Offset(offset, offset)),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
              image: NetworkImage(
                data['img'],
              ),
              fit: BoxFit.cover),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              heroTag: data.id + 'delete',
              elevation: 20,
              backgroundColor: White,
              onPressed: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                String uid = sharedPreferences.get('uid');
                CollectionReference collectionRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('stories');
                collectionRef.doc(data.id).delete();
                pageController.jumpToPage(currentPage - 1);
              },
              child: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding:EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              data['title'],
                              style: TextStyle(
                                  color: White,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  fontSize: 28),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding:EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              data['description'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: White,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? BottleGreen : Colors.transparent;
    Color textColor = tag == activeTag ? White : Teal.withOpacity(0.5);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: GestureDetector(
        onTap: () => _queryDB(tag: tag),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              '#$tag',
              style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
