// presentation/views/login_view.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/presentation/cubits/auth/auth_cubit.dart';
import 'package:news_paper_app/presentation/widgets/login_widgets/auth_text_field.dart';
import 'package:news_paper_app/presentation/widgets/login_widgets/forget_password_view.dart';
import 'package:news_paper_app/presentation/widgets/login_widgets/google_sign_in_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    context.locale;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.of(
                    context,
                  ).pushReplacementNamed(AppRoutes.homePageRoute);
                }
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: colorScheme.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoadingEmail =
                    state is AuthLoading &&
                    state.loginMethod == LoginMethod.email;
                final isLoadingGoogle =
                    state is AuthLoading &&
                    state.loginMethod == LoginMethod.google;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),

                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.newspaper,
                            color: colorScheme.onPrimary,
                            size: 32,
                          ),
                        ),

                        const SizedBox(height: 32),
                        Text(
                          'Welcome back'.tr(),
                          style: textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Login subtitle'.tr(),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 32),

                        AuthTextField(
                          controller: _emailController,
                          label: 'Email'.tr(),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Field required'.tr();
                            }
                            final emailRegex = RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            );
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Invalid Email'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        AuthTextField(
                          controller: _passwordController,
                          label: 'Password'.tr(),
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: colorScheme.outline,
                            ),
                            onPressed:
                                () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field required'.tr();
                            }
                            if (value.length < 6) {
                              return 'Password too short'.tr();
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordView(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password'.tr(),
                              style: TextStyle(color: colorScheme.secondary),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoadingEmail ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                isLoadingEmail
                                    ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colorScheme.onPrimary,
                                      ),
                                    )
                                    : Text('Sign in'.tr()),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: colorScheme.outlineVariant),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'or continue with'.tr(),
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: colorScheme.outlineVariant),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        GoogleSignInButton(
                          isLoading: isLoadingGoogle,
                          onPressed:
                              () =>
                                  context.read<AuthCubit>().signInWithGoogle(),
                        ),

                        const SizedBox(height: 24),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have account".tr(),
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  () => Navigator.of(
                                    context,
                                  ).pushReplacementNamed(
                                    AppRoutes.registerPageRoute,
                                  ),
                              child: Text(
                                'Sign up'.tr(),
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
