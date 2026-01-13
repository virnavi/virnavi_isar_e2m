import 'package:example/data/database/dao_impl/note_dao_impl.dart';
import 'package:example/data/database/dao_impl/user_dao_impl.dart';
import 'package:example/data/database/database.dart';
import 'package:example/ui/home/cubits/note/note_cubit.dart';
import 'package:example/ui/home/cubits/user/user_cubit.dart';
import 'package:example/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Database.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NoteCubit(NoteDaoImpl())),
        BlocProvider(create: (context) => UserCubit(UserDaoImpl())),
      ],
      child: MaterialApp(
        title: 'Virnavi Isar E2M',

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
