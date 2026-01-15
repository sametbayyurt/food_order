import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/data/entity/order.dart';
import 'package:food_order/ui/cubit/cart_cubit.dart';
import 'package:food_order/services/order_service.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  int? selectedTable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6A00),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Sipariş Özeti",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      bottomNavigationBar: BlocBuilder<CartCubit, List<Order>>(
        builder: (context, orders) {
          final total = context.read<CartCubit>().totalPrice;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              border: Border(top: BorderSide(color: Colors.white12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedTable,
                  dropdownColor: Colors.grey[900],
                  decoration: const InputDecoration(
                    labelText: "Masa Numarası",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF6A00)),
                    ),
                  ),
                  items: List.generate(
                    20,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text(
                        "Masa ${index + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedTable = value;
                    });
                  },
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Toplam: ${total.toStringAsFixed(2)} ₺",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (selectedTable != null)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6A00),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _createOrder(context, orders);
                        },
                        child: const Text(
                          "Sipariş Oluştur",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),

      body: BlocBuilder<CartCubit, List<Order>>(
        builder: (context, orders) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF121212),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${order.name} x${order.quantity}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      "${(order.price * order.quantity).toStringAsFixed(2)} ₺",
                      style: const TextStyle(
                        color: Color(0xFFFF6A00),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _createOrder(BuildContext context, List<Order> orders) async {
    final cartCubit = context.read<CartCubit>();
    final orderService = OrderService();

    await orderService.createOrder(
      tableNumber: selectedTable!,
      orders: orders,
      totalPrice: cartCubit.totalPrice,
    );

    cartCubit.clearCart();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sipariş başarıyla oluşturuldu"),
        backgroundColor: Color(0xFFFF6A00),
      ),
    );

    Navigator.pop(context);
  }
}
