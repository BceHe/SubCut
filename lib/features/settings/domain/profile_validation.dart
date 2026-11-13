class ProfileValidation {
  const ProfileValidation._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama wajib diisi.';
    }
    return null;
  }
}
