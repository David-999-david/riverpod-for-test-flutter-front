import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/data/user/model/author_model.dart';
import 'package:riverpod_test/presentation/user_home/state/author_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class UserHome extends ConsumerWidget {
  const UserHome({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchAuthorState = ref.watch(authorListProvider);
    final authorList = fetchAuthorState.value;

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 150,
            child: fetchAuthorState.isLoading
                ? SpinKitDualRing(
                    color: Colors.yellow,
                    size: 20,
                  )
                : authorList != null && authorList.isNotEmpty
                    ? ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 10,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: authorList.length,
                        itemBuilder: (context, index) {
                          final author = authorList[index];
                          return authorCircle(author);
                        },
                      )
                    : Text('There is no authors for show'),
          )
        ],
      ),
    ));
  }
}

Widget authorCircle(AuthorModel author) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, left: 10),
    child: Column(
      children: [
        Container(
          height: 50,
          width: 50,
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.pinkAccent),
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                  image: AssetImage('assets/images/cool4.png'),
                  fit: BoxFit.cover)),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          author.name,
          style: 12.sp(),
        )
      ],
    ),
  );
}
