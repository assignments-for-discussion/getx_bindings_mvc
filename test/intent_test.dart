import 'package:getx_bindings_mvc/intent.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'firing an intent invokes the listener and marks itself pending',
    () {
      final testIntentionFire = Intent();
      bool wasFired = false;
      testIntentionFire.onFire((p0) {
        wasFired = true;
      });
      testIntentionFire.fire();
      expect(testIntentionFire.isPending, equals(true));
      expect(testIntentionFire.isDone, equals(false));
      expect(wasFired, equals(true));
    },
  );
  test(
    'when intent is done, it invokes the listener and becomes not-pending',
    () {
      final testIntentionDone = Intent();
      bool wasDone = false;
      testIntentionDone.onDone((p0) {
        wasDone = true;
      });
      testIntentionDone.done();
      expect(testIntentionDone.isPending, equals(false));
      expect(testIntentionDone.isDone, equals(true));
      expect(wasDone, equals(true));
    },
  );
}
