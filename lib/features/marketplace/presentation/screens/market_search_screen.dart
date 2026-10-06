import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/di.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/features/auth/presentation/providers/user_profile_provider.dart';
import '../../data/models/product.dart';
import '../providers/marketplace_provider.dart';
import '../widgets/market_product_card.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/theme/tokens/app_font_size.dart';

enum _Sort {
  newest('new', 'Newest'),
  priceAsc('price_asc', 'Price: low to high'),
  priceDesc('price_desc', 'Price: high to low'),
  topRated('top_rated', 'Top rated'),
  popular('popular', 'Most viewed');

  final String api;
  final String label;
  const _Sort(this.api, this.label);
}

/// Search the campus market with filters and sorting. Results page in as you scroll.
class MarketSearchScreen extends ConsumerStatefulWidget {
  const MarketSearchScreen({super.key});

  @override
  ConsumerState<MarketSearchScreen> createState() => _MarketSearchScreenState();
}

class _MarketSearchScreenState extends ConsumerState<MarketSearchScreen> {
  static const _pageSize = 20;

  final _controller = TextEditingController();
  final _scroll = ScrollController();
  Timer? _debounce;

  _Sort _sort = _Sort.newest;
  bool _inStock = false;
  RangeValues? _price; // null = any
  String? _categoryId;

  final List<Product> _results = [];
  int _total = 0;
  bool _loading = false;
  bool _failed = false;
  bool _hasMore = true;
  int _generation = 0; // discards responses from superseded searches

