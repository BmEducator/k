import 'dart:io';

import 'package:bmeducators/Screens/admin/myTiktoks.dart';
import 'package:bmeducators/Screens/homeScreen.dart';
import 'package:bmeducators/mainScreen.dart';
import 'package:bmeducators/services_Screen/mobileWebOptionScreen.dart';
import 'package:bmeducators/services_Screen/notificationDetailScreen.dart';
import 'package:bmeducators/students/login_Screen.dart';
import 'package:bmeducators/students/main_menuScreen.dart';
import 'package:bmeducators/utilis/notifi_service.dart';
import 'package:bmeducators/utilis/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Screens/whiteboard/Drawing_page1.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
bool isNotification= false;
// late final FirebaseMessaging _messaging;
String message = "";
String name = "";



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: FirebaseOptions(
      // apiKey: "AIzaSyCZqKqpjp1fbCCra8dO5BzYKS4ROW4JLq8",
      // authDomain: 'bmeducator-61e1e.firebaseapp.com',
      // databaseURL: 'https://bmeducator-61e1e-default-rtdb.firebaseio.com', // IMPORTANT!
      // storageBucket: 'bmeducator-61e1e.appspot.c',
      // appId:  "1:470670777580:web:036dd3f9a5127601c259c9",
      // messagingSenderId: "470670777580",
      // projectId: "bmeducator-61e1e")
  );

  listenFCM();
  FirebaseMessaging.onBackgroundMessage((_firebaseMessagingBackgroundHandler));
  requestPermission();
  loadFCM();
  RemoteMessage? initialMessage =
  await FirebaseMessaging.instance.getInitialMessage();

  print(initialMessage?.data.isEmpty);
  print("--------");
  if(initialMessage?.data['screen'] == "promotion"){
    print(initialMessage?.data['body']);
    message = initialMessage?.data['body'];
    isNotification = true;
  }
  else if(initialMessage?.data['status'] == "review"){
     print("gorReviewed");
  }

  // FirebaseDatabase.instance.setPersistenceEnabled(true);
  // FirebaseDatabase.instance.ref().keepSynced(true);


  runApp( MyApp());
}
void loadFCM() async {
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
        ledColor:Colors.white
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var IOS = new DarwinInitializationSettings();

     AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
     InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: IOS
    );

    //
    // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    // await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    // final didNotificationLaunchApp =
    //     notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

    // if (didNotificationLaunchApp) {
    //   var payload = notificationAppLaunchDetails!.notificationResponse?.payload.toString();
    //   selectNotification(payload);
    //
    // }

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (details) {
      print(details.payload);
      // Click Notification Event Here
    },);

    flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails().then((value) {
      print(value?.notificationResponse?.payload.toString());
    });
    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    // String? token = await _messaging.getToken();
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
  } else {
  }
}

void listenFCM() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("liste om_message");
    navigatorKey.currentState?.push( MaterialPageRoute(builder: (context) => notificationDetailScreen(
      message: message.data['body'], name: message.data['name'],)));
    print(message.data);
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        payload: "${message.data['body']}-${message.data['screen']}=${message.data['name']}-${message.data['screen']}",
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              "fullstop",
              "fullstop",
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: '@mipmap/ic_launcher',
              color: Colors.lightBlue,
              playSound: true,
              priority: Priority.high,
              enableVibration: true,
              importance: Importance.high
          ),
          iOS: DarwinNotificationDetails(
            subtitle: "BM_Educators",
            presentSound: true,
            presentBadge: true
          )
        ),
      );

    }

  });
  FirebaseMessaging.onMessageOpenedApp.listen((message ) {
    print("onMessageOpenedApp");
    print( message.data['body']);
    print( message.data['screen']);

    if(message.data['screen']  == "promotion"){
      navigatorKey.currentState?.push( MaterialPageRoute(builder: (context) => notificationDetailScreen(message: message.data['body'], name: message.data['name'],)));


      String title = message.data['screen'];
      // navigatorKey.currentState?.push(FadeRoute(
      //     page: someReviewOAD( adid: title,)));
    }
    else if(message.data['status']== "reviewApp"){
        if (Platform.isAndroid || Platform.isIOS) {
        final appId = Platform.isAndroid ? 'com.maan.fullstop' : 'YOUR_IOS_APP_ID';
        final url = Uri.parse(
          Platform.isAndroid
              ? "market://details?id=$appId"
              : "https://apps.apple.com/app/id$appId",
        );
        launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      }

    }}
  );
}

void selectNotification(String? payload) async {
  print("select otificatii");
  if (payload != null) {
// Here you can check notification payload and redirect user to the respective screen
    String firstpart =payload.substring(0,payload.indexOf("="));
    String secongpart =payload.substring(payload.indexOf("=")+1,payload.length);

    print(payload);

    String message = firstpart.substring(0,firstpart.indexOf("-"));
    String screen = firstpart.substring(firstpart.indexOf("-")+1,firstpart.length);
    String name = secongpart.substring(0,secongpart.indexOf("-"));
    String url = secongpart.substring(secongpart.indexOf("-")+1,secongpart.length);

    print(payload);
    print("-----");
    if(screen == "promotion"){
      print("kjlkj");
      navigatorKey.currentState?.push( MaterialPageRoute(builder: (context) => notificationDetailScreen(message: message, name: name,)));

    }
    else if(message == "promotion"){


    }
}}


class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return  isNotification?
              notificationDetailScreen(message: message, name: "zppb"):
              SplashScreen(type: "home");
              // MediaQuery.of(context).size.width < 750 ? mobileWebOptionScreen():
              // homeScreen_web();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }

          // means connection to future hasnt been made yet

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // return SplashScreen(type: "login");
          // return MediaQuery.of(context).size.width < 750 ? mobileWebOptionScreen()
          // :homeScreen_web();
          return SplashScreen(type: "login");
        },
      ),
    );
  }
}

