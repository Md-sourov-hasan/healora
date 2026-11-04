# Flutter App Architecture Guide

## 📱 Project Overview

This Flutter application follows a **clean architecture pattern** with **GetX state management**, implementing a modular and scalable structure for building responsive, maintainable UI screens.

## 🏗️ Architecture Layers

### 1. **Core Layer** (`/lib/core/`)
Contains shared utilities, common widgets, constants, and configurations.

### 2. **Features Layer** (`/lib/features/`)
Contains feature-specific modules organized by domain (authentication, home, etc.).

### 3. **Routes Layer** (`/lib/routes/`)
Centralized navigation management using `go_router` (GetX is strictly kept for State Management and Dependency Injection).

---

## 📂 Project Structure

```
lib/
├── app.dart                 # Main app configuration
├── main.dart               # App entry point
├── core/                   # Shared core functionality
│   ├── common/
│   │   ├── styles/
│   │   │   └── global_text_style.dart    # Centralized text styling
│   │   └── widgets/
│   │       ├── common_background.dart    # Reusable background system
│   │       ├── customize_filled_button.dart
│   │       ├── customize_unfilled_button.dart
│   │       └── custom_text_field.dart    # Common text field component
│   ├── utils/
│   │   ├── sizer.dart                   # Custom responsive utility
│   │   ├── connectivity_service.dart    # Internet connectivity checker
│   │   └── constants/
│   │       └── colors.dart              # Color constants
│   └── models/                          # Shared data models
├── features/                            # Feature modules
│   ├── authentication/
│   │   ├── controllers/
│   │   │   ├── login_controller.dart
│   │   │   ├── login_form_controller.dart
│   │   │   ├── forgot_password_controller.dart
│   │   │   └── check_email_controller.dart
│   │   └── presentation/
│   │       └── screens/
│   │           ├── login_screen.dart
│   │           ├── login_form_screen.dart
│   │           ├── forgot_password_screen.dart
│   │           └── check_email_screen.dart
│   ├── splash_screen/
│   │   ├── controller/
│   │   │   └── splash_screen_controller.dart
│   │   └── screen/
│   │       └── splash_screen.dart
│   └── home/                           # Future home features
└── routes/
    └── app_routes.dart                 # Navigation configuration
```

---

## 🎨 Design System Implementation

### **1. Responsive Design with Custom Sizer (MediaQuery)**

**Strategy**: We strictly optimize for mobile phones using `Sizer`. Tablets and Desktops are blocked via a `ResponsiveWrapper` that displays an unsupported screen, keeping the mobile code clean and preventing layout stretching.

**File**: `/lib/core/utils/sizer.dart`

```dart
import 'package:flutter/material.dart';

class Sizer {
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _blockSizeHorizontal;
  static late double _blockSizeVertical;
  // We removed textScaleFactor as it is deprecated in Flutter 3.16+
  // and replaced by TextScaler, but it wasn't being used in .sp anyway.

  static void init(BuildContext context) {
    // Use sizeOf instead of of(context).size for performance (prevents unnecessary rebuilds)
    final Size size = MediaQuery.sizeOf(context);
    _screenWidth = size.width;
    _screenHeight = size.height;
    _blockSizeHorizontal = _screenWidth / designWidth;
    _blockSizeVertical = _screenHeight / designHeight;
  }

  // Responsive width
  static double w(double width) {
    return width * _blockSizeHorizontal;
  }

  // Responsive height
  static double h(double height) {
    return height * _blockSizeVertical;
  }

  // Responsive font size
  static double sp(double fontSize) {
    return fontSize * _blockSizeHorizontal;
  }

  // Responsive radius
  static double r(double radius) {
    return radius * _blockSizeHorizontal;
  }

  // Screen width
  static double get screenWidth => _screenWidth;

  // Screen height
  static double get screenHeight => _screenHeight;

  // Vertical spacing
  static Widget verticalSpace(double height) {
    return SizedBox(height: h(height));
  }

  // Horizontal spacing
  static Widget horizontalSpace(double width) {
    return SizedBox(width: w(width));
  }
}

// Extension methods for easier usage
extension SizerExt on num {
  double get w => Sizer.w(toDouble());
  double get h => Sizer.h(toDouble());
  double get sp => Sizer.sp(toDouble());
  double get r => Sizer.r(toDouble());
  
  Widget get verticalSpace => Sizer.verticalSpace(toDouble());
  Widget get horizontalSpace => Sizer.horizontalSpace(toDouble());
}
```

**Setup in app.dart**:
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Builder(
        builder: (context) {
          // Initialize Sizer
          Sizer.init(context);
          return const SplashScreen();
        },
      ),
    );
  }
}
```

**Usage throughout the app**:
```dart
width: 160.w,           // Responsive width
height: 48.h,           // Responsive height
fontSize: 16.sp,        // Responsive font size
borderRadius: 12.r,     // Responsive radius
margin: 16.h,           // Responsive margin

// Spacing utilities
16.verticalSpace,       // Responsive vertical spacing
20.horizontalSpace,     // Responsive horizontal spacing

// Alternative usage
Sizer.verticalSpace(16),
Sizer.horizontalSpace(20),
```

### **2. Connectivity Check**

**File**: `/lib/core/utils/connectivity_service.dart`

```dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint('Failed to get connectivity: $e');
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
    
    if (!isConnected.value) {
      Get.snackbar(
        'No Internet',
        'Please check your internet connection',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
```

**Initialize in main.dart**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize connectivity service
  Get.put(ConnectivityService());
  
  runApp(const MyApp());
}
```

**Usage in controllers**:
```dart
class LoginController extends GetxController {
  final ConnectivityService _connectivityService = Get.find();

  Future<void> login() async {
    // Check internet connection before API call
    if (!_connectivityService.isConnected.value) {
      Get.snackbar(
        'No Internet',
        'Please check your internet connection and try again',
      );
      return;
    }
    
    // Or check directly
    final hasConnection = await _connectivityService.checkConnection();
    if (!hasConnection) return;
    
    // Proceed with login
  }
}
```

**Reactive UI based on connectivity**:
```dart
// Show connection status in UI
Obx(() => Container(
  color: _connectivityService.isConnected.value 
    ? Colors.green 
    : Colors.red,
  child: Text(
    _connectivityService.isConnected.value 
      ? 'Online' 
      : 'Offline',
  ),
))
```

**Add to pubspec.yaml**:
```yaml
dependencies:
  connectivity_plus: ^5.0.2
```

### **3. Typography System**

**File**: `/lib/core/common/styles/global_text_style.dart`

```dart
TextStyle getTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
  double? lineHeight,
  String fontFamily = 'SF Pro Display',
}) {
  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: lineHeight != null ? lineHeight / fontSize : null,
    fontFamily: fontFamily,
  );
}

// Usage in screens
Text(
  'Welcome Back!',
  style: getTextStyle(
    fontSize: 32.sp,          // H2 heading
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textPrimary,
  ),
)
```

**Typography Scale**:
- **H1**: 36sp, Bold (700)
- **H2**: 32sp, Bold (700) 
- **Body/Button**: 16sp, Medium (500)
- **Body/B1**: 16sp, Regular (400)
- **Body/B2**: 14sp, Regular (400)
- **Body/B3**: 12sp, Regular (400)

### **4. Color System**

**File**: `/lib/core/utils/constants/colors.dart`

```dart
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF4A7BFF);
  static const Color secondary = Color(0xFF34C759);
  
  // Text colors
  static const Color textPrimary = Color(0xFF161618);
  static const Color textSecondary = Color(0xFF8E8E93);
  
  // Background colors
  static const Color backgroundLight = Color(0xFFF6F6F6);
  static const Color backgroundNeutral = Color(0xFFF5F5F7);
  
  // Input field colors
  static const Color inputBackground = Color(0xFFF8F8F8);
  static const Color inputBorder = Color(0xFFE8E8E8);
}
```

---

## 🧩 Common Widgets Architecture

### **1. Reusable Background System**

**File**: `/lib/core/common/widgets/common_background.dart`

```dart
class CommonBackground extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;
  final EdgeInsetsGeometry? padding;
  
  // Three-layer gradient system
  // 1. Base light gray background
  // 2. Blue radial gradient (top-left)
  // 3. Green radial gradient (bottom-center + left corner)
}

class CommonBackgroundScaffold extends StatelessWidget {
  // Wrapper that provides background + scaffold structure
}
```

**Usage**:
```dart
CommonBackgroundScaffold(
  body: YourContent(),
)
```

### **2. Custom Button Components**

**Filled Button**: `/lib/core/common/widgets/customize_filled_button.dart`
```dart
CustomFilledButton(
  text: 'Log In',
  onPressed: () => controller.onLoginPressed(),
  padding: EdgeInsets.zero,
)
```

**Unfilled Button**: `/lib/core/common/widgets/customize_unfilled_button.dart`
```dart
CustomUnfilledButton(
  text: 'Create Account',
  onPressed: () => controller.onCreateAccount(),
  textColor: AppColors.primary,
  borderColor: AppColors.primary,
  backgroundColor: Colors.transparent,
)
```

### **3. Custom Text Field Component**

**Common Text Field**: `/lib/core/common/widgets/custom_text_field.dart`
```dart
CustomTextField(
  label: 'Email or Phone',
  hintText: 'Enter your email address',
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  suffixIcon: Icon(
    Icons.email_outlined,
    size: 16.w,
    color: AppColors.textSecondary,
  ),
)

// For password fields
CustomTextField(
  label: 'Password',
  hintText: 'Enter your password',
  controller: passwordController,
  obscureText: true,
  suffixIcon: GestureDetector(
    onTap: () => controller.togglePasswordVisibility(),
    child: Icon(
      controller.isPasswordHidden.value 
        ? Icons.visibility_off_outlined 
        : Icons.visibility_outlined,
      size: 16.w,
      color: AppColors.textSecondary,
    ),
  ),
)
```

**Features**:
- Consistent styling across all screens
- No border (clean design)
- Responsive sizing with ScreenUtil
- Built-in label and hint text support
- Prefix and suffix icon support
- Password visibility toggle support
- Multi-line support
- Form validation support

### **4. Image Loading System**

**NEVER use `Image.network()`.** 
Always use the **`cached_network_image`** package for network images to ensure offline caching, save bandwidth, and provide a premium UX with loading placeholders.

```dart
import 'package:cached_network_image/cached_network_image.dart';

CachedNetworkImage(
  imageUrl: "https://example.com/image.jpg",
  placeholder: (context, url) => const CircularProgressIndicator(), // or Shimmer
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

---

## 🎮 State Management with GetX

### **Controller Architecture**

**Base Controller Structure**:
```dart
class LoginController extends GetxController {

//never mentioned fontSize any size in this file

  // Observable variables
  final RxBool _isLoading = false.obs;
  
  // Getters
  bool get isLoading => _isLoading.value;
  
  // Navigation methods
  void onLoginPressed() {
    _setLoading(true);
    // Navigation logic
    Get.toNamed('/loginFormScreen');
  }
  
  // Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    debugPrint('Controller initialized');
  }
  
  @override
  void onClose() {
    super.onClose();
    debugPrint('Controller disposed');
  }
}
```

### **Form Controller Pattern**

```dart
class LoginFormController extends GetxController {
  // Form controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // Reactive state
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;
  
  // Form validation
  void onLoginPressed() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }
    // Handle login logic
  }
  
  // UI interactions
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
```

---

## 📱 Screen Implementation Pattern

### **1. Screen Structure Template**

```dart
class ScreenName extends StatelessWidget {
  const ScreenName({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerName controller = Get.put(ControllerName());

    return CommonBackgroundScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection1(controller),
              _buildSection2(controller),
              _buildSection3(controller),
            ],
          ),
        ),
      ),
    );
  }

  // Extract widgets into separate methods
  Widget _buildSection1(ControllerName controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          // Content
        ],
      ),
    );
  }
}
```

### **2. UI Spacing Guidelines**

```dart
// Vertical spacing - ALWAYS use .verticalSpace instead of SizedBox(height:)
8.verticalSpace     // Small spacing
12.verticalSpace    // Small-medium spacing
16.verticalSpace    // Medium spacing  
20.verticalSpace    // Medium-large spacing
24.verticalSpace    // Large spacing
32.verticalSpace    // Extra large spacing
40.verticalSpace    // Extra extra large spacing

// Horizontal spacing - ALWAYS use .horizontalSpace instead of SizedBox(width:)
8.horizontalSpace   // Small spacing
12.horizontalSpace  // Small-medium spacing
16.horizontalSpace  // Medium spacing
20.horizontalSpace  // Large spacing

// Container margins and padding
EdgeInsets.symmetric(horizontal: 16.w)  // Screen padding
EdgeInsets.only(left: 12.w, right: 12.w) // Custom padding

// Margins
EdgeInsets.only(top: 8.h, bottom: 16.h)
EdgeInsets.all(16.w)

// ❌ WRONG - Don't use SizedBox for spacing
SizedBox(height: 20.h)
SizedBox(width: 16.w)

// ✅ CORRECT - Use spacing extensions
20.verticalSpace
16.horizontalSpace
```

### **3. Form Field Implementation**

```dart
// ✅ RECOMMENDED - Use CustomTextField for all form inputs
Widget _buildEmailField(ControllerName controller) {
  return CustomTextField(
    label: 'Email or Phone',
    hintText: 'Enter your email address',
    controller: controller.emailController,
    keyboardType: TextInputType.emailAddress,
    suffixIcon: Icon(
      Icons.email_outlined,
      size: 16.w,
      color: AppColors.textSecondary,
    ),
  );
}

Widget _buildPasswordField(ControllerName controller) {
  return Obx(() => CustomTextField(
    label: 'Password',
    hintText: 'Enter your password',
    controller: controller.passwordController,
    obscureText: controller.isPasswordHidden.value,
    suffixIcon: GestureDetector(
      onTap: controller.togglePasswordVisibility,
      child: Icon(
        controller.isPasswordHidden.value
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        size: 16.w,
        color: AppColors.textSecondary,
      ),
    ),
  ));
}

// ❌ OLD WAY - Don't create custom form field methods anymore
// Use CustomTextField instead for consistency
```

---

## 🧭 Navigation Architecture (go_router)

### **Route Configuration**

**File**: `/lib/routes/app_routes.dart`

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  // ---------------------------------------------------------------------------
  // Route Constants
  // ---------------------------------------------------------------------------
  static const String splashScreen = "/";
  static const String homeScreen = "/home";
  
  // ---------------------------------------------------------------------------
  // Router Configuration
  // ---------------------------------------------------------------------------
  static final GoRouter router = GoRouter(
    initialLocation: splashScreen,
    routes: [
      GoRoute(
        path: splashScreen,
        builder: (context, state) => const SplashScreen(),
      ),
      // Add other routes using _buildPageWithTransition for custom animations
    ],
  );

  // ---------------------------------------------------------------------------
  // Custom Transitions (Slide & Fade)
  // ---------------------------------------------------------------------------
  static CustomTransitionPage _buildPageWithTransition<T>({
    required BuildContext context, 
    required GoRouterState state, 
    required Widget child,
    bool slideUp = false,
  }) {
    // Return CustomTransitionPage with SlideTransition & FadeTransition
  }
}
```

### **Navigation Usage & GetX Integration**
- **Strict Separation:** NEVER use `Get.toNamed()` or `Get.to()` in controllers. Controllers must be strictly focused on business logic and state, free of routing knowledge.
- **UI Triggered Navigation:** Use `context.go()` or `context.push()` directly in your widgets.

```dart
// Navigate to screen (Push onto stack)
CustomFilledButton(
  text: 'Login',
  onPressed: () => context.push(AppRoute.loginFormScreen), 
)

// Replace current screen
context.go(AppRoute.homeScreen);

// Go back
context.pop();

// Pass arguments
context.push('/profileScreen', extra: {'userId': 123});
```

---

## 📍 Bottom Navigation Architecture

### **Structure Overview**

The bottom navigation system is organized in a dedicated feature module:

```
lib/features/bottom_navigation/
├── controllers/
│   └── bottom_navigation_controller.dart
├── screens/
│   └── bottom_navigation_screen.dart
└── widgets/
    └── custom_bottom_navigation.dart
```

### **1. Bottom Navigation Controller**

**File**: `/lib/features/bottom_navigation/controllers/bottom_navigation_controller.dart`

**Core Implementation Pattern**:

```dart
class BottomNavigationController extends GetxController {
  // Observable current tab index
  final RxInt _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  // Tab change handler
  void changeTab(int index) {
    if (_currentIndex.value != index) {
      // Handle lifecycle for resource-heavy screens
      _handleScreenLifecycle(_currentIndex.value, isLeaving: true);
      
      _currentIndex.value = index;
      
      _handleScreenLifecycle(index, isLeaving: false);
    }
  }

  // Resource lifecycle management (camera, video players, etc.)
  void _handleScreenLifecycle(int index, {required bool isLeaving}) {
    try {
      // Example: Pause/resume camera on scan screen
      if (index == 2) {
        final controller = Get.find<ScanScreenController>();
        isLeaving ? controller.pauseCamera() : controller.resumeCamera();
      }
    } catch (e) {
      debugPrint('Controller not found: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('BottomNavigationController initialized');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('BottomNavigationController disposed');
  }
}
```

**Key Responsibilities**:
- Manage current tab state with reactive `RxInt`
- Handle screen switching logic
- Manage resource lifecycle (camera, video, audio, etc.)
- Centralize navigation behavior

### **2. Bottom Navigation Screen**

**File**: `/lib/features/bottom_navigation/screens/bottom_navigation_screen.dart`

**Stack-Based Architecture**:

```dart
class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavigationController controller = Get.put(
      BottomNavigationController(),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Reactive screen content
          Obx(() => _getPage(controller.currentIndex)),

          // Bottom navigation overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(
              () => CustomBottomNavBar(
                currentIndex: controller.currentIndex,
                onTabSelected: (index) => controller.changeTab(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Map tab index to screen
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const Screen2();
      case 2:
        return const Screen3();
      default:
        return const HomeScreen();
    }
  }
}
```

**Architecture Pattern**:
- Use `Stack` to overlay navigation bar on content
- Wrap content with `Obx()` for reactive screen switching
- Initialize controller with `Get.put()` for persistence
- Separate navigation UI from screen content

### **3. Custom Bottom Navigation Widget**

**File**: `/lib/features/bottom_navigation/widgets/custom_bottom_navigation.dart`

**Widget Structure Pattern**:

```dart
class CustomBottomNavBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.onTabSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Responsive height using .h
      height: 95.h,
      
      // Your navigation bar design
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(index: 0, label: 'Home'),
          _buildNavItem(index: 1, label: 'Tab2'),
          _buildNavItem(index: 2, label: 'Tab3'),
          // Add more tabs as needed
        ],
      ),
    );
  }

  Widget _buildNavItem({required int index, required String label}) {
    final bool isSelected = currentIndex == index;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick(); // Recommended for UX
          onTabSelected(index);
        },
        child: Container(
          // Your tab item design
          // Use responsive units: .w, .h, .sp, .r
          child: Column(
            children: [
              // Icon (Image.asset or Icon widget)
              // Label text
            ],
          ),
        ),
      ),
    );
  }
}
```

**Implementation Notes**:
- Keep widget configurable with required parameters
- Use `HapticFeedback` for better user experience
- Apply responsive sizing with `.w`, `.h`, `.sp`, `.r`
- Use `Material` + `InkWell` for touch feedback
- Extract tab items into separate method

**For Floating Center Button**:
```dart
// Use Stack with Positioned for elevated center button
child: Stack(
  clipBehavior: Clip.none,
  children: [
    // Main navigation bar
    Positioned(bottom: 0, ...),
    
    // Floating center button
    Positioned(
      top: -20.h, // Elevate above bar
      child: YourFloatingButton(),
    ),
  ],
)
```

### **4. Setup Guidelines**

**Step 1: Create Controller**
```dart
// Define tab management and lifecycle handling
class BottomNavigationController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  void changeTab(int index) { /* implementation */ }
}
```

**Step 2: Create Screen**
```dart
// Use Stack to overlay navigation on content
// Map indices to screens in _getPage()
```

**Step 3: Create Custom Widget**
```dart
// Design your navigation bar widget
// Use responsive units throughout
```

**Step 4: Configure Routes**
```dart
// In app_routes.dart
GetPage(
  name: '/bottomNavigation',
  page: () => const BottomNavigationScreen(),
)
```

**Step 5: Navigate**
```dart
// From splash or login
Get.offAllNamed('/bottomNavigation');
```

### **5. Best Practices**

**Resource Management**:
- Always handle lifecycle for heavy resources (camera, video, audio)
- Pause/dispose when leaving screen, resume when entering
- Use try-catch when accessing optional controllers

**State Management**:
- Keep tab state in controller with `RxInt`
- Use `Obx()` for reactive screen switching
- Initialize controller with `Get.put()` for persistence

**Performance**:
- Implement lazy loading for screens if needed
- Clean up resources in screen's dispose methods
- Avoid rebuilding entire navigation bar unnecessarily

**Extensibility**:
- Keep tab configuration data-driven
- Extract common patterns into reusable methods
- Make navigation widget flexible for different designs

**Adding New Tab**:
1. Add case in `_getPage()` for new screen
2. Update custom navigation widget with new tab item
3. Handle any special lifecycle needs in controller
4. Test navigation flow end-to-end

---
## �🔄 Reactive UI with Obx

### **Reactive Widgets**

```dart
// Simple reactive text
Obx(() => Text(
  controller.isLoading.value ? 'Loading...' : 'Login',
  style: getTextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  ),
))

// Reactive button state
Obx(() => CustomFilledButton(
  text: 'Log In',
  onPressed: controller.isLoading.value 
    ? () {} 
    : controller.onLoginPressed,
))

// Reactive form field
Obx(() => TextField(
  obscureText: controller.isPasswordHidden.value,
  // ... other properties
))
```

---

## 🎯 Best Practices Applied

### **1. Code Generation Guidelines**

- **No Comments**: Generated code should be clean without inline comments
- **Self-Documenting Code**: Use descriptive variable and method names instead of comments
- **Clean Implementation**: Code should be production-ready without TODO or placeholder comments

### **2. Clean Code Principles**

- **Single Responsibility**: Each widget method has one purpose
- **Extract Methods**: Complex widgets broken into smaller methods
- **Descriptive Naming**: Method names clearly describe functionality
- **Separation of Concerns**: UI logic separated from business logic

### **3. Performance Optimizations**

- **Selective Reactivity**: Only wrap necessary widgets with `Obx()`
- **Controller Disposal**: Proper cleanup in `onClose()`
- **Asset Optimization**: Proper image sizing and formats
- **Lazy Loading**: Controllers created only when needed with `Get.put()`

### **4. Maintainability**

- **Consistent Structure**: All screens follow same pattern
- **Centralized Styling**: Typography and colors in shared files
- **Reusable Components**: Common widgets for buttons, forms, backgrounds
- **Clear Documentation**: Comments explaining complex logic

### **5. Responsive Design**

- **ScreenUtil Integration**: All dimensions use responsive units
- **Flexible Layouts**: `SingleChildScrollView` for content overflow
- **Safe Areas**: Proper handling of device notches and status bars
- **Cross-Platform**: Works on iOS, Android, and web

---

## 🚀 Getting Started

### **1. Setup New Screen**

1. Create controller in `/lib/features/[feature]/controllers/`
2. Create screen in `/lib/features/[feature]/presentation/screens/`
3. Add route in `/lib/routes/app_routes.dart`
4. Follow the screen structure template
5. Use common widgets and styling system

### **2. Creating Custom Widgets**

1. Place in `/lib/core/common/widgets/`
2. Make them reusable and configurable
3. Follow the responsive design guidelines
4. Include proper documentation

### **3. Adding New Features**

1. Create feature folder in `/lib/features/`
2. Add controllers, screens, and models
3. Update routing configuration
4. Test navigation flow

---

## 📋 Development Workflow

1. **Design Analysis**: Study Figma designs for exact specifications
2. **Structure Planning**: Break screen into logical widget methods
3. **Controller Setup**: Create reactive state management
4. **UI Implementation**: Build responsive widgets with proper spacing
5. **Navigation Integration**: Connect screens with routing
6. **Testing**: Verify functionality and responsiveness
7. **Code Review**: Ensure consistency with architecture patterns

This architecture ensures scalable, maintainable, and responsive Flutter applications with clean separation of concerns and reusable components.


//Example of how to use this template

"I'm working on a new screen for this Flutter app. Please read the ARCHITECTURE.md 
file to understand our established patterns and conventions. 

I need to create a [Profile Settings Screen] that should follow the same 
architecture as the login screens. Here's the Figma design: [link]

Please use:
- GetX state management
- Common background system  
- Responsive design with .verticalSpace/.horizontalSpace
- Same typography and color system
- Extract widget methods pattern"