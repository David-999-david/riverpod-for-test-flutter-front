import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/setting/upgrade_author/fill_secret/fill_secret.dart';

import 'package:riverpod_test/presentation/setting/state/user_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class Setting extends ConsumerStatefulWidget {
  const Setting({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingState();
}

class _SettingState extends ConsumerState<Setting> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     ref.read(userProvider.notifier).getInfo();
  //   });
  // }

  Future<dynamic> settingCall(String setting) async {
    switch (setting) {
      case 'Author':
        return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              titlePadding: EdgeInsets.only(top: 5),
              contentPadding:
                  EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 3),
              backgroundColor: Color(0xff3f2b96),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text(
                      'For upgrade to Author,\nplease contect us for secret key',
                      textAlign: TextAlign.center,
                      style: 16.sp(color: Colors.white),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        appnavigator.pop();
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      )),
                ],
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                            colors: [Color(0xffa8c0ff), Color(0xff3f2b96)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: FillSecret()),
              ),
            );
          },
        );
      case ('Log out'):
        await ref.read(logoutProvider.notifier).logOut();
        ref.invalidate(userProvider);
      default:
        return Future.value();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfoState = ref.watch(userProvider);
    final user = userInfoState.value;

    final logoutState = ref.watch(logoutProvider);
    return Scaffold(
        body: Container(
      color: Color(0xff322E3E),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: userInfoState.isLoading
                  ? SpinKitDualRing(
                      color: Colors.yellow,
                      size: 25,
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/cool3.png',
                          fit: BoxFit.cover,
                        ),
                        DecoratedBox(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                              Color(0xff614385).withOpacity(0.2),
                              Color(0xff516395).withOpacity(0.3)
                            ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter))),
                        Positioned(
                            bottom: 20,
                            left: 20,
                            child: Text(
                              user!.name.toUpperCase(),
                              style: 26.sp(color: Colors.white),
                            ))
                      ],
                    ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              _settingItem(
                'Upgrade For Author',
                onTap: () {
                  settingCall('Author');
                },
              ),
              SizedBox(
                height: 15,
              ),
              logoutState.isLoading
                  ? SpinKitDualRing(
                      color: Colors.yellow,
                      size: 20,
                    )
                  : _settingItem('Log out', onTap: () {
                      settingCall('Log out');
                    }),
              SizedBox(
                height: 15,
              ),
              _settingItem('name'),
              SizedBox(
                height: 15,
              ),
              _settingItem('name'),
              SizedBox(
                height: 15,
              ),
              _settingItem('name'),
              SizedBox(
                height: 15,
              ),
              _settingItem('name'),
              SizedBox(
                height: 15,
              ),
              _settingItem('name'),
              SizedBox(
                height: 15,
              ),
              _settingItem('name'),
              SizedBox(
                height: 15,
              ),
              _settingItem('name'),
              SizedBox(
                height: 15,
              ),
              _settingItem('name'),
            ])),
          )
        ],
      ),
    ));
  }
}

Widget _settingItem(String name, {VoidCallback? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff403B4A), Color(0xffE7E9BB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: 17.sp(color: Colors.white),
          )
        ],
      ),
    ),
  );
}
