import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/tokens/app_radius.dart';
import '/core/theme/tokens/app_spacing.dart';
import '/core/network/api_endpoints.dart';
import '/core/widgets/custom_header_layout.dart';
import '../../data/models/merchant.dart';
import '../../data/models/product.dart';
import '../providers/marketplace_provider.dart';
import '../providers/orders_provider.dart';
import 'merchant_edit_screen.dart';
import 'merchant_product_form_screen.dart';

/// The owner's self-service view of a single business they run: profile
/// (with edit/delete), the products they sell, and order/delivery/revenue
/// tracking scoped to just this business.
class MerchantManageScreen extends ConsumerStatefulWidget {
  final Merchant merchant;
  const MerchantManageScreen({super.key, required this.merchant});

  @override
  ConsumerState<MerchantManageScreen> createState() => _MerchantManageScreenState();
}

class _MerchantManageScreenState extends ConsumerState<MerchantManageScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(Merchant merchant) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this business?'),
        content: Text('This permanently removes "${merchant.businessName}" and cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await deleteMerchant(ref, merchantId: merchant.id);
      ref.invalidate(myMerchantsProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _deleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not delete. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Prefer the freshest copy once the list has reloaded (e.g. after an
    // edit), falling back to whatever was passed in on first build.
    final merchantsAsync = ref.watch(myMerchantsProvider);
    final merchant = merchantsAsync.maybeWhen(
      data: (list) => list.firstWhere((m) => m.id == widget.merchant.id, orElse: () => widget.merchant),
      orElse: () => widget.merchant,
    );

    return CustomHeaderLayout(
      title: merchant.businessName,
      showSearchBar: false,
      tabController: _tabController,
      tabs: const ['About', 'Products', 'Orders', 'Delivery', 'Transactions'],
      body: TabBarView(
        controller: _tabController,
        children: [
          _AboutTab(
            merchant: merchant,
            deleting: _deleting,
            onEdit: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MerchantEditScreen(merchant: merchant)),
            ),
            onDelete: () => _confirmDelete(merchant),
          ),
          _ProductsTab(merchantId: merchant.id),
          _OrdersTab(merchantId: merchant.id, deliveryOnly: false),
          _OrdersTab(merchantId: merchant.id, deliveryOnly: true),
          _TransactionsTab(merchantId: merchant.id),
        ],
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  final Merchant merchant;
  final bool deleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AboutTab({required this.merchant, required this.deleting, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final (icon, color, label) = switch (merchant.status) {
      'approved' => (LucideIcons.circleCheck, colors.successColor, 'Approved'),
      'rejected' => (LucideIcons.circleX, colors.destructiveColor, 'Rejected'),
      _ => (LucideIcons.clock, colors.warningColor, 'Pending Review'),
    };

    return ListView(
      padding: const EdgeInsets.all(Spacing.lg),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceAltBg,
                border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
              ),
              child: merchant.logoUrl.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        ApiEndpoints.resolveImageUrl(merchant.logoUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(LucideIcons.store, color: colors.primaryColor.withValues(alpha: 0.6)),
                      ),
                    )
                  : Icon(LucideIcons.store, color: colors.primaryColor.withValues(alpha: 0.6)),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(merchant.businessName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  const SizedBox(height: Spacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 2),
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: RadiusToken.circular(RadiusToken.full)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 11, color: color),
                        const SizedBox(width: 4),
                        Text(label.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (merchant.status == 'rejected' && (merchant.rejectionReason ?? '').isNotEmpty) ...[
          const SizedBox(height: Spacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(color: colors.destructiveColor.withValues(alpha: 0.08), borderRadius: RadiusToken.circular(RadiusToken.md)),
            child: Text('Reason: ${merchant.rejectionReason}', style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
          ),
        ],
        const SizedBox(height: Spacing.lg),
        if (merchant.description.isNotEmpty) ...[
          Text(merchant.description, style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 13.5)),
          const SizedBox(height: Spacing.lg),
        ],
        _InfoRow(icon: LucideIcons.tag, label: 'Business Type', value: merchant.businessType),
        _InfoRow(icon: LucideIcons.phone, label: 'Phone', value: merchant.phone),
        _InfoRow(icon: LucideIcons.mail, label: 'Email', value: merchant.email),
        _InfoRow(icon: LucideIcons.globe, label: 'Website', value: merchant.website ?? ''),
        _InfoRow(icon: LucideIcons.link, label: 'Social Media', value: merchant.socialMediaLink ?? ''),
        const SizedBox(height: Spacing.xl),
        OutlinedButton.icon(
          onPressed: onEdit,
          icon: const Icon(LucideIcons.pencil, size: 16),
          label: const Text('Edit Business'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 46),
            shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.md)),
          ),
        ),
        const SizedBox(height: Spacing.sm),
        OutlinedButton.icon(
          onPressed: deleting ? null : onDelete,
          icon: deleting
              ? const SizedBox(height: 14, width: 14, child: CupertinoActivityIndicator())
              : const Icon(LucideIcons.trash2, size: 16, color: Colors.red),
          label: Text(deleting ? 'Deleting...' : 'Delete Business', style: const TextStyle(color: Colors.red)),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 46),
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(borderRadius: RadiusToken.circular(RadiusToken.md)),
          ),
        ),
        const SizedBox(height: Spacing.xl),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                Text(value, style: const TextStyle(fontSize: 13.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsTab extends ConsumerWidget {
  final String merchantId;
  const _ProductsTab({required this.merchantId});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this product?'),
        content: Text('"${product.title}" will be removed from your storefront.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await deleteMyProduct(ref, merchantId: merchantId, productId: product.id);
      ref.invalidate(myMerchantProductsProvider(merchantId));
      ref.invalidate(merchantProductsProvider(merchantId));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not delete product.')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(myMerchantProductsProvider(merchantId));
    return Stack(
      children: [
        productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return Center(child: Text('No products yet. Tap + to add one.', style: TextStyle(color: Colors.grey.shade500)));
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 640 ? 4 : width >= 480 ? 3 : 2;
                return MasonryGridView.builder(
                  padding: const EdgeInsets.fromLTRB(Spacing.lg, Spacing.lg, Spacing.lg, 80),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, i) => _ProductCard(
                    product: products[i],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MerchantProductFormScreen(merchantId: merchantId, product: products[i]),
                      ),
                    ),
                    onDelete: () => _confirmDelete(context, ref, products[i]),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => Center(child: Text('Could not load products.', style: TextStyle(color: Colors.grey.shade500))),
        ),
        Positioned(
          right: Spacing.lg,
          bottom: Spacing.lg,
          child: FloatingActionButton.extended(
            heroTag: 'add-product-$merchantId',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => MerchantProductFormScreen(merchantId: merchantId)),
            ),
            icon: const Icon(LucideIcons.plus),
            label: const Text('Add Product'),
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const _ProductCard({required this.product, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageUrl = product.imageUrls.isNotEmpty ? product.imageUrls.first : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: RadiusToken.circular(RadiusToken.lg),
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(RadiusToken.lg)),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            ApiEndpoints.resolveImageUrl(imageUrl),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: Colors.grey.shade100,
                              child: Icon(LucideIcons.shoppingBag, color: Colors.grey.shade400),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade100,
                            child: Icon(LucideIcons.shoppingBag, color: Colors.grey.shade400),
                          ),
                  ),
                  if (!product.isPublished)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(6)),
                        child: const Text('DRAFT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                        child: const Icon(LucideIcons.trash2, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, height: 1.2),
                  ),
                  const SizedBox(height: 4),
                  Text('৳${product.price}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _orderStatusColor(String status) {
  switch (status) {
    case 'pending_payment':
      return Colors.amber;
    case 'paid':
      return Colors.blue;
    case 'processing':
      return Colors.indigo;
    case 'shipped':
      return Colors.purple;
    case 'delivered':
      return Colors.green;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String _orderStatusLabel(String status) {
  switch (status) {
    case 'pending_payment':
      return 'Pending Payment';
    case 'paid':
      return 'Paid';
    case 'processing':
      return 'Processing';
    case 'shipped':
      return 'Shipped';
    case 'delivered':
      return 'Delivered';
    case 'cancelled':
      return 'Cancelled';
    default:
      return status;
  }
}

const _deliveryStatuses = {'paid', 'processing', 'shipped'};

// The only forward transition a merchant may trigger themselves for a given
// current status — null means no self-service action applies (e.g. already
// delivered, or still awaiting payment).
String? _nextFulfillmentStatus(String status) {
  switch (status) {
    case 'paid':
    case 'processing':
      return 'shipped';
    case 'shipped':
      return 'delivered';
    default:
      return null;
  }
}

String _fulfillmentActionLabel(String nextStatus) => nextStatus == 'shipped' ? 'Mark Shipped' : 'Mark Delivered';

class _OrdersTab extends ConsumerStatefulWidget {
  final String merchantId;
  final bool deliveryOnly;
  const _OrdersTab({required this.merchantId, required this.deliveryOnly});

  @override
  ConsumerState<_OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends ConsumerState<_OrdersTab> {
  String? _updatingOrderId;

  Future<void> _markAs(String orderId, String nextStatus) async {
    setState(() => _updatingOrderId = orderId);
    try {
      await updateMerchantOrderStatus(
        ref,
        merchantId: widget.merchantId,
        orderId: orderId,
        status: nextStatus,
      );
      ref.invalidate(merchantOrdersProvider(widget.merchantId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not update order status.')));
      }
    } finally {
      if (mounted) setState(() => _updatingOrderId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(merchantOrdersProvider(widget.merchantId));
    return ordersAsync.when(
      data: (orders) {
        final filtered = widget.deliveryOnly ? orders.where((o) => _deliveryStatuses.contains(o.status)).toList() : orders;
        if (filtered.isEmpty) {
          return Center(
            child: Text(
              widget.deliveryOnly ? 'No orders awaiting delivery.' : 'No orders yet.',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(Spacing.lg),
          itemCount: filtered.length,
          itemBuilder: (context, i) {
            final order = filtered[i];
            final myTotal = order.items.fold<int>(0, (sum, item) => sum + item.totalPrice);
            final nextStatus = _nextFulfillmentStatus(order.status);
            final isUpdating = _updatingOrderId == order.id;
            return Card(
              margin: const EdgeInsets.only(bottom: Spacing.md),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      isThreeLine: true,
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${order.shippingRecipientName} · ${order.shippingCity}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          const SizedBox(height: 4),
                          Text('৳$myTotal', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _orderStatusColor(order.status).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _orderStatusLabel(order.status),
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _orderStatusColor(order.status)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (nextStatus != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: isUpdating ? null : () => _markAs(order.id, nextStatus),
                            icon: isUpdating
                                ? const SizedBox(height: 14, width: 14, child: CupertinoActivityIndicator())
                                : const Icon(LucideIcons.truck, size: 16),
                            label: Text(_fulfillmentActionLabel(nextStatus)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (e, _) => Center(child: Text('Could not load orders.', style: TextStyle(color: Colors.grey.shade500))),
    );
  }
}

class _TransactionsTab extends ConsumerWidget {
  final String merchantId;
  const _TransactionsTab({required this.merchantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final ordersAsync = ref.watch(merchantOrdersProvider(merchantId));

    return ordersAsync.when(
      data: (orders) {
        final completed = orders.where((o) => o.status == 'delivered').toList();
        final grossTotal = completed.fold<int>(0, (sum, o) => sum + o.items.fold<int>(0, (s, i) => s + i.totalPrice));
        final netTotal = completed.fold<double>(0, (sum, o) => sum + o.items.fold<double>(0, (s, i) => s + i.netPayout));

        return ListView(
          padding: const EdgeInsets.all(Spacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(color: colors.primaryColor.withValues(alpha: 0.08), borderRadius: RadiusToken.circular(RadiusToken.lg)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gross Revenue', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text('৳$grossTotal', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Net Payout', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text('৳${netTotal.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: colors.primaryColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.lg),
            if (completed.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.xxl),
                child: Center(child: Text('No completed transactions yet.', style: TextStyle(color: Colors.grey.shade500))),
              )
            else
              ...completed.map((order) {
                final orderGross = order.items.fold<int>(0, (s, i) => s + i.totalPrice);
                final orderNet = order.items.fold<double>(0, (s, i) => s + i.netPayout);
                return Card(
                  margin: const EdgeInsets.only(bottom: Spacing.sm),
                  child: ListTile(
                    title: Text('Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}'),
                    subtitle: Text('${order.items.length} item${order.items.length == 1 ? '' : 's'} · Gross ৳$orderGross'),
                    trailing: Text('৳${orderNet.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, color: colors.primaryColor)),
                  ),
                );
              }),
          ],
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (e, _) => Center(child: Text('Could not load transactions.', style: TextStyle(color: Colors.grey.shade500))),
    );
  }
}
