// presentation/views/register_view.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/routes/app_routes.dart';
import 'package:news_paper_app/presentation/cubits/auth/auth_cubit.dart';
import 'package:news_paper_app/presentation/widgets/login_widgets/auth_text_field.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().register(
      name: _nameController.text.trim(),
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
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
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
                  backgroundColor: colorScheme.errorContainer,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create account'.tr(), style: textTheme.headlineLarge),
                    const SizedBox(height: 8),
                    Text(
                      'Register subtitle'.tr(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 32),

                    AuthTextField(
                      controller: _nameController,
                      label: 'Full Name'.tr(),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Field required'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

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
                          return 'Invalid email'.tr();
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
                          return 'password too short'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirm Password'.tr(),
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colorScheme.outline,
                        ),
                        onPressed:
                            () => setState(
                              () =>
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                            ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Field required'.tr();
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords dont match'.tr();
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            isLoading
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colorScheme.onPrimary,
                                  ),
                                )
                                : Text('Sign up'.tr()),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have account'.tr(),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        TextButton(
                          onPressed:
                              () => Navigator.of(
                                context,
                              ).pushReplacementNamed(AppRoutes.loginPageRoute),
                          child: Text(
                            'Sign in'.tr(),
                            style: TextStyle(
                              color: colorScheme.secondary,
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
        ),
      ),
    );
  }
}
