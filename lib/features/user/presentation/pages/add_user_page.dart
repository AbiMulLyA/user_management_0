// ============================================================================
// FILE: add_user_page.dart
// DESKRIPSI: Halaman untuk menambahkan user baru
// LOKASI: lib/features/user/presentation/pages/
// ============================================================================
//
// Halaman form untuk input data user baru.
//
// FORM HANDLING:
// -------------------------------------------------------------------------
// Flutter menyediakan Form widget untuk:
// - Validasi input
// - Mengumpulkan data dari multiple fields
// - Menampilkan error message
//
// KOMPONEN FORM:
// 1. Form widget dengan GlobalKey<FormState>
// 2. TextFormField untuk input text
// 3. DropdownButtonFormField untuk pilihan
// 4. ElevatedButton untuk submit
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/user_cubit.dart';
import '../bloc/user_state.dart';

/// Halaman untuk menambahkan user baru
///
/// STATEFUL WIDGET karena:
/// - Memiliki form dengan input yang bisa berubah
/// - Ada loading state internal
/// - Perlu dispose controller saat widget dihancurkan
class AddUserPage extends StatefulWidget {
  /// UserCubit untuk menambahkan user
  /// Di-pass dari halaman sebelumnya
  final UserCubit cubit;

  const AddUserPage({
    super.key,
    required this.cubit,
  });

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  // -------------------------------------------------------------------------
  // FORM KEY
  // -------------------------------------------------------------------------
  // GlobalKey<FormState> digunakan untuk:
  // - Mengakses state dari Form widget
  // - Memanggil validate() untuk validasi semua fields
  // - Memanggil save() untuk menyimpan semua values
  // -------------------------------------------------------------------------

  /// Key untuk mengakses Form state
  final _formKey = GlobalKey<FormState>();

  // -------------------------------------------------------------------------
  // TEXT EDITING CONTROLLERS
  // -------------------------------------------------------------------------
  // Controller untuk mengontrol dan membaca nilai dari TextField
  // Setiap TextField butuh controller tersendiri
  //
  // PENTING: Controller harus di-dispose di method dispose()
  // untuk mencegah memory leak
  // -------------------------------------------------------------------------

  /// Controller untuk field nama
  final _nameController = TextEditingController();

  /// Controller untuk field email
  final _emailController = TextEditingController();

  /// Controller untuk field telepon
  final _phoneController = TextEditingController();

  /// Controller untuk field alamat
  final _addressController = TextEditingController();

  // -------------------------------------------------------------------------
  // LOCAL STATE
  // -------------------------------------------------------------------------
  // State yang hanya untuk halaman ini, tidak perlu di Cubit
  // -------------------------------------------------------------------------

  /// Kota yang dipilih dari dropdown
  String? _selectedCity;

  /// Loading state saat submit form
  bool _isLoading = false;

  // -------------------------------------------------------------------------
  // LIFECYCLE: dispose
  // -------------------------------------------------------------------------

