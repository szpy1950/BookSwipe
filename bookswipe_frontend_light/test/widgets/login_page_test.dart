// test/login_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:bookswipe/services/api_service.dart';
import 'package:bookswipe/services/auth_service.dart';
import 'package:bookswipe/controllers/auth_controller.dart';
import 'login_page_test.mocks.dart';

// Generate mock classes
@GenerateMocks([ApiService, AuthService])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockApiService mockApiService;
  late MockAuthService mockAuthService;
  late AuthController authController;

  setUp(() {
    mockApiService = MockApiService();
    mockAuthService = MockAuthService();
    authController = AuthController(
        apiService: mockApiService,
        authService: mockAuthService
    );
  });

  test('successful login returns success and token', () async {
    // Setup mock response
    when(mockApiService.login('testuser', 'password123')).thenAnswer(
            (_) async => {
          'success': true,
          'token': 'fake_token',
          'user': {'id': 1, 'username': 'testuser'}
        }
    );

    // Perform login
    final result = await authController.login('testuser', 'password123');

    // Verify success
    expect(result['success'], true);
    expect(result['token'], 'fake_token');

    // Verify that login was called exactly once with correct parameters
    verify(mockApiService.login('testuser', 'password123')).called(1);
  });

  test('failed login throws exception', () async {
    // Setup mock to simulate failed login
    when(mockApiService.login('wronguser', 'wrongpass')).thenAnswer(
            (_) async => {
          'success': false,
          'message': 'Invalid credentials'
        }
    );

    // Verify that login throws an exception
    expect(
          () => authController.login('wronguser', 'wrongpass'),
      throwsException,
    );
  });
}