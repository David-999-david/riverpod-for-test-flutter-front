import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:riverpod_test/presentation/auth/register/register_screen.dart';
import 'package:riverpod_test/presentation/setting/upgrade_author/fill_secret/state/secret_check_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class FillSecret extends ConsumerStatefulWidget {
  const FillSecret({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FillSecretState();
}

class _FillSecretState extends ConsumerState<FillSecret> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  final TextEditingController secret = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(secretProvider, (prev, next) {
      next.when(
          data: (msg) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg.toString())));
          },
          error: (error, _) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          },
          loading: () {});
    });

    final secretState = ref.watch(secretProvider);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      child: Form(
          key: key,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 25, left: 10, right: 10, bottom: 5),
                child: textfieldPsw(
                    secret, "Please Enter Secret-key", 'Secret-key'),
              ),
              secretState.isLoading
                  ? SpinKitDualRing(
                      color: Colors.yellow,
                      size: 20,
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: Colors.blue)),
                      onPressed: () {
                        ref
                            .read(secretProvider.notifier)
                            .checkSecret(secret.text.trim());
                      },
                      child: Text(
                        'Confirm',
                        style: 12.sp(),
                      ))
            ],
          )),
    );
  }
}
