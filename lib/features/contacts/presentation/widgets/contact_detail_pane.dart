import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/route_paths.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/channel_badge.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../conversations/domain/conversation_providers.dart';
import '../../domain/contact.dart';
import '../../domain/contact_providers.dart';

/// Region-4-equivalent for Contacts: the selected contact's details and
/// a way to jump to their conversation. Shows an empty state when
/// nothing is selected.
class ContactDetailPane extends ConsumerWidget {
  const ContactDetailPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedContactIdProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(
        key: ValueKey(selectedId),
        child: _buildBody(ref, selectedId),
      ),
    );
  }

  Widget _buildBody(WidgetRef ref, String? selectedId) {
    if (selectedId == null) {
      return const EmptyState(
        icon: Icons.person_outline,
        title: 'Select a contact',
        message: 'Choose a contact from the list to see their details.',
      );
    }

    final contactsAsync = ref.watch(contactsProvider);
    return contactsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => EmptyState(
        icon: Icons.error_outline,
        title: 'Could not load contact',
        message: '$error',
      ),
      data: (contacts) {
        final matches = contacts.where((c) => c.id == selectedId);
        final contact = matches.isEmpty ? null : matches.first;
        if (contact == null) {
          return const EmptyState(
            icon: Icons.person_outline,
            title: 'Select a contact',
            message: 'Choose a contact from the list to see their details.',
          );
        }
        return _ContactDetail(contact: contact);
      },
    );
  }
}

class _ContactDetail extends StatelessWidget {
  const _ContactDetail({required this.contact});

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppAvatar(
                  name: contact.displayName,
                  imageUrl: contact.avatarUrl,
                  radius: 28,
                ),
                const Gap(AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.displayName,
                        style: AppTypography.headingSmall,
                      ),
                      const Gap(4),
                      ChannelBadge(channel: contact.primaryChannel),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.xl),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTACT INFO',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.textMuted,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const Gap(AppSpacing.md),
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: contact.email ?? 'No email on file',
                    ),
                    const Gap(AppSpacing.sm),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: contact.phone ?? 'No phone on file',
                    ),
                  ],
                ),
              ),
            ),
            const Gap(AppSpacing.lg),
            Consumer(
              builder: (context, ref, _) {
                return ElevatedButton.icon(
                  onPressed: () {
                    ref.read(selectedConversationIdProvider.notifier).state =
                        contact.conversationId;
                    // No-op on desktop (already the root route); on
                    // mobile this is a pushed detail page, so pop back
                    // to the shell first or `go` would leave it stuck on
                    // top.
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    context.go(RoutePaths.inbox);
                  },
                  icon: const Icon(Icons.forum_outlined, size: 18),
                  label: const Text('View conversation'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.textMuted),
        const Gap(AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: colors.textPrimary),
          ),
        ),
      ],
    );
  }
}
