import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/backup_service.dart';
import '../../utils/backup_strings.dart';
import '../../viewmodels/game_notifier.dart';

class BackupSection extends ConsumerWidget {
  const BackupSection({super.key});

  Future<void> _export(BuildContext context) async {
    try {
      final json = BackupService.encodeSnapshot();
      final name = BackupService.suggestFileName();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsString(json);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/json')],
          subject: name,
        ),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(BackupStrings.exportOk)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(BackupStrings.exportFail)),
        );
      }
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(BackupStrings.confirmTitle),
        content: const Text(BackupStrings.confirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(BackupStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(BackupStrings.confirmAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      final pick = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['json'],
        withData: true,
      );
      if (pick == null || pick.files.isEmpty) {
        return;
      }
      final file = pick.files.single;
      late final String raw;
      if (file.bytes != null) {
        raw = utf8.decode(file.bytes!);
      } else if (file.path != null) {
        raw = await File(file.path!).readAsString();
      } else {
        throw BackupException('invalid');
      }

      final data = BackupService.parseAndValidate(raw);
      await BackupService.applyToHive(data);
      ref.read(gameProvider.notifier).reloadFromStore();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(BackupStrings.importOk)),
        );
      }
    } on BackupException catch (e) {
      if (!context.mounted) {
        return;
      }
      final msg = e.message == 'tooNew'
          ? BackupStrings.tooNew
          : BackupStrings.invalid;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(BackupStrings.invalid)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          BackupStrings.sectionTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          BackupStrings.sectionHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton.tonal(
              onPressed: () => _export(context),
              child: const Text(BackupStrings.export),
            ),
            OutlinedButton(
              onPressed: () => _import(context, ref),
              child: const Text(BackupStrings.import),
            ),
          ],
        ),
      ],
    );
  }
}
