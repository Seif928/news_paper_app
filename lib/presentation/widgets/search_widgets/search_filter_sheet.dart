import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/presentation/cubits/search/search_cubit.dart';

class SearchFilterSheet extends StatefulWidget {
  const SearchFilterSheet({super.key});

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();

  static Future<void> show(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => BlocProvider.value(
            value: cubit,
            child: const SearchFilterSheet(),
          ),
    );
  }
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  String? _sortBy;
  String? _language;
  DateTime? _from;
  DateTime? _to;
  String? _sources;

  static Map<String, String> sortOptions = {
    'relevance': 'Relevance'.tr(),
    'popularity': 'Popularity'.tr(),
    'publishedAt': 'PublishedAt'.tr(),
  };

  static Map<String, String> languageOptions = {
    'ar': 'Arabic'.tr(),
    'en': 'English'.tr(),
    'de': 'German'.tr(),
    'fr': 'French'.tr(),
    'ru': 'Russian'.tr(),
    'it': 'Italian'.tr(),
    'es': 'Spanish'.tr(),
    'pt': 'Portuguese'.tr(),
    'zh': 'Chinese'.tr(),
    'ja': 'Japanese'.tr(),
    'ko': 'Korean'.tr(),
  };

  @override
  Widget build(BuildContext context) {
    context.locale;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),

                _buildSectionTitle('Sort by'.tr()),
                const SizedBox(height: 8),
                _buildChipsGroup(
                  options: sortOptions,
                  selected: _sortBy,
                  onSelected: (value) => setState(() => _sortBy = value),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('Language'.tr()),
                const SizedBox(height: 8),
                _buildChipsGroup(
                  options: languageOptions,
                  selected: _language,
                  onSelected: (value) => setState(() => _language = value),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle("Date".tr()),
                const SizedBox(height: 8),
                _buildDateRangePicker(),
                const SizedBox(height: 24),

                _buildSectionTitle("Sources".tr()),
                const SizedBox(height: 8),
                _buildSourcesField(),
                const SizedBox(height: 32),

                _buildActionButtons(),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filters'.tr(),
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: _clearAll, child: Text("Clear All".tr())),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildChipsGroup({
    required Map<String, String> options,
    required String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          options.entries.map((entry) {
            final isSelected = selected == entry.key;
            return ChoiceChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (_) {
                onSelected(isSelected ? null : entry.key);
              },
            );
          }).toList(),
    );
  }

  Widget _buildDateRangePicker() {
    return Row(
      children: [
        Expanded(
          child: _DateField(
            label: 'From'.tr(),
            date: _from,
            onTap: () => _pickDate(isFrom: true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DateField(
            label: 'To'.tr(),
            date: _to,
            onTap: () => _pickDate(isFrom: false),
          ),
        ),
      ],
    );
  }

  Widget _buildSourcesField() {
    return TextField(
      onChanged:
          (value) => _sources = value.trim().isEmpty ? null : value.trim(),
      controller: TextEditingController(text: _sources),
      decoration: InputDecoration(
        hintText: 'Example: bbc-news, cnn'.tr(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text('Cancel'.tr()),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _applyFilters,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text('Apply'.tr()),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initialDate = (isFrom ? _from : _to) ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2026, 8, 10),
      lastDate: DateTime(2026, 9, 11),
    );

    if (picked == null) return;

    setState(() {
      if (isFrom) {
        _from = picked;
      } else {
        _to = picked;
      }
    });
  }

  void _clearAll() {
    setState(() {
      _sortBy = null;
      _language = null;
      _from = null;
      _to = null;
      _sources = null;
    });
  }

  void _applyFilters() {
    context.read<SearchCubit>().updateFilter(
      sortBy: _sortBy,
      language: _language,
      from: _from,
      to: _to,
      sources: _sources,
    );

    context.read<SearchCubit>().applyFilters();

    Navigator.pop(context);
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date == null
                  ? label
                  : '${date!.year}/${date!.month}/${date!.day}',
              style: TextStyle(
                color: date == null ? Theme.of(context).hintColor : null,
              ),
            ),
            const Icon(Icons.calendar_today, size: 18),
          ],
        ),
      ),
    );
  }
}
