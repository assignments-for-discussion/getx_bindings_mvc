import 'package:get/get.dart';

enum IntentStatus { none, pending, done }

class Intent {
  var status = IntentStatus.none.obs;

  void fire() {
    status.value = IntentStatus.pending;
  }

  void done() {
    status.value = IntentStatus.done;
  }

  bool get isPending {
    return status.value == IntentStatus.pending;
  }

  bool get isDone {
    return status.value == IntentStatus.done;
  }

  void onFire(void Function(IntentStatus) listener) {
    status.listen((s) {
      if (isPending) {
        listener(s);
      }
    });
  }
}
