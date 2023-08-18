import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotinda/widget/auth_model.dart';
import 'package:spotinda/widget/boarding.dart';
import 'Dimensions/dimensions.dart';
import 'Screens/callback.dart';
import 'Screens/login.dart';
import 'Screens/mainlayout.dart';
import 'Screens/getstarted.dart';

void main() {
  runApp(MyApp(),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorkey = GlobalKey<NavigatorState>();



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create: (context)=>AuthModel(),
      child: MaterialApp(
        navigatorKey: MyApp.navigatorkey,
        debugShowCheckedModeBanner: false,
        title: 'Spotinder',
        theme: ThemeData(
            backgroundColor: Colors.black,
            inputDecorationTheme: const InputDecorationTheme(
              border: Dimensions.outlineborder,
              focusColor: Colors.white,
              focusedBorder: Dimensions.focusborder,
              errorBorder: Dimensions.errorborder,
              floatingLabelStyle: TextStyle(color: Colors.white,),
              prefixIconColor: Colors.black,
            ),
            scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme:BottomNavigationBarThemeData(
                backgroundColor:Colors.black,
                selectedItemColor: Colors.white,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                unselectedItemColor: Colors.grey.shade500,
                elevation: 10,
                type: BottomNavigationBarType.fixed
            )
        ),

        initialRoute: "/login",
        routes: {

          //initial page.Login page
          "/":(context)=>  GetStarted(),
          "/login":(context)=> SpotifyLoginButton(),
          "/boarding":(context)=>  Boarding(),
          "/dashboard":(context)=>MainLayout(),
          // '/callback/': (context) => CallbackPage(),
          // "library":(context)=>LoginScreen(),
        },
      ),
    );
  }
}
