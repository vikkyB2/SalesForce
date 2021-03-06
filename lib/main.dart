import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import './plugins/plugins.dart';

import './dao/screenobj.dart';
import './staticdata/langcontainer/langcontainer.dart';
import './Queries/processQueries.dart';

import './themes/themechanger.dart';

import './screens/route_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool userPresent = false;
  checkUser() async {
    Map<String, dynamic> usrrslt = await Plugins.instance.excecute({
      'reqId': "SQL",
      'query': 'SELECT * FROM TB_USERS',
      'entity': "Customer"
    });
    if (usrrslt['status'] != false && usrrslt['resp'].length > 0) {
     userPresent = true;
    }
  }

  @override
  Widget build(BuildContext context) { 
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            theme:  light,
            initialRoute: userPresent ? '/login': '/',
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String lang = "en_us";
  bool loggedin = true;
  changeLanguage() {
    String tlang = "en_us";
    if (lang == "en_us") {
      tlang = "tm";
    } else {
      tlang = "en_us";
    }
    setState(() {
      lang = tlang;
    });
  }

  launchLogin(context) {
    final ScreenObj sccrobj = ScreenObj("", lang, {});
    setState(() {});
    Navigator.of(context).pushNamed('/login', arguments: sccrobj);
  }

  List images = [
    "assets/images/ht1.jpeg",
    "assets/images/ht2.jpeg",
    "assets/images/nt1.jpeg"
  ];
  checkTablePresent() async {
    await ProcessQueries().checktablePresent();
    checkUser(context);
  }

  checkUser(context) async {
    Map<String, dynamic> usrrslt = await Plugins.instance.excecute({
      'reqId': "SQL",
      'query': 'SELECT * FROM TB_USERS',
      'entity': "Customer"
    });
    if (usrrslt['status'] != false && usrrslt['resp'].length > 0) {
      launchLogin(context);
    }else{
      setState(() {
        loggedin = false;
      });
    }
  }

  loadContainerData(){
    if(loggedin){
      return Container();
    }else{
      return Column(
            children: <Widget>[
              Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.fill,
                  );
                },
                itemHeight: 300,
                autoplay: true,
                itemWidth: MediaQuery.of(context).size.width * 1,
                layout: SwiperLayout.STACK,
                itemCount: images.length,
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  langData["LN_WEL_SF"][lang],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      launchLogin(context);
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      height: 60,
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  color: Theme.of(context).primaryColor,
                                  child: Text(
                                    langData["LN_PROCD_SF"][lang],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Theme.of(context).accentColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    checkTablePresent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/shopfx.jpeg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Color.fromRGBO(255, 255, 255, 0.3), BlendMode.modulate)),
          ),
          child: loadContainerData(),
        ));
  }
}
