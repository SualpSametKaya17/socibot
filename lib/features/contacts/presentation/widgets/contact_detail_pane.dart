import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/route_paths.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/channel_badge.dart';
import '../../../../core/widgets/detail_field_row.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../conversations/domain/conversation_providers.dart';
import '../../domain/contact.dart';
import '../../domain/contact_providers.dart';

/// Region-4-equivalent for Contacts: the selected contact's details and
/// a way to jump to their conversation. Shares its visual language
/// (icon-chip field rows, 8px card radius) with the Inbox's
/// CustomerDetailPanel rather than having its own older style. Shows an
/// empty state when nothing is selected.
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
      loading: () => const _ContactDetailSkeleton(),
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

/// Shimmer placeholder shaped like [_ContactDetail], shown while
/// [contactsProvider] is still resolving.
class _ContactDetailSkeleton extends StatelessWidget {
  const _ContactDetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Skeletonizer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppAvatar(name: 'Loading name', radius: 28),
                  const Gap(AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Loading contact name',
                          style: AppTypography.headingSmall,
                        ),
                        const Gap(6),
                        Text(
                          'Loading channel',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: colors.border),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailFieldRow(
                      icon: Icons.email_outlined,
                      label: 'Loading email address',
                    ),
                    Gap(AppSpacing.sm),
                    DetailFieldRow(
                      icon: Icons.phone_outlined,
                      label: 'Loading phone number',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
                      if (contact.company != null) ...[
                        const Gap(2),
                        Text(
                          contact.company!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.textSecondary),
                        ),
                      ],
                      const Gap(6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChannelBadge(channel: contact.primaryChannel),
                          if (contact.location != null) ...[
                            const Gap(AppSpacing.sm),
                            Icon(
                              Icons.place_outlined,
                              size: 12,
                              color: colors.textMuted,
                            ),
                            const Gap(2),
                            Text(
                              contact.location!,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: colors.textMuted),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONTACT INFORMATION',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.textMuted,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(AppSpacing.md),
                  DetailFieldRow(
                    icon: Icons.email_outlined,
                    label: contact.email ?? 'No email on file',
                  ),
                  const Gap(AppSpacing.sm),
                  DetailFieldRow(
                    icon: Icons.phone_outlined,
                    label: contact.phone ?? 'No phone on file',
                  ),
                ],
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
