part of 'router.dart';

class NoAnimationPage<T> extends CustomTransitionPage<T> {
  NoAnimationPage({
    required super.child,
    required GoRouterState state,
    super.arguments,
    super.restorationId,
  }) : super(
    key: state.pageKey,
    name: state.name,
    transitionsBuilder: _transitionsBuilder,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );

  static Widget _transitionsBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) =>
      child;
}

class SlideInTransitionPage<T> extends CustomTransitionPage<T> {
  SlideInTransitionPage({
    required super.child,
    required GoRouterState state,
    super.arguments,
    super.restorationId,
  }) : super(
    key: state.pageKey,
    name: state.name,
    transitionsBuilder: _transitionsBuilder,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );

  static Widget _transitionsBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    // Use a tween that defines a range between the right edge of the screen and zero.
    // The 'animation' controls the position from 0.0 to 1.0 over the duration.
    var slideTween = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // Start from the right edge of the screen
      end: Offset.zero, // End at the center (no offset)
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.easeInToLinear,
    ));

    // Combine the slide animation with a fade transition using a FadeTransition widget.
    // The 'animation' is used again to control the opacity from 0.0 to 1.0 over the duration.
    return SlideTransition(
      position: slideTween, // Apply the slide tween
      child: child,
    );
  }
}

class SlideUpTransitionPage<T> extends CustomTransitionPage<T> {
  SlideUpTransitionPage({
    required super.child,
    required GoRouterState state,
    super.arguments,
    super.restorationId,
  }) : super(
    key: state.pageKey,
    name: state.name,
    transitionsBuilder: _transitionsBuilder,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );

  static Widget _transitionsBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    // Slide transition starting from below the screen
    var slideTween = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from the bottom of the screen
      end: Offset.zero, // End at the center (no offset)
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.easeInToLinear,
    ));

    // Fade transition
    var fadeTween = Tween<double>(
      begin: 0.0, // Start with fully transparent
      end: 1.0, // End with fully opaque
    ).animate(animation);

    return FadeTransition(
      opacity: fadeTween,
      child: SlideTransition(
        position: slideTween, // Apply the slide tween
        child: child,
      ),
    );
  }
}

class FadeInTransitionPage<T> extends CustomTransitionPage<T> {
  FadeInTransitionPage({
    required super.child,
    required GoRouterState state,
    super.arguments,
    super.restorationId,
  }) : super(
    key: state.pageKey,
    name: state.name,
    transitionsBuilder: _transitionsBuilder,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
  );

  static Widget _transitionsBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) =>
      FadeTransition(opacity: animation, child: child);
}
