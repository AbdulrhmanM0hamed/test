# Authentication Feature - Clean Architecture Implementation

This implementation follows Clean Architecture principles with 3 layers and uses Cubit for state management.

## Architecture Overview

### Domain Layer (`lib/features/auth/domain/`)
- **Entities**: Core business objects (`User`, `LoginRequest`)
- **Repositories**: Abstract contracts (`AuthRepository`)
- **Use Cases**: Business logic (`LoginUseCase`)

### Data Layer (`lib/features/auth/data/`)
- **Models**: Data transfer objects (`UserModel`, `LoginRequestModel`)
- **Data Sources**: API communication (`AuthRemoteDataSource`)
- **Repository Implementation**: Concrete repository (`AuthRepositoryImpl`)

### Presentation Layer (`lib/features/auth/presentation/`)
- **Cubit**: State management (`AuthCubit`, `AuthState`)
- **Views**: UI components (`LoginView`, `LoginWrapper`)

## Usage Example

### 1. Initialize Dependencies in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/features/auth/presentation/view/login_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependency injection
  await DependencyInjection.init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      routes: {
        '/login': (context) => const LoginWrapper(),
        // other routes...
      },
      home: const LoginWrapper(),
    );
  }
}
```

### 2. Navigation to Login

```dart
// Navigate to login screen
Navigator.pushNamed(context, '/login');

// Or use the wrapper directly
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const LoginWrapper()),
);
```

## Features

✅ **Clean Architecture**: Separation of concerns with 3 distinct layers
✅ **Cubit State Management**: Reactive state management with BLoC pattern
✅ **Loading Indicator**: Custom progress indicator during API calls
✅ **Snackbar Notifications**: Success/error messages with custom styling
✅ **Token Management**: Automatic token storage and retrieval
✅ **Form Validation**: Email and password validation
✅ **Error Handling**: Comprehensive error handling with user-friendly messages
✅ **Dependency Injection**: Clean dependency management

## API Integration

The implementation integrates with your existing API:
- **Endpoint**: `https://eramostore.com/eramostore2025_backend/public/api/signin`
- **Method**: POST
- **Request Body**: `{"email": "user@example.com", "password": "password"}`
- **Response**: User data with token as provided in your example

## State Management

### AuthState Types:
- `AuthInitial`: Initial state
- `AuthLoading`: During login process (shows loading indicator)
- `AuthSuccess`: Login successful (navigates to home, shows success message)
- `AuthError`: Login failed (shows error snackbar)
- `AuthLoggedOut`: User logged out

### Usage in Other Screens:
```dart
// Check if user is logged in
final isLoggedIn = DependencyInjection.tokenStorageService.isLoggedIn;

// Get current user data
final userId = DependencyInjection.tokenStorageService.userId;
final userEmail = DependencyInjection.tokenStorageService.userEmail;

// Logout
context.read<AuthCubit>().logout();
```

## Customization

### Custom Loading Indicator
The loading indicator uses `CustomProgressIndicator` from your existing components.

### Custom Snackbar
Success/error messages use `CustomSnackbar` with your existing styling.

### Form Validation
Uses your existing `FormValidators` for email and password validation.

## Testing

To test the login flow:
1. Enter valid email and password
2. Observe loading indicator in center of screen
3. Check success snackbar and navigation to home
4. For errors, check error snackbar display

## Dependencies Required

Make sure these packages are in your `pubspec.yaml`:
```yaml
dependencies:
  flutter_bloc: ^8.1.3
  shared_preferences: ^2.2.2
  dio: ^5.3.2
```

## File Structure

```
lib/features/auth/
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   └── login_request.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       └── login_usecase.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   └── login_request_model.dart
│   ├── datasources/
│   │   └── auth_remote_data_source.dart
│   └── repositories/
│       └── auth_repository_impl.dart
└── presentation/
    ├── cubit/
    │   ├── auth_cubit.dart
    │   └── auth_state.dart
    └── view/
        ├── login_view.dart
        └── login_wrapper.dart
```

This implementation provides a robust, scalable, and maintainable authentication system following Clean Architecture principles.