  /// Dipanggil saat widget dihancurkan
  ///
  /// WAJIB dispose controller untuk mencegah memory leak!
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // BUILD METHOD
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text('Tambah User Baru'),
        centerTitle: true,
      ),

      // ---------------------------------------------------------------------
      // BODY: BlocProvider.value
      // ---------------------------------------------------------------------
      // BlocProvider.value digunakan untuk menyediakan Cubit yang sudah ada
      // ke widget tree. Berbeda dengan BlocProvider biasa yang membuat baru.
      //
      // Kenapa pakai .value?
      // - Cubit sudah dibuat di halaman sebelumnya
      // - Kita hanya ingin "berbagi" Cubit yang sama
      // - Cubit tidak akan di-close saat halaman ini ditutup
      // ---------------------------------------------------------------------
      body: BlocProvider.value(
        value: widget.cubit,

        // BlocBuilder untuk rebuild UI saat state berubah
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            // ---------------------------------------------------------------
            // STATE: Loaded (menampilkan form)
            // ---------------------------------------------------------------
            if (state is UserLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),

                // Form widget untuk wrap semua form fields
                child: Form(
                  key: _formKey, // Assign key untuk akses state

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -----------------------------------------------------
                      // FIELD 1: Nama
                      // -----------------------------------------------------
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          hintText: 'Masukkan nama lengkap',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        // Validator dipanggil saat form.validate()
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null; // null = valid
                        },
                      ),
                      const SizedBox(height: 16),

                      // -----------------------------------------------------
                      // FIELD 2: Email
                      // -----------------------------------------------------
                      TextFormField(
                        controller: _emailController,
                        // Keyboard type untuk email
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'contoh@email.com',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          // Simple email validation
                          if (!value.contains('@')) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // -----------------------------------------------------
                      // FIELD 3: Nomor Telepon
                      // -----------------------------------------------------
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Telepon',
                          hintText: '08123456789',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor telepon tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // -----------------------------------------------------
                      // FIELD 4: Dropdown Kota
                      // -----------------------------------------------------
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCity,
                        decoration: const InputDecoration(
                          labelText: 'Kota',
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder(),
                        ),
                        // Items dari daftar kota di state
                        items: state.cities.map((city) {
                          return DropdownMenuItem<String>(
                            value: city.name,
                            child: Text(city.name),
                          );
                        }).toList(),
                        // Update state saat pilihan berubah
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih kota';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // -----------------------------------------------------
                      // FIELD 5: Alamat (multi-line)
                      // -----------------------------------------------------
                      TextFormField(
                        controller: _addressController,
                        maxLines: 3, // Izinkan 3 baris
                        decoration: const InputDecoration(
                          labelText: 'Alamat',
                          hintText: 'Masukkan alamat lengkap',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true, // Align label ke atas
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // -----------------------------------------------------
                      // SUBMIT BUTTON
                      // -----------------------------------------------------
                      SizedBox(
                        width: double.infinity, // Full width
                        height: 50,
                        child: ElevatedButton(
                          // Disable tombol saat loading
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // Tampilkan spinner saat loading
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Tambah User',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Default: loading indicator
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // METHOD: Submit Form
  // -------------------------------------------------------------------------

  /// Method untuk submit form dan menambahkan user
  ///
  /// Alur:
  /// 1. Validasi form
  /// 2. Set loading state
  /// 3. Buat UserEntity dari input
  /// 4. Panggil cubit.addUser()
  /// 5. Tampilkan feedback dan kembali ke halaman sebelumnya
  Future<void> _submitForm() async {
    // -----------------------------------------------------------------------
    // LANGKAH 1: Validasi Form
    // -----------------------------------------------------------------------
    // _formKey.currentState!.validate() memanggil validator
    // di semua TextFormField dan DropdownButtonFormField
    // Return true jika semua valid, false jika ada yang invalid
    // -----------------------------------------------------------------------
    if (_formKey.currentState!.validate()) {
      // ---------------------------------------------------------------------
      // LANGKAH 2: Set Loading State
      // ---------------------------------------------------------------------
      // setState() untuk update UI (tampilkan loading spinner)
      // ---------------------------------------------------------------------
      setState(() {
        _isLoading = true;
      });

      try {
        // -------------------------------------------------------------------
        // LANGKAH 3: Buat UserEntity
        // -------------------------------------------------------------------
        // Ambil nilai dari masing-masing controller
        // ID kosong karena akan di-generate oleh API
        // -------------------------------------------------------------------
        final newUser = UserEntity(
          id: '', // ID akan di-generate oleh API
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          city: _selectedCity!,
        );

        // -------------------------------------------------------------------
        // LANGKAH 4: Tambahkan User via Cubit
        // -------------------------------------------------------------------
        // widget.cubit mengakses cubit yang di-pass dari parent
        // addUser() akan memanggil use case -> repository -> API
        // -------------------------------------------------------------------
        await widget.cubit.addUser(newUser);

        // Check apakah widget masih mounted sebelum akses context
        if (!mounted) return;

        // -------------------------------------------------------------------
        // LANGKAH 5: Tampilkan Success Feedback
        // -------------------------------------------------------------------
        // SnackBar adalah notifikasi di bagian bawah layar
        // -------------------------------------------------------------------
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );

        // -------------------------------------------------------------------
        // LANGKAH 6: Kembali ke Halaman Sebelumnya
        // -------------------------------------------------------------------
        // Navigator.pop() untuk kembali
        // Parameter true dikirim sebagai result ke halaman sebelumnya
        // -------------------------------------------------------------------
        Navigator.pop(context, true);
      } catch (e) {
        // Error handling: tampilkan error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        // Finally block: selalu dijalankan, baik sukses maupun error
        // Reset loading state
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
