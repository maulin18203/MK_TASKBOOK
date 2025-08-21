import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing...';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    // Loading progress animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _startInitialization() async {
    // Start loading animation
    _loadingAnimationController.forward();

    // Simulate initialization steps
    await _performInitializationSteps();

    // Navigate to appropriate screen after initialization
    if (mounted) {
      _navigateToNextScreen();
    }
  }

  Future<void> _performInitializationSteps() async {
    final steps = [
      {'status': 'Checking authentication...', 'duration': 600},
      {'status': 'Loading user preferences...', 'duration': 500},
      {'status': 'Fetching task data...', 'duration': 700},
      {'status': 'Preparing local database...', 'duration': 400},
      {'status': 'Finalizing setup...', 'duration': 300},
    ];

    for (int i = 0; i < steps.length; i++) {
      if (mounted) {
        setState(() {
          _initializationStatus = steps[i]['status'] as String;
          _progress = (i + 1) / steps.length;
        });
        await Future.delayed(
            Duration(milliseconds: steps[i]['duration'] as int));
      }
    }

    // Final delay to show completion
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _isInitializing = false;
        _initializationStatus = 'Ready!';
        _progress = 1.0;
      });
    }
  }

  void _navigateToNextScreen() {
    // Simulate authentication check
    final isAuthenticated = _checkAuthenticationStatus();
    final isFirstTime = _checkFirstTimeUser();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        if (isFirstTime) {
          // Navigate to onboarding (not implemented in this scope)
          Navigator.pushReplacementNamed(context, '/dashboard-home');
        } else if (isAuthenticated) {
          Navigator.pushReplacementNamed(context, '/dashboard-home');
        } else {
          // Navigate to login (not implemented in this scope)
          Navigator.pushReplacementNamed(context, '/dashboard-home');
        }
      }
    });
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check
    // In real implementation, check SharedPreferences or secure storage
    return false;
  }

  bool _checkFirstTimeUser() {
    // Mock first time user check
    // In real implementation, check SharedPreferences
    return false;
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildNotebookGradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              // Status bar spacing
              SizedBox(height: 8.h),

              // Main content area
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo section
                    _buildAnimatedLogo(),

                    SizedBox(height: 6.h),

                    // App name and tagline
                    _buildAppBranding(),

                    SizedBox(height: 8.h),

                    // Loading section
                    _buildLoadingSection(),
                  ],
                ),
              ),

              // Bottom spacing
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildNotebookGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.lightTheme.colorScheme.surface,
          AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.95),
          AppTheme.lightTheme.colorScheme.primaryContainer
              .withValues(alpha: 0.1),
          AppTheme.lightTheme.colorScheme.secondaryContainer
              .withValues(alpha: 0.05),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoFadeAnimation.value,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '📓',
                      style: TextStyle(fontSize: 12.w),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '⏰',
                      style: TextStyle(fontSize: 10.w),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBranding() {
    return AnimatedBuilder(
      animation: _logoAnimationController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoFadeAnimation.value,
          child: Column(
            children: [
              // App name
              Text(
                'M.K Taskbooks',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 2.h),

              // Tagline
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Plan Smart. Work Sharp. Never Forget.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return AnimatedBuilder(
      animation: _loadingAnimationController,
      builder: (context, child) {
        return Opacity(
          opacity: _loadingAnimation.value,
          child: Column(
            children: [
              // Loading progress bar
              Container(
                width: 60.w,
                height: 0.8.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 60.w * _progress,
                      height: 0.8.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.lightTheme.colorScheme.primary,
                            AppTheme.lightTheme.colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              // Loading status text
              Text(
                _initializationStatus,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 1.h),

              // Progress percentage
              Text(
                '${(_progress * 100).toInt()}%',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 2.h),

              // Loading indicator dots
              _buildLoadingDots(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _loadingAnimationController,
          builder: (context, child) {
            final delay = index * 0.2;
            final animationValue =
                (_loadingAnimation.value - delay).clamp(0.0, 1.0);
            final opacity = (animationValue * 2).clamp(0.0, 1.0);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 1.w),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
