import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _monthNames = [
  'Janvier',
  'Février',
  'Mars',
  'Avril',
  'Mai',
  'Juin',
  'Juillet',
  'Août',
  'Septembre',
  'Octobre',
  'Novembre',
  'Décembre',
];

/// A two-wheel month/year picker restricted to a fixed list of selectable
/// months (typically the months that actually contain photos).
///
/// The year wheel and the month wheel scroll independently so that a user
/// with photos spanning many years doesn't have to scroll through a long
/// flat list to reach an older year. Selecting a year updates the month
/// wheel to only show the months that are available for that year.
class MonthYearPicker extends StatefulWidget {
  const MonthYearPicker({
    super.key,
    required this.availableMonths,
    this.initialMonth,
  }) : assert(availableMonths.length > 0);

  /// The first day of each selectable month, sorted chronologically.
  final List<DateTime> availableMonths;
  final DateTime? initialMonth;

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();

  /// Shows the picker as a modal bottom sheet and returns the [DateTimeRange]
  /// spanning the first to the last day of the picked month, or null if
  /// cancelled.
  static Future<DateTimeRange?> show(
    BuildContext context, {
    required List<DateTime> availableMonths,
    DateTime? initialMonth,
  }) {
    return showModalBottomSheet<DateTimeRange>(
      context: context,
      isScrollControlled: true,
      builder: (context) => MonthYearPicker(
        availableMonths: availableMonths,
        initialMonth: initialMonth,
      ),
    );
  }
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  late final List<int> _availableYears;
  late final Map<int, List<int>> _monthsByYear;
  late final FixedExtentScrollController _yearController;
  late FixedExtentScrollController _monthController;

  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();

    final monthsByYear = <int, List<int>>{};
    for (final month in widget.availableMonths) {
      (monthsByYear[month.year] ??= <int>[]).add(month.month);
    }
    _monthsByYear = monthsByYear;
    _availableYears = monthsByYear.keys.toList()..sort();

    final initial = widget.initialMonth;
    if (initial != null &&
        (_monthsByYear[initial.year]?.contains(initial.month) ?? false)) {
      _selectedYear = initial.year;
      _selectedMonth = initial.month;
    } else {
      _selectedYear = _availableYears.first;
      _selectedMonth = _monthsByYear[_selectedYear]!.first;
    }

    _yearController = FixedExtentScrollController(
      initialItem: _availableYears.indexOf(_selectedYear),
    );
    _monthController = FixedExtentScrollController(
      initialItem: _monthsForSelectedYear.indexOf(_selectedMonth),
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  List<int> get _monthsForSelectedYear => _monthsByYear[_selectedYear]!;

  void _onYearChanged(int index) {
    final year = _availableYears[index];
    if (year == _selectedYear) return;

    final months = _monthsByYear[year]!;
    final newMonth = months.contains(_selectedMonth)
        ? _selectedMonth
        : months.first;

    final oldMonthController = _monthController;
    setState(() {
      _selectedYear = year;
      _selectedMonth = newMonth;
      _monthController = FixedExtentScrollController(
        initialItem: months.indexOf(newMonth),
      );
    });
    oldMonthController.dispose();
  }

  void _onMonthChanged(int index) {
    setState(() => _selectedMonth = _monthsForSelectedYear[index]);
  }

  void _confirm() {
    final start = DateTime(_selectedYear, _selectedMonth);
    final firstOfNextMonth = DateTime(_selectedYear, _selectedMonth + 1);
    final end = firstOfNextMonth.subtract(const Duration(seconds: 1));

    Navigator.of(context).pop(DateTimeRange(start: start, end: end));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final months = _monthsForSelectedYear;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Filtrer par mois',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(
              height: 160,
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      key: ValueKey(_selectedYear),
                      scrollController: _monthController,
                      itemExtent: 40,
                      onSelectedItemChanged: _onMonthChanged,
                      children: [
                        for (final month in months)
                          Center(child: Text(_monthNames[month - 1])),
                      ],
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: _yearController,
                      itemExtent: 40,
                      onSelectedItemChanged: _onYearChanged,
                      children: [
                        for (final year in _availableYears)
                          Center(child: Text('$year')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _confirm,
                      child: const Text('Appliquer'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
