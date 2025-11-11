import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/account/representative/providers/rep_provider.dart';
import 'package:group_trip/features/account/representative/data/rep_model.dart';



class TourListPage extends ConsumerWidget {
  const TourListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repsAsync = ref.watch(repListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn vị tổ chức'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: repsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Lỗi: $err')),
        data: (reps) {
          if (reps.isEmpty) {
            return const Center(child: Text('Không có đơn vị tổ chức'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reps.length,
            itemBuilder: (context, index) {
              final RepModel rep = reps[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    // Navigate to detail screen
                    context.push('/representative/detail');
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rep?.contactName ?? 'No contact name',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            rep?.description ?? 'No description',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget filterButton(String text, {bool selected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: selected ? Colors.blue : Colors.white,
          foregroundColor: selected ? Colors.white : Colors.black,
          side: BorderSide(color: selected ? Colors.blue : Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(text),
      ),
    );
  }
}
