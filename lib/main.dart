import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouse_ble/bloc/bluetooth/bluet-bloc.dart';
import 'package:mouse_ble/bloc/navigation/navigation_bloc.dart';
import 'package:mouse_ble/route/navigation_provider.dart';
import 'package:mouse_ble/util/inherited_appbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BleBloc bloc = BleBloc();
    return MaterialApp(
        title: 'bleMouse',
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        home: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => bloc,
              ),
              BlocProvider(
                create: (context) => NavigationBloc(bloc),
              )
            ],
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: const Text("bloctest"),
                actions: [
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Text('My Account'),
                        ),
                        const PopupMenuItem<int>(
                          value: 1,
                          child: Text('Settings'),
                        ),
                        const PopupMenuItem<int>(
                          value: 2,
                          child: Text('Logout'),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        print('My account menu is selected.');
                      } else if (value == 1) {
                        print('Settings menu is selected.');
                      } else if (value == 2) {
                        print('Logout menu is selected.');
                      }
                    },
                  )
                ],
              ),
              body: const Column(
                children: [NavigationProvider()],
              ),
            )));

    return InheritedAppbar(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("bloctest"),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('My Account'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Settings'),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text('Logout'),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  print('My account menu is selected.');
                } else if (value == 1) {
                  print('Settings menu is selected.');
                } else if (value == 2) {
                  print('Logout menu is selected.');
                }
              },
            )
          ],
        ),
        child: Scaffold(
          body: const Column(
            children: [NavigationProvider()],
          ),
        ));
  }
}
