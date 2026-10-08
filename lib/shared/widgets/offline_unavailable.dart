/// How an entry point the offline core does not implement is presented
/// (UC-02, FR-DA-14).
///
/// Always the same heading and always the core's own reason, and never a retry:
/// the core answers this way every time, so offering "try again" would only
/// teach the user that trying again is the fix.
library;

import 'package:flutter/material.dart';

/// The heading every such explanation carries.
const notAvailableOfflineTitle = 'Not available offline';

/// The one-line form, for a tooltip or a disabled control's caption.
String notAvailableOffline(String reason) => reason.isEmpty
    ? notAvailableOfflineTitle
    : '$notAvailableOfflineTitle. $reason';

/// Takes a screen's place when the screen's purpose is not available offline.
class OfflineUnavailableNotice extends StatelessWidget {
  const OfflineUnavailableNotice({required this.reason, super.key});

  /// The core's reason.
  final String reason;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 40,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                notAvailableOfflineTitle,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(reason, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'It is available when this application is connected to an '
                'instance.',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The inline form, for a part of a screen — one figure, one action — that is
/// not available offline while the rest of the screen is.
class OfflineUnavailableLine extends StatelessWidget {
  const OfflineUnavailableLine({required this.reason, super.key});

  final String reason;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.cloud_off_outlined,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            notAvailableOffline(reason),
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

/// Explains a control disabled because the core does not implement it.
///
/// [child] is returned untouched where [reason] is `null` — online, and
/// wherever the core does implement the operation.
class OfflineUnavailableTooltip extends StatelessWidget {
  const OfflineUnavailableTooltip({
    required this.reason,
    required this.child,
    super.key,
  });

  final String? reason;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reason = this.reason;
    if (reason == null) return child;
    return Tooltip(message: notAvailableOffline(reason), child: child);
  }
}
