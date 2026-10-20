import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nomorTeleponController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _setujuSyarat = false;
  double _passwordStrengthValue = 0.33;

  DateTime? _tanggalLahir;
  String? _jenisKelamin;
  String? _errorSyarat;
  String _passwordStrength = 'Lemah';
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nomorTeleponController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validasi nama
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  // Validasi email
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }
  // Validasi password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    return null;
  }

  // Validasi konfirmasi password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }
  
  Future<void> _pilihTanggalLahir() async {
  final DateTime? tanggalDipilih = await showDatePicker(
    context: context,
    initialDate: _tanggalLahir ?? DateTime(2005, 1, 1),
    firstDate: DateTime(1950),
    lastDate: DateTime.now(),
    helpText: 'Pilih Tanggal Lahir',
  );

  if (tanggalDipilih != null) {
    setState(() {
      _tanggalLahir = tanggalDipilih;
    });
  }
}

  // Menghitung kekuatan password
  void _cekKekuatanPassword(String password) {
    final bool adaHuruf = RegExp(r'[a-zA-Z]').hasMatch(password);
    final bool adaAngka = RegExp(r'[0-9]').hasMatch(password);
    final bool adaHurufBesar = RegExp(r'[A-Z]').hasMatch(password);
    final bool adaHurufKecil = RegExp(r'[a-z]').hasMatch(password);
    final bool adaSimbol =
        RegExp(r'[^a-zA-Z0-9]').hasMatch(password);

    setState(() {
      if (password.length < 8) {
        _passwordStrength = 'Lemah';
        _passwordStrengthValue = 0.33;
      } else if (adaHurufBesar &&
          adaHurufKecil &&
          adaAngka &&
          adaSimbol) {
        _passwordStrength = 'Kuat';
        _passwordStrengthValue = 1.0;
      } else if (adaHuruf && adaAngka) {
        _passwordStrength = 'Sedang';
        _passwordStrengthValue = 0.66;
      } else {
        _passwordStrength = 'Lemah';
        _passwordStrengthValue = 0.33;
      }
    });
  }


  // Handler submit form
   void _submitForm() {
  setState(() {
    _errorSyarat = _setujuSyarat
        ? null
        : 'Kamu wajib menyetujui Syarat & Ketentuan';
  });

  if (!_formKey.currentState!.validate() || !_setujuSyarat) {
    return;
  }

  setState(() {
    _isLoading = true;
  });

  // Simulasi proses registrasi
  Future.delayed(const Duration(seconds: 2), () {
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrasi Berhasil'),
        content: Text(
          'Selamat, ${_nameController.text}!\n'
          'Email: ${_emailController.text}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  });
}


  // Reset form
  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _nomorTeleponController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const SizedBox(height: 16),
                const Icon(
                  Icons.person_add,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Isi form di bawah ini untuk mendaftar',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Field Nama
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap Anda',
                  prefixIcon: Icons.person,
                  validator: _validateName,
                ),
                // Field Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                
                // Field Nomor Telepon
                CustomTextField(
                  controller: _nomorTeleponController,
                  label: 'Nomor Telepon',
                  hint: 'Masukkan 10-13 digit angka',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor telepon wajib diisi';
                    }

                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Nomor telepon hanya boleh berisi angka';
                    }

                    if (value.length < 10 || value.length > 13) {
                      return 'Nomor telepon harus 10-13 digit';
                    }

                    return null;
                  },
                ),
               
                // Field Tanggal Lahir
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: _tanggalLahir == null
                          ? ''
                          : '${_tanggalLahir!.day.toString().padLeft(2, '0')}/'
                            '${_tanggalLahir!.month.toString().padLeft(2, '0')}/'
                            '${_tanggalLahir!.year}',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Lahir',
                      hintText: 'Pilih tanggal lahir',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    onTap: _pilihTanggalLahir,
                  ),
                ),
              
              
                // Dropdown Jenis Kelamin
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: _jenisKelamin,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.people),
                    ),
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'Laki-laki',
                        child: Text('Laki-laki'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Perempuan',
                        child: Text('Perempuan'),
                      ),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        _jenisKelamin = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jenis kelamin wajib dipilih';
                      }
                      return null;
                    },
                  ),
                ),
                
                // Checkbox Syarat dan Ketentuan
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _setujuSyarat,
                  onChanged: (bool? value) {
                    setState(() {
                      _setujuSyarat = value ?? false;
                      _errorSyarat = null;
                    });
                  },
                  title: const Text(
                    'Saya setuju dengan Syarat & Ketentuan',
                  ),
                ),
                if (_errorSyarat != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      bottom: 8,
                    ),
                    child: Text(
                      _errorSyarat!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),




                // Field Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Minimal 8 karakter, huruf kapital, angka',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    obscureText: _obscurePassword,
                    onChanged: _cekKekuatanPassword,
                    validator: _validatePassword,
                  ),
                ),
                
                // Indikator Kekuatan Password
                Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 4,
                    bottom: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kekuatan Password:',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            _passwordStrength,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _passwordStrength == 'Kuat'
                                  ? Colors.green
                                  : _passwordStrength == 'Sedang'
                                      ? Colors.orange
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: _passwordStrengthValue,
                        backgroundColor: Colors.grey.shade300,
                        color: _passwordStrength == 'Kuat'
                            ? Colors.green
                            : _passwordStrength == 'Sedang'
                                ? Colors.orange
                                : Colors.red,
                        minHeight: 6,
                      ),
                    ],
                  ),
                ),

                // Field Konfirmasi Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Ulangi password Anda',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    obscureText: _obscureConfirmPassword,
                    validator: _validateConfirmPassword,
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol Submit
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Daftar', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),
                // Tombol Reset
                OutlinedButton(
                  onPressed: _isLoading ? null : _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Reset'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
