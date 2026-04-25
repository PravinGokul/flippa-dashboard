import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../ui/widgets/glass/glass_container.dart';

class AvailabilityCalendar extends StatefulWidget {
  final String listingId;
  final double pricePerDay;
  const AvailabilityCalendar({super.key, required this.listingId, this.pricePerDay = 49.0});

  @override
  State<AvailabilityCalendar> createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<AvailabilityCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  double get _totalPrice {
    if (_rangeStart == null || _rangeEnd == null) return 0;
    final days = _rangeEnd!.difference(_rangeStart!).inDays + 1;
    return days * widget.pricePerDay;
  }

  int get _duration {
    if (_rangeStart == null || _rangeEnd == null) return 0;
    return _rangeEnd!.difference(_rangeStart!).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassContainer(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.calendar_month, size: 20, color: Color(0xFF1E1E2C)),
                  SizedBox(width: 8),
                  Text(
                    "Check Availability",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E1E2C)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                rangeSelectionMode: RangeSelectionMode.enforced,
                onRangeSelected: (start, end, focusedDay) {
                  setState(() {
                    _rangeStart = start;
                    _rangeEnd = end;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF1E1E2C),
                    shape: BoxShape.circle,
                  ),
                  rangeStartDecoration: const BoxDecoration(
                    color: Color(0xFF1E1E2C),
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: const BoxDecoration(
                    color: Color(0xFF1E1E2C),
                    shape: BoxShape.circle,
                  ),
                  rangeHighlightColor: const Color(0xFF1E1E2C).withOpacity(0.1),
                  markerDecoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: const TextStyle(color: Color(0xFF4B5563)),
                  weekendTextStyle: const TextStyle(color: Color(0xFF94A3B8)),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1E2C)),
                ),
              ),
              const SizedBox(height: 24),
              _buildDateInfoRow("Check-in", _rangeStart),
              const SizedBox(height: 12),
              _buildDateInfoRow("Check-out", _rangeEnd),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Duration", style: TextStyle(color: Color(0xFF64748B))),
                  Text("$_duration days", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total", style: TextStyle(color: Color(0xFF64748B))),
                  Text("₹${_totalPrice.toStringAsFixed(0)}", 
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF1E1E2C))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _rangeStart != null && _rangeEnd != null ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Reserving for $_duration days. Total: ₹${_totalPrice.toStringAsFixed(0)}"))
              );
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111827),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(
              _rangeStart != null && _rangeEnd != null 
                ? "Reserve - ₹${_totalPrice.toStringAsFixed(0)}" 
                : "Select Dates",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfoRow(String label, DateTime? date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B))),
        Text(
          date != null ? "${date.day}/${date.month}/${date.year}" : "-- / -- / --",
          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E1E2C)),
        ),
      ],
    );
  }
}

