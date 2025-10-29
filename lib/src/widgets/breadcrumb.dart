import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Breadcrumb extends StatefulWidget {
  const Breadcrumb({super.key});

  @override
  State<Breadcrumb> createState() => _BreadcrumbState();
}

class _BreadcrumbState extends State<Breadcrumb> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter.of(context);
    _router.routerDelegate.addListener(_rebuild);
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  // Helper to make breadcrumb text more readable
  String _formatSegment(String segment) {
    return segment
        .replaceAll('-', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final uri = _router.routerDelegate.currentConfiguration.uri;
    final pathSegments = uri.pathSegments;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.grey[200],
      child: Wrap( // Use Wrap to prevent overflow on smaller screens
        crossAxisAlignment: WrapCrossAlignment.center,
        children: _buildBreadcrumbItems(context, pathSegments),
      ),
    );
  }

  List<Widget> _buildBreadcrumbItems(BuildContext context, List<String> pathSegments) {
    final List<Widget> items = [];
    String currentPath = '';

    // Add a "Home" or "Dashboard" link at the beginning
    items.add(
      GestureDetector(
        onTap: () => context.go('/dashboard'),
        child: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );

    for (final segment in pathSegments) {
      // Skip the 'dashboard' segment as it's already handled
      if (segment.toLowerCase() == 'dashboard') {
        currentPath = '/$segment';
        continue;
      }

      currentPath += '/$segment';
      items.add(const Text(' > '));
      items.add(
        GestureDetector(
          onTap: () {
            // Only navigate if it's not the last item
            if (currentPath != _router.routerDelegate.currentConfiguration.uri.toString()) {
              context.go(currentPath);
            }
          },
          child: Text(
            _formatSegment(segment),
            style: TextStyle(
              color: currentPath == _router.routerDelegate.currentConfiguration.uri.toString()
                  ? Colors.black // Last item is not a link
                  : Colors.blue,
              decoration: currentPath == _router.routerDelegate.currentConfiguration.uri.toString()
                  ? TextDecoration.none
                  : TextDecoration.underline,
            ),
          ),
        ),
      );
    }

    return items;
  }
}