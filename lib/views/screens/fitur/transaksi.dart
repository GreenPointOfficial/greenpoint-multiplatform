import 'package:flutter/material.dart';
import 'package:greenpoint/assets/constants/greenpoint_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greenpoint/models/notifikasi_model.dart';
import 'package:greenpoint/providers/notifikasi_provider.dart';
import 'package:greenpoint/providers/user_provider.dart';
import 'package:greenpoint/views/widget/tombol_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:greenpoint/controllers/payout_controller.dart'; // Import your controller

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({Key? key}) : super(key: key);

  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  String? _selectedEwallet;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false; // Add this variable to track loading state

  void _selectEwallet(String ewallet) {
    setState(() {
      _selectedEwallet = ewallet;
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchUserData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payoutController = Provider.of<PayoutController>(context);

    return Scaffold(
      backgroundColor: GreenPointColor.secondary,
      appBar: AppBar(
        backgroundColor: GreenPointColor.secondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 24,
        ),
        title: Text(
          "Tukar Poin",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 20),
              _buildEwalletOptions(),
              const SizedBox(height: 10),
              _buildAmountInput(),
              const SizedBox(height: 10),
              _buildPhoneNumberInput(),
              const SizedBox(height: 10),
              _buildDisclaimer(),
              const SizedBox(height: 20),
              TombolWidget(
                warna: GreenPointColor.primary,
                warnaText: Colors.white,
                text: "Tukar",
                onPressed: () async {
                  double amount =
                      double.tryParse(_amountController.text) ?? 0.0;
                  String phone = _phoneController.text;
                  String? ewalletChannel = _selectedEwallet;

                  // Ensure all required fields are filled
                  if (amount > 0 &&
                      phone.isNotEmpty &&
                      ewalletChannel != null) {
                    final success = await payoutController.createPayout(
                      amount: amount,
                      accountNumber: phone,
                    );

                    if (success) {
                      // Update user data after successful transaction
                      Provider.of<UserProvider>(context, listen: false)
                          .autoRefreshUserData({
                        'poin':
                            Provider.of<UserProvider>(context, listen: false)
                                    .poin -
                                (amount.toInt() * 10)
                      });

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Text(
                            'Transaksi Sukses!',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          content: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxHeight: 300), // Maksimal tinggi
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Provider: Xendit',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Divider(color: GreenPointColor.secondary),
                                _buildReceiptDetailRow(
                                    'Nama',
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .userName),
                                _buildReceiptDetailRow('Nomor HP', phone),
                                _buildReceiptDetailRow('Jumlah Tarik',
                                    'Rp.${amount.toStringAsFixed(2)}'),
                                _buildReceiptDetailRow(
                                    'E-wallet', ewalletChannel.toUpperCase()),
                                const SizedBox(height: 10),
                                Divider(color: GreenPointColor.secondary),
                                Center(
                                  child: Text(
                                    'Terima kasih telah mengunakan GreenPoint.',
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 10.0), // Explicit padding
                                maximumSize: Size(100, 42),
                                minimumSize: Size(100,
                                    42), // Ensure both buttons have the same size
                                backgroundColor: GreenPointColor.secondary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Tutup',
                                style: GoogleFonts.dmSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Poin berhasil ditukar")),
                      );
                      _createNotificationAfterPayout(
                          context, amount, ewalletChannel);
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          title: Column(
                            children: [
                              Text(
                                'Terjadi Kesalahan',
                                style: GoogleFonts.dmSans(
                                  color: Colors.red,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Divider(color: Colors.red),
                            ],
                          ),
                          content: Text(
                            'Poin anda tidak mencukupi utntuk melakukan penukaran.',
                            style: GoogleFonts.dmSans(fontSize: 14),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                  // width: 3.0,
                                  color: Colors.red,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 10.0), // Explicit padding
                                // backgroundColor: Colors.red,

                                maximumSize: Size(100, 42),
                                minimumSize: Size(100, 42),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Tutup',
                                style: GoogleFonts.dmSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Column(
                          children: [
                            Text(
                              'Form Tidak Lengkap',
                              style: GoogleFonts.dmSans(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Divider(color: Colors.red),
                          ],
                        ),
                        content: Text(
                          'Pastikan semua informasi yang dibutuhkan sudah terisi.',
                          style: GoogleFonts.dmSans(fontSize: 14),
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                // width: 3.0,
                                color: Colors.red,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 10.0), // Explicit padding
                              // backgroundColor: Colors.red,

                              maximumSize: Size(100, 42),
                              minimumSize: Size(100, 42),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Tutup',
                              style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: GoogleFonts.dmSans(
              fontSize: 14,
              // color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              // color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Section Header
  Widget _buildHeaderSection() {
    final poin = Provider.of<UserProvider>(context).poin;
    final saldo = poin / 10;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              'lib/assets/imgs/logo.png',
              height: 80,
              width: 80,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Penukaran Poin",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "Saldo Anda",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/imgs/poin.png",
              height: 35,
              width: 35,
            ),
            const SizedBox(width: 8),
            Text(
              poin.toString(),
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: GreenPointColor.orange,
              ),
            ),
          ],
        ),
        Text(
          "${formatter.format(saldo)}", // Format saldo
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  final NumberFormat formatter = NumberFormat.currency(
    locale: 'id', // Locale Indonesia
    symbol: 'Rp', // Simbol mata uang
    decimalDigits: 0, // Jumlah desimal
  );

  // Ewallet options
  Widget _buildEwalletOptions() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildEwalletItem('lib/assets/imgs/logo_ovo.png', 'OVO', 'ovo'),
          _buildEwalletItem('lib/assets/imgs/logo_gopay.png', 'GoPay', 'gopay'),
          _buildEwalletItem('lib/assets/imgs/logo_dana.png', 'Dana', 'dana'),
        ],
      ),
    );
  }

  Widget _buildEwalletItem(String imagePath, String name, String type) {
    bool isSelected = _selectedEwallet == type;

    return GestureDetector(
      onTap: () => _selectEwallet(type),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: isSelected
                    ? Border.all(color: Colors.white, width: 3)
                    : null,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: GreenPointColor.primary.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        )
                      ]
                    : [],
              ),
              child: Image.asset(
                imagePath,
                width: 50,
                height: 50,
                color: isSelected ? null : Colors.grey.withOpacity(0.5),
                colorBlendMode: isSelected ? null : BlendMode.saturation,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              name,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? GreenPointColor.secondary : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Amount input
  Widget _buildAmountInput() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jumlah uang",
              style: GoogleFonts.dmSans(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: _amountController, // Assign controller
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rp.',
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Phone number input
  Widget _buildPhoneNumberInput() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nomor hp",
              style: GoogleFonts.dmSans(
                color: Colors.black,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextField(
              controller: _phoneController, // Assign controller
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '+62',
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Disclaimer Text
  Widget _buildDisclaimer() {
    return Text(
      "Untuk penarikan tunai, Pastikan poin anda mencukupi.",
      style: GoogleFonts.dmSans(
        color: Colors.white,
        fontSize: 10,
      ),
    );
  }

  void _createNotificationAfterPayout(
      BuildContext context, double amount, String ewalletChannel) {
    final notificationProvider =
        Provider.of<NotifikasiProvider>(context, listen: false);

    final notification = NotifikasiModel(
      id: DateTime.now().toString(),
      title: 'Penukaran Poin Berhasil',
      message:
          'Anda berhasil menukar Rp${amount.toStringAsFixed(2)} ke $ewalletChannel',
      timestamp: DateTime.now(),
      type: 'payout',
    );

    // Tambahkan notifikasi
    notificationProvider.addNotification(notification);
  }
}
