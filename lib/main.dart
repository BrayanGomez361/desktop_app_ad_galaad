
import 'package:ad_galaad_app/pages/calendar_page.dart';
import 'package:ad_galaad_app/pages/weeks_month_page.dart';
import 'package:ad_galaad_app/pages/splashScreen.dart';
import 'package:ad_galaad_app/pages/users_page.dart';
import 'package:ad_galaad_app/providers/local_constants_provider.dart';
import 'package:ad_galaad_app/providers/local_privileges_provider.dart';
import 'package:ad_galaad_app/providers/local_users_provider.dart';
import 'package:ad_galaad_app/providers/local_weeks_provider.dart';
import 'package:ad_galaad_app/providers/local_worshipServices_provider.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final prefs = await SharedPreferences.getInstance();
  //await prefs.remove('constantes_locales_v1');  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocalStorageProvider()),
        ChangeNotifierProvider(create: (_) => LocalWeeksStorageProvider() ),
        ChangeNotifierProvider(create: (_) => LocalPrivilegeStorageProvider()),
        ChangeNotifierProvider(create: (_) => LocalWorshipServicesProvider()),
        ChangeNotifierProvider(create: (_) => LocalConstantsProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'Asamblea de Dios Galaad Desktop App',
      themeMode: ThemeMode.dark,
      theme: FluentThemeData(
        fontFamily: '.SF Pro Text',
        typography: Typography.raw(
          caption: const TextStyle(fontSize: 12, letterSpacing: -0.08),
          body: const TextStyle(fontSize: 14, letterSpacing: -0.15),
          subtitle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          title: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _topIndex = 1; // Seleccionado "Sistema" por defecto

  // Clave global para controlar el NavigationView externamente
  final GlobalKey<NavigationViewState> _navViewKey = GlobalKey<NavigationViewState>();

  // Umbral de ancho en píxeles para colapsar la barra lateral
  static const double _thresholdWidth = 800.0;

  // Llaves de navegación independientes para conservar el historial por pestaña
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < _thresholdWidth;

    return NavigationView(
      key: _navViewKey,
      titleBar: TitleBar(
        title: Row(
          spacing: 8.0,
          children: [
            Icon(FluentIcons.pc1),
            Text('Aplicación de escritorio'),
          ],
        ),
        icon: isSmallScreen 
          ? IconButton(
              icon: Icon(FluentIcons.global_nav_button), 
              onPressed: () {
                  _navViewKey.currentState?.togglePane();
                },
            ) 
          : null,
      ),
      pane: NavigationPane(
        size: NavigationPaneSize(openMaxWidth: 250) ,
        selected: _topIndex,
        onChanged: (index) => setState(() => _topIndex = index),
        displayMode: isSmallScreen
            ? PaneDisplayMode.minimal  // Oculta completamente el menú lateral
            : PaneDisplayMode.expanded,
        toggleButton: null,
        items: [

          PaneItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Admin', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('correo_electronico@gmail.com', style: TextStyle(fontSize: 12)),
              ],
            ),
            body: _buildTabNavigator(2, const Center(child: Text('Perfil'))),
          ),
          PaneItem(enabled: false),

          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('Inicio'),
            body: _buildTabNavigator(0, const Center(child: Text('Inicio'))),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.doc_library),
            title: const Text('Programas de cultos'),
            body: _buildTabNavigator(1, const MonthlyWeeksPage ()),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.calendar),
            title: const Text('Calendario de actividades'),
            body: _buildTabNavigator(2, CalendarPage() ),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Configuraciones'),
            body: _buildTabNavigator(3, const Center(child: Text('Constantes'))),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.group),
            title: const Text('Usuarios'),
            body: _buildTabNavigator(4, const UsuariosPage()),
          ),
        ],
      ),
    );
  }

  // Permite que cada sección tenga su propio historial de rutas
  Widget _buildTabNavigator(int index, Widget initialPage) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) => initialPage,
        );
      },
    );
  }
}