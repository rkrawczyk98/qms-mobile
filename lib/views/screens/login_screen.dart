import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/data/providers/auth_provider.dart';
import 'package:qms_mobile/data/providers/user_provider.dart';
import 'package:qms_mobile/routes/navigation_service.dart';
import 'package:qms_mobile/utils/helpers/auth_storage.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:qms_mobile/views/widgets/custom_app_bar.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/widgets/custom_checkbox.dart';
import 'package:qms_mobile/views/widgets/custom_logo.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final authService = ref.read(authServiceProvider);
    final isLoggedIn = await authService.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    // Save login details if "Remember Me" is checked
    if (_rememberMe) {
      await AuthStorage.saveLoginData(
        _usernameController.text,
        _passwordController.text,
      );
    } else {
      // Delete login information if the option is not checked
      await AuthStorage.deleteLoginData();
    }

    if (isLoggedIn) {
      ref.read(isLoggedInProvider.notifier).update((state) => true);

      // Download user data after logging in
      final userInfo = await authService.fetchUserInfo();
      if (userInfo != null) {
        ref.read(userProvider.notifier).setUser(userInfo);
        // Go to the home screen
        navigationService.navigateAndReplace('/home');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLoginData();
  }

  Future<void> _loadSavedLoginData() async {
    final loginData = await AuthStorage.getLoginData();
    if (loginData['username'] != null && loginData['password'] != null) {
      setState(() {
        _usernameController.text = loginData['username']!;
        _passwordController.text = loginData['password']!;
        _rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
          child: CenteredContainerWidget(
            screenWidth: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomLogoWidget(
                  logoPath: 'images/logo.svg',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 60),
                CustomTextField(
                  label: localizations.loginLabel,
                  hint: localizations.loginHint,
                  controller: _usernameController,
                  onChanged: (value) => {},
                  keyboardType: TextInputType.emailAddress,
                  autofillHint: const [AutofillHints.username],
                  fontSize: 18,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: localizations.passwordLabel,
                  hint: localizations.passwordHint,
                  isObscure: true,
                  controller: _passwordController,
                  onChanged: (value) => {},
                  autofillHint: const [AutofillHints.password],
                  fontSize: 18,
                ),
                const SizedBox(height: 10),
                CustomCheckbox(
                  text: localizations.rememberMe,
                  isChecked: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                  fontSize: 16,
                  textColor: Colors.grey[600],
                ),
                const SizedBox(height: 30),
                CustomButton(
                  text: _isLoading
                      ? localizations.loading
                      : localizations.loginButton,
                  onPressed: _isLoading ? () {} : _login,
                  width: 180,
                  height: 50,
                  fontSize: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
