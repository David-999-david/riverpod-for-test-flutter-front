import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_test/presentation/author/home/add/state/pick_image_notifier.dart';

final pickimageProvider = StateNotifierProvider<PickImageNotifier, XFile?>(
    (ref) => PickImageNotifier());
