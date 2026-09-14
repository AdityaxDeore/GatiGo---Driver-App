import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pink_auto/core/storage/session_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('SessionStorage persists login and registration status', () async {
    await SessionStorage.init();
    expect(SessionStorage.isLoggedIn(), isFalse);
    expect(SessionStorage.isDriverRegistered(), isFalse);

    // Perform login with registration approved
    await SessionStorage.login('test-token-123', isRegistered: true);
    expect(SessionStorage.isLoggedIn(), isTrue);
    expect(SessionStorage.isDriverRegistered(), isTrue);
    expect(SessionStorage.getAuthToken(), 'test-token-123');

    // Simulate app restart by re-initializing SessionStorage from SharedPreferences
    await SessionStorage.init();
    expect(SessionStorage.isLoggedIn(), isTrue);
    expect(SessionStorage.isDriverRegistered(), isTrue);
    expect(SessionStorage.getAuthToken(), 'test-token-123');

    // Logout and verify persistence cleared
    await SessionStorage.logout();
    expect(SessionStorage.isLoggedIn(), isFalse);
    expect(SessionStorage.isDriverRegistered(), isFalse);

    // Simulate restart again
    await SessionStorage.init();
    expect(SessionStorage.isLoggedIn(), isFalse);
    expect(SessionStorage.isDriverRegistered(), isFalse);
  });

  test('SessionStorage persists verification pending and driver approval', () async {
    await SessionStorage.init();
    await SessionStorage.login('token-abc', isRegistered: false);
    expect(SessionStorage.isLoggedIn(), isTrue);
    expect(SessionStorage.isDriverRegistered(), isFalse);
    expect(SessionStorage.isVerificationPending(), isFalse);

    // Driver submits registration
    await SessionStorage.submitForVerification(
      name: 'Sunita Sharma',
      phone: '+91 98765 43210',
      vehicleNumber: 'KA 01 EQ 4521',
    );
    expect(SessionStorage.isVerificationPending(), isTrue);
    expect(SessionStorage.getDriverName(), 'Sunita Sharma');

    // Simulate restart - should remain pending
    await SessionStorage.init();
    expect(SessionStorage.isVerificationPending(), isTrue);
    expect(SessionStorage.isDriverRegistered(), isFalse);

    // Admin / Mock approves driver
    await SessionStorage.approveDriver();
    expect(SessionStorage.isDriverRegistered(), isTrue);
    expect(SessionStorage.isVerificationPending(), isFalse);

    // Simulate restart - should directly be approved
    await SessionStorage.init();
    expect(SessionStorage.isLoggedIn(), isTrue);
    expect(SessionStorage.isDriverRegistered(), isTrue);
    expect(SessionStorage.isVerificationPending(), isFalse);
  });

  test('SessionStorage persists autoType correctly', () async {
    await SessionStorage.init();
    expect(SessionStorage.getAutoType(), 'Pink Auto');

    // Register with Normal Auto
    await SessionStorage.submitForVerification(
      name: 'Sunita Sharma',
      phone: '+91 98765 43210',
      vehicleNumber: 'KA 01 EQ 4521',
      autoType: 'Normal Auto',
    );
    expect(SessionStorage.getAutoType(), 'Normal Auto');

    // Simulate restart
    await SessionStorage.init();
    expect(SessionStorage.getAutoType(), 'Normal Auto');
  });
}
