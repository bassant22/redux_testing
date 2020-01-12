import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:redux_testing/trans/translations.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_testing/redux/app/app_state.dart';
import 'package:redux_testing/redux/store.dart';
import 'package:flutter/foundation.dart';
import 'package:redux_testing/features/settings/settings_option.dart';
import 'package:redux_testing/features/settings/settings_option_page.dart';
import 'package:redux_testing/features/settings/text_scale.dart';
import 'package:redux_testing/features/settings/theme.dart';
import 'package:redux_testing/data/db/database_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'data/model/nowplaying_data.dart';
import 'package:alice/alice.dart';

import 'features/now_playing/now_playing_view.dart';

Alice alice = Alice(showNotification: true);

Future<Null> main() async {
  var store = await createStore();
  runApp(MyApp(store));
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(FavioriteAdapter(),0);
 // print('............................... Dir is ${appDocumentDir.path}');
}


class MyApp extends StatefulWidget {
  final Store<AppState> store;

  MyApp(this.store);

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SettingsOptions _options;

  @override
  void initState() {
    Hive.openBox('favorite');
    super.initState();
    DatabaseClient();
    _options = new SettingsOptions(
      theme: AppTheme().appTheme,
      textScaleFactor: appTextScaleValues[0],
      platform: defaultTargetPlatform,
    );
    SharedPreferences.getInstance().then((prefs) {
      var isDark = prefs.getBool("isDark") ?? false;
      if (isDark) {
        AppTheme.configure(ThemeName.DARK);
        setState(() {
          _options = _options.copyWith(theme: AppTheme().appTheme);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: widget.store,
        child: MaterialApp(
          title: 'redux_testing',
          debugShowCheckedModeBanner: false,
          navigatorKey: alice.getNavigatorKey(),
          routes: _routes(),
         // home: FavoriteMovieHive(),
          theme: ThemeData.dark(),
          builder: (BuildContext context, Widget child) {
            return new Directionality(
              textDirection: _options.textDirection,
              child: _applyTextScaleFactor(child),
            );
          },
          localizationsDelegates: [
            const TranslationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('zh', 'CH'),
            const Locale('en', 'US'),
          ],
        ));
  }


  Widget _applyTextScaleFactor(Widget child) {
    return new Builder(
      builder: (BuildContext context) {
        return new MediaQuery(
          data: MediaQuery.of(context).copyWith(
                textScaleFactor: _options.textScaleFactor.scale,
              ),
          child: child,
        );
      },
    );
  }

  void _handleOptionsChanged(SettingsOptions newOptions) {
    setState(() {
      _options = newOptions;
    });
  }

  Map<String, WidgetBuilder> _routes() {
    return <String, WidgetBuilder>{
      "/settings": (_) => SettingsOptionsPage(
            options: _options,
            onOptionsChanged: _handleOptionsChanged,
          ),
      "/": (_) => Now_PlayingView(),
    };
  }
}