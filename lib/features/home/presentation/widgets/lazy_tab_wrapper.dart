import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/dependency_injection.dart';
import 'package:test/core/services/app_state_service.dart';
import 'package:test/core/services/global_cubit_service.dart';
import 'package:test/core/services/cart_global_service.dart';
import 'package:test/core/utils/animations/custom_progress_indcator.dart';

/// Wrapper widget that initializes cart and wishlist data only when the tab is accessed
class LazyTabWrapper extends StatefulWidget {
  final Widget child;
  final bool requiresAuth;
  final bool requiresCartData;
  final bool requiresWishlistData;

  const LazyTabWrapper({
    super.key,
    required this.child,
    this.requiresAuth = false,
    this.requiresCartData = false,
    this.requiresWishlistData = false,
  });

  @override
  State<LazyTabWrapper> createState() => _LazyTabWrapperState();
}

class _LazyTabWrapperState extends State<LazyTabWrapper> {
  bool _isInitialized = false;
  bool _isLoading = false;
  String _loadingMessage = 'جاري التحميل...';

  @override
  void initState() {
    super.initState();
    _initializeIfNeeded();
  }

  Future<void> _initializeIfNeeded() async {
    if (_isInitialized || !widget.requiresAuth) {
      setState(() {
        _isInitialized = true;
      });
      return;
    }

    final appStateService = DependencyInjection.getIt.get<AppStateService>();
    final isLoggedIn =
        appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

    if (!isLoggedIn) {
      setState(() {
        _isInitialized = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _loadingMessage = 'جاري تحضير البيانات...';
    });

    try {
      // Initialize global services if not already done
      if (!GlobalCubitService.instance.isInitialized) {
        setState(() {
          _loadingMessage = 'تحضير الخدمات...';
        });
        GlobalCubitService.instance.initialize();
      }

      // Initialize cart service if needed
      if (widget.requiresCartData) {
        setState(() {
          _loadingMessage = 'تحميل بيانات السلة...';
        });
        try {
          await CartGlobalService.instance.initialize();
        } catch (e) {
          //print('⚠️ LazyTabWrapper: Cart service initialization failed: $e');
        }
      }

      // Load wishlist data if needed
      if (widget.requiresWishlistData) {
        setState(() {
          _loadingMessage = 'تحميل قائمة الأمنيات...';
        });
        final wishlistCubit = GlobalCubitService.instance.wishlistCubit;
        if (wishlistCubit != null) {
          await wishlistCubit.getMyWishlist();
        }
      }

      // Load cart data if needed
      if (widget.requiresCartData) {
        setState(() {
          _loadingMessage = 'تحميل بيانات السلة...';
        });
        final cartCubit = GlobalCubitService.instance.cartCubit;
        if (cartCubit != null) {
          await cartCubit.getCart();
        }
      }

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      //print('⚠️ LazyTabWrapper: Initialization failed: $e');
      // Continue anyway - show the tab even if data loading failed
      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomProgressIndicator(size: 50),
              const SizedBox(height: 20),
              Text(
                _loadingMessage,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Provide the necessary BlocProviders for authenticated tabs
    if (widget.requiresAuth) {
      final appStateService = DependencyInjection.getIt.get<AppStateService>();
      final isLoggedIn =
          appStateService.isLoggedIn() && !appStateService.hasLoggedOut();

      if (isLoggedIn) {
        final providers = <BlocProvider>[];

        if (widget.requiresCartData) {
          final cartCubit = GlobalCubitService.instance.cartCubit;
          if (cartCubit != null) {
            providers.add(BlocProvider.value(value: cartCubit));
          }
        }

        if (widget.requiresWishlistData) {
          final wishlistCubit = GlobalCubitService.instance.wishlistCubit;
          if (wishlistCubit != null) {
            providers.add(BlocProvider.value(value: wishlistCubit));
          }
        }

        if (providers.isNotEmpty) {
          return MultiBlocProvider(providers: providers, child: widget.child);
        }
      }
    }

    return widget.child;
  }
}