  static const double _maxPrice = 5000;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 400) _load(more: true);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _onQueryChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _load);
  }

  Future<void> _load({bool more = false}) async {
    final user = ref.read(userProvider).value;
    if (user == null || (more && (_loading || !_hasMore))) return;

    final gen = more ? _generation : ++_generation;
    setState(() {
      _loading = true;
      _failed = false;
      if (!more) {
        _results.clear();
        _hasMore = true;
      }
    });
    try {
      final response = await ref.read(apiClientProvider).get(
        '/products-by-location',
        queryParameters: {
          'university_id': user.university,
          'department_id': user.department,
          if (_controller.text.trim().isNotEmpty) 'q': _controller.text.trim(),
          if (_categoryId != null) 'category_id': _categoryId,
          if (_inStock) 'in_stock': 'true',
          if (_price != null) 'min_price': _price!.start.round(),
          if (_price != null && _price!.end < _maxPrice) 'max_price': _price!.end.round(),
          'sort': _sort.api,
          'limit': _pageSize,
          'offset': more ? _results.length : 0,
        },
      );
      if (!mounted || gen != _generation) return;
      final raw = response.data as List;
      final page = raw.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
      setState(() {
        _results.addAll(page);
        _total = int.tryParse(response.headers.value('x-total-count') ?? '') ?? _results.length;
        _hasMore = page.length == _pageSize;
        _loading = false;
      });
    } catch (_) {
      if (!mounted || gen != _generation) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  void _apply(VoidCallback change) {
    setState(change);
    _load();
  }

  Future<void> _openPriceSheet() async {
    var range = _price ?? const RangeValues(0, _maxPrice);
    final result = await showModalBottomSheet<RangeValues?>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: const EdgeInsets.fromLTRB(Spacing.xl, 0, Spacing.xl, Spacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price range', style: TextStyle(fontSize: FontSizeToken.xl, fontWeight: FontWeight.w800, color: ctx.colors.text)),
              const SizedBox(height: Spacing.xs),
              Text(
                '৳${range.start.round()} – ${range.end >= _maxPrice ? '৳${_maxPrice.round()}+' : '৳${range.end.round()}'}',
                style: TextStyle(color: ctx.colors.textMuted),
              ),
              RangeSlider(
                values: range,
                min: 0,
                max: _maxPrice,
                divisions: 50,
                onChanged: (v) => setSheet(() => range = v),
              ),
              Row(
                children: [
                  TextButton(onPressed: () => Navigator.pop(ctx, const RangeValues(-1, -1)), child: const Text('Clear')),
                  const Spacer(),
                  FilledButton(onPressed: () => Navigator.pop(ctx, range), child: const Text('Apply')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (result == null) return;
    _apply(() => _price = result.start < 0 ? null : result);
  }

  Future<void> _openSortSheet() async {
    final picked = await showModalBottomSheet<_Sort>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final s in _Sort.values)
              ListTile(
                title: Text(s.label),
                trailing: s == _sort ? Icon(LucideIcons.check, color: ctx.colors.primary) : null,
                onTap: () => Navigator.pop(ctx, s),
              ),
          ],
        ),
      ),
    );
    if (picked != null) _apply(() => _sort = picked);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final categories = ref.watch(categoriesListProvider).value ?? const [];
    final hasFilters = _inStock || _price != null || _categoryId != null;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          height: 42,
          margin: const EdgeInsets.only(right: Spacing.lg),
          decoration: BoxDecoration(
            color: c.surfaceAlt,
            borderRadius: BorderRadius.circular(RadiusToken.xxl),
            border: Border.all(color: c.border),
          ),
          child: TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: _onQueryChanged,
            onSubmitted: (_) => _load(),
            decoration: InputDecoration(
              hintText: 'Search the campus market',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              prefixIcon: Icon(LucideIcons.search, size: 18, color: c.textSubtle),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(LucideIcons.x, size: 16, color: c.textSubtle),
                      onPressed: () {
                        _controller.clear();
                        _load();
                      },
                    ),
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            children: [
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.sm),
                  children: [
                    ActionChip(
                      avatar: const Icon(LucideIcons.arrowUpDown, size: 14),
                      label: Text(_sort.label),
                      onPressed: _openSortSheet,
                    ),
                    const SizedBox(width: Spacing.sm),
                    ActionChip(
                      avatar: const Icon(LucideIcons.banknote, size: 14),
                      label: Text(_price == null
                          ? 'Price'
                          : '৳${_price!.start.round()}–${_price!.end >= _maxPrice ? '${_maxPrice.round()}+' : _price!.end.round()}'),
                      onPressed: _openPriceSheet,
                    ),
                    const SizedBox(width: Spacing.sm),
                    FilterChip(
                      label: const Text('In stock'),
                      selected: _inStock,
                      onSelected: (v) => _apply(() => _inStock = v),
                    ),
                    for (final cat in categories) ...[
                      const SizedBox(width: Spacing.sm),
                      FilterChip(
                        label: Text(cat.name),
                        selected: _categoryId == cat.id,
                        onSelected: (v) => _apply(() => _categoryId = v ? cat.id : null),
                      ),
                    ],
                    if (hasFilters) ...[
                      const SizedBox(width: Spacing.sm),
                      ActionChip(
                        label: const Text('Clear'),
                        onPressed: () => _apply(() {
                          _inStock = false;
                          _price = null;
                          _categoryId = null;
                        }),
                      ),
                    ],
                  ],
                ),
              ),
              Expanded(child: _body(c)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(AppColors c) {
    if (_results.isEmpty) {
      if (_loading) return const Center(child: CupertinoActivityIndicator());
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xxxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_failed ? LucideIcons.wifiOff : LucideIcons.searchX, size: 40, color: c.textSubtle),
              const SizedBox(height: Spacing.md),
              Text(
                _failed ? 'Could not load results.' : 'Nothing matches your search.',
                style: TextStyle(fontWeight: FontWeight.w700, color: c.text),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                _failed ? 'Check your connection and try again.' : 'Try a different word or clear some filters.',
                textAlign: TextAlign.center,
                style: TextStyle(color: c.textMuted, fontSize: 12.5),
              ),
              if (_failed) TextButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    return CustomScrollView(
      controller: _scroll,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.xs, Spacing.lg, Spacing.md),
            child: Text('$_total result${_total == 1 ? '' : 's'}', style: TextStyle(fontSize: FontSizeToken.sm, color: c.textSubtle)),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
          sliver: SliverMasonryGrid.extent(
            maxCrossAxisExtent: 180,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childCount: _results.length,
            itemBuilder: (context, i) => MarketProductCard(product: _results[i]),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.xxl),
            child: Center(child: _loading ? const CupertinoActivityIndicator() : const SizedBox.shrink()),
          ),
        ),
      ],
    );
  }
}
