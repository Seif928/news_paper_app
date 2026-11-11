import 'package:flutter/material.dart';
import 'package:news_paper_app/core/utils/responsive.dart';

/// A lazily built grid whose column count is derived from the available
/// width.
///
/// Every row sizes itself to its tallest card, so cards never overflow
/// (regardless of title length or the user's text scale) and cards on the
/// same row always line up. Rows are built on demand by a [SliverList].
///
/// Children must support intrinsic sizing (avoid `LayoutBuilder` inside
/// grid items).
class SliverResponsiveGrid extends StatelessWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double minItemWidth;
  final int maxColumns;
  final double? spacing;

  const SliverResponsiveGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minItemWidth = 280,
    this.maxColumns = 4,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        final gap = spacing ?? LayoutSizes.gridSpacing(ScreenSize.fromWidth(width));
        final columns = Responsive.columnsFor(
          width,
          minItemWidth: minItemWidth,
          spacing: gap,
          maxColumns: maxColumns,
        );
        final rowCount = (itemCount / columns).ceil();

        return SliverList.builder(
          itemCount: rowCount,
          itemBuilder: (context, row) {
            final children = <Widget>[];
            for (var col = 0; col < columns; col++) {
              final index = row * columns + col;
              if (col > 0) children.add(SizedBox(width: gap));
              children.add(
                Expanded(
                  child:
                      index < itemCount
                          ? itemBuilder(context, index)
                          : const SizedBox.shrink(),
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.only(bottom: row == rowCount - 1 ? 0 : gap),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
