part of '../authentication_screen.dart';

class _ErrorBanner extends StatelessWidget {
  final String label;

  const _ErrorBanner(this.label);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: theme.colorScheme.primaryContainer,
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
