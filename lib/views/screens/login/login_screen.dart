import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qms_mobile/views/widgets/centered_container.dart';
import 'package:qms_mobile/views/widgets/custom_app_bar.dart';
import 'package:qms_mobile/views/widgets/custom_button.dart';
import 'package:qms_mobile/views/widgets/custom_checkbox.dart';
import 'package:qms_mobile/views/widgets/custom_logo.dart';
import 'package:qms_mobile/views/widgets/custom_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

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
                  text: localizations.loginButton,
                  onPressed: () {
                    print(
                        "Login with username: ${_usernameController.text} and password: ${_passwordController.text}");
                  },
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
