import 'package:fitnesscompanion/notifiers/date_of_reg_notifier.dart';
import 'package:fitnesscompanion/notifiers/target_cals_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/loginregister_screen.dart';
import 'screens/root_screen.dart';
import 'screens/user_details_creation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Companion',
      theme: NeumorphicThemeData(
        accentColor: Colors.pink,
        baseColor: Colors.white,
      ),
      home: StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder(
              initialData: snapshot.data,
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshotUser) {
                if (snapshotUser.data != null) {
                  if (snapshotUser.data.displayName != null &&
                      snapshotUser.data.displayName != '') {
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider<TargetCalsNotifier>(
                            create: (_) => TargetCalsNotifier()),
                        ChangeNotifierProvider<DateOfRegNotifier>(
                            create: (_) => DateOfRegNotifier()),
                      ],
                      child: Root(),
                    );
                  }
                }
                return UserDetailsCreation();
              },
            );
          } else {
            return LoginRegister();
          }
        },
      ),
    );
  }
}
