bool isValidEmail(String email) {
  return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
}

bool isStrongPassword(String password) {
  return RegExp(
    r'^(?=.*[A-Z])(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
  ).hasMatch(password);
}
