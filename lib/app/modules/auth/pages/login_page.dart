import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:task_manager_app/app/core/errors/error_handler_strategy.dart';
import 'package:task_manager_app/app/core/extension_size.dart';
import 'package:task_manager_app/app/modules/auth/stores/biometric_store.dart';
import 'package:task_manager_app/app/widgets/custom_button.dart';
import 'package:task_manager_app/app/widgets/custom_text_field.dart';
import '../stores/auth_store.dart';
import 'package:task_manager_app/app/core/storege_security.dart';

/// Página de login do aplicativo (Stateful).
/// Permite que o usuário insira e‑mail e senha para autenticação.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _authStore = Modular.get<AuthStore>();
  final _biometricStore = Modular.get<BiometricAuthStore>();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _loadingBiometric = ValueNotifier(false);

  bool _showManualLogin = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await _biometricStore.loadBiometricStatus()) {
        try {
          _loadingBiometric.value = true;
          final auth = await _biometricStore.authenticateIfEnabled();
          if (auth) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Modular.to.navigate('/main');
            });
          } else {
            _loadingBiometric.value = false;
            setState(() {
              _showManualLogin = true;
            });
          }
        } catch (e) {
          _loadingBiometric.value = false;
          if (!context.mounted) return;
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Algo deu errado no login da biometria")),
          );
          setState(() {
            _showManualLogin = true;
          });
        }
      } else {
        setState(() {
          _showManualLogin = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loadingBiometric.dispose();
    super.dispose();
  }

  /// Realiza o login usando Supabase e dispara fluxo de biometria se necessário.
  Future<void> _login(BuildContext context) async {
    final errorStrategy = ErrorHandlerStrategy();

    if (_formKey.currentState!.validate()) {
      try {
        await _authStore.signIn(
          _emailController.text,
          _passwordController.text,
        );

        await saveSecureData("email", _emailController.text);
        await saveSecureData("password", _passwordController.text);

        await _biometricStore.loadBiometricStatus();

        if (!context.mounted) return;
        Modular.to.navigate('/main');
      } catch (e) {
        final errorMessage = errorStrategy.handleAuthError(e);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  Future<void> _biometricOrEmail() async {
    setState(() {
      _showManualLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF52B2AD),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Cabeçalho
            Container(
              width: context.screenWidth,
              height: context.heightPct(0.6),
              decoration: const BoxDecoration(color: Color(0xFF52B2AD)),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Card com formulário de login
            Card(
              elevation: 4,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  width: context.widthPct(1),
                  height: context.heightPct(0.356),
                  child: _showManualLogin
                      ? Column(
                          spacing: 10.0,
                          children: [
                            // E-mail
                            CustomTextField(
                              controller: _emailController,
                              label: 'E-mail',
                              icon: Icons.email_outlined,
                              validator: (value) => (value == null || value.isEmpty)
                                  ? 'Por favor, insira um email'
                                  : null,
                            ),
                            // Senha
                            CustomTextField(
                              controller: _passwordController,
                              label: 'Senha',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              validator: (value) => (value == null || value.isEmpty)
                                  ? 'Por favor, insira uma senha'
                                  : null,
                            ),
                            // Botão login
                            CustomButton(
                              text: 'Entrar',
                              onPressed: () => _login(context),
                            ),
                            // Link registrar
                            TextButton(
                              onPressed: () => Modular.to.pushNamed('/register'),
                              child: const Text(
                                'Criar conta',
                                style: TextStyle(color: Color(0xFF52B2AD)),
                              ),
                            ),
                          ],
                        )
                      : // Loading ou botão para escolher login manual
                      Column(
                        spacing: 10.0,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder<bool>(
                              valueListenable: _loadingBiometric,
                              builder: (context, isLoading, _) {
                                if (!_showManualLogin && isLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24),
                                    child: CircularProgressIndicator(color: Color(0xFF52B2AD)),
                                  );
                                }
                          
                                if (!_showManualLogin && !isLoading) {
                                  return CustomButton(
                                    text: "Entrar com e-mail e senha",
                                    onPressed: () => _biometricOrEmail(),
                                  );
                                }
                          
                                return const SizedBox.shrink();
                              },
                            ),
                        ],
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
