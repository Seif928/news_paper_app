import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_paper_app/presentation/cubits/favorite/saved_cubit.dart';
import 'package:news_paper_app/presentation/widgets/app_drawer.dart';
import 'package:news_paper_app/presentation/widgets/saved_widgets/saved_article_card.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        centerTitle: true,
        title: Text("Saved".tr()),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () => context.read<SavedCubit>().clearSaved(),
              child: const Icon(Icons.delete_outline),
            ),
          ),
        ],
      ),

      body: BlocBuilder<SavedCubit, SavedState>(
        builder: (context, state) {
          if (state is SavedLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SavedError) {
            return Center(child: Text(state.message));
          }

          if (state is SavedLoaded) {
            if (state.articles.isEmpty) {
              return const _EmptyFavorites();
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: state.articles.reversed.length,
              itemBuilder: (context, index) {
                return SavedArticleCard(
                  article: state.articles.reversed.toList()[index],
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    context.locale;

    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 64,
              color: theme.colorScheme.secondary,
            ),

            const SizedBox(height: 16),

            Text(
              "No saved articles".tr(),
              style: theme.textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              "Articles you save will appear here.".tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
