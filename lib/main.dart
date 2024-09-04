import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:simple_todo_app/data/models/isar_todo.dart';
import 'package:simple_todo_app/data/repository/isar_todo_repo.dart';
import 'package:simple_todo_app/presentation/todo_cubit.dart';
import 'package:simple_todo_app/presentation/todo_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // get directory path for storing data
  final dir = await getApplicationDocumentsDirectory();

  // open isar database
  final isar = await Isar.open([TodoIsarSchema], directory: dir.path);

  final isarTodoRepo = IsarTodoRepo(isar);
  runApp(MyApp(
    isarTodoRepo: isarTodoRepo,
  ));
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TodoPage();
      },
      routes: const <RouteBase>[],
    ),
  ],
);

class MyApp extends StatelessWidget {
  final IsarTodoRepo isarTodoRepo;
  const MyApp({super.key, required this.isarTodoRepo});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(isarTodoRepo),
      child: ShadApp.router(
        title: 'Flutter Demo',
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: ShadThemeData(
            brightness: Brightness.light,
            colorScheme: const ShadStoneColorScheme.light(),
            textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.inter)),
        routerConfig: _router,
      ),
    );
  }
}
