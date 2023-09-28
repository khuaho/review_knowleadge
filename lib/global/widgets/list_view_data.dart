import 'package:flutter/material.dart';

class ListViewData<T> extends StatelessWidget {
  const ListViewData({
    super.key,
    required this.loading,
    this.display,
    required this.list,
    this.error,
  });
  final bool loading;
  final String? error;
  final List<T> list;
  final Widget? display;

  @override
  Widget build(BuildContext context) {
    if (loading == true) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (loading == false && error != null) {
      return Center(
        child: Text('Err: $error'),
      );
    }

    if (list.isEmpty) {
      return const Center(
        child: Text('Data Not Found'),
      );
    }

    return display ?? const SizedBox();
  }
}
