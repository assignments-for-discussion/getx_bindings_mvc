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

  void reset() {
    status.value = IntentStatus.none;
  }

  bool get isPending {
    return status.value == IntentStatus.pending;
  }

  bool get isDone {
    return status.value == IntentStatus.done;
  }

  bool get notYet {
    return status.value == IntentStatus.none;
  }

  void onFire(void Function(IntentStatus) listener) {
    status.listen((s) {
      if (isPending) {
        listener(s);
      }
    });
  }

  void onDone(void Function(IntentStatus) listener) {
    status.listen((s) {
      if (isDone) {
        listener(s);
      }
    });
  }
}
