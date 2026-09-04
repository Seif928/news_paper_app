import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/core/service/service_locator.dart'
    as service_locator;
import 'package:news_paper_app/presentation/cubits/search/search_cubit.dart';
import 'package:news_paper_app/presentation/widgets/search_widgets/search_view.dart';

class SearchPage extends StatelessWidget {
  final bool autoFocus;
  const SearchPage({super.key, required this.autoFocus});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => service_locator.sl<SearchCubit>(),
      child: const SearchView(),
    );
  }
}
