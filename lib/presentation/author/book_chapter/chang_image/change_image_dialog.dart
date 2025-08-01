import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_test/main.dart';
import 'package:riverpod_test/presentation/author/book_chapter/chang_image/state/pick_provider.dart';
import 'package:riverpod_test/presentation/author/home/state/book_provider.dart';
import 'package:riverpod_test/theme/app_text_style.dart';

class ChangeImageDialog extends ConsumerStatefulWidget {
  const ChangeImageDialog(
      {super.key, required this.bookId, required this.imageUrl});

  final int bookId;
  final String? imageUrl;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeImageDialogState();
}

class _ChangeImageDialogState extends ConsumerState<ChangeImageDialog> {
  @override
  Widget build(BuildContext context) {
    ref.listen(changeProvider(widget.bookId), (prev, next) {
      next.when(
          data: (msg) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(msg.toString())));

            ref.read(pickProvider.notifier).clear();
            ref.read(bookfetchProvider(6).notifier).fetchAll();
            appnavigator.pop();
          },
          error: (error, _) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
            ref.read(pickProvider.notifier).clear();
          },
          loading: () {});
    });

    final pickState = ref.watch(pickProvider);

    final picked = pickState;

    bool hasCurrentImage =
        widget.imageUrl != null && widget.imageUrl!.isNotEmpty;

    bool hasPicked = picked != null && picked.path.isNotEmpty;

    dynamic bg = hasPicked
        ? FileImage(File(picked.path))
        : hasCurrentImage
            ? NetworkImage(widget.imageUrl!)
            : AssetImage('assets/images/c5.png');

    final changeState = ref.watch(changeProvider(widget.bookId));

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.3),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: bg,
                  fit: BoxFit.cover,
                  width: 180,
                  height: 170,
                )),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color: Colors.black),
                        backgroundColor: Colors.grey),
                    onPressed: () {
                      ref
                          .read(pickProvider.notifier)
                          .pickImage(ImageSource.gallery);
                    },
                    child: Text(
                      'Gallery',
                      style: 15.sp(color: Colors.white),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        side: BorderSide(color: Colors.black),
                        backgroundColor: Colors.grey),
                    onPressed: () {
                      ref
                          .read(pickProvider.notifier)
                          .pickImage(ImageSource.camera);
                    },
                    child: Text(
                      'Camera',
                      style: 15.sp(color: Colors.white),
                    )),
                !changeState.isLoading
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            side: BorderSide(color: Colors.black),
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          ref
                              .read(changeProvider(widget.bookId).notifier)
                              .changeImage(picked!);
                        },
                        child: Text(
                          'Upload',
                          style: 15.sp(color: Colors.white),
                        ))
                    : Center(
                        child: SpinKitDualRing(
                          color: Colors.yellow,
                          size: 20,
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
