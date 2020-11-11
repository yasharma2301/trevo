
bool emailRegexPass(String email){
  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  return emailValid;
}

bool passwordRegexPass(String password){
  if(password.length>=6){
    return true;
  }else{
    return false;
  }
}