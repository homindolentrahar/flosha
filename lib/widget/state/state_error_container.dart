part of '../state_container.dart';

/// Default widget that will displayed when state is **Error**
class StateErrorContainer extends StatelessWidget {
  /// Config for error widget
  final StateContainerConfig? config;

  /// Whether to show [retryWidget] (if provided) or retry button
  final bool isShowRetry;

  /// Custom component to display retry button
  final Widget? retryWidget;

  /// A callback when [retryWidget] or defualt retry button clicked
  final VoidCallback? onRetry;

  const StateErrorContainer({
    super.key,
    required this.config,
    this.isShowRetry = true,
    this.retryWidget,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: config?.widget ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                config?.image != null
                    ? Image(image: config!.image!)
                    : const Icon(Icons.warning_outlined, size: 48),
                const SizedBox(height: 16),
                Text(
                  config?.title ?? "Data not found",
                  style: config?.titleStyle ??
                      const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  config?.message ?? "Cannot display data from data source",
                  style: config?.messageStyle ?? const TextStyle(fontSize: 14),
                ),
              ],
            ),
      ),
    );
  }
}
