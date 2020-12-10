
import 'package:flutter_test/flutter_test.dart';
import 'package:trevo/shared/globalFunctions.dart';
import 'package:trevo/ui/Home/pages/profile.dart';



void main()
{
  group("Unit Testing", ()
  {
    test("Greetings Function test", ()
    {
      Profile profile= Profile();
      expect(profile.createState().greeting(10), "Good Morning!") ;
      expect(profile.createState().greeting(16), "Good Afternoon!");
      expect(profile.createState().greeting(19), "Good Evening!");
    });

    test("Email Regex Test", ()
    {
      expect(emailRegexPass("user123@gmail.com"), true);
      expect(emailRegexPass("useraplha.com"), false);
      expect(emailRegexPass("user123.com"), false);
    });

    test("Password Regex Test", (){
      expect(passwordRegexPass("abcd1234"), true);
      expect(passwordRegexPass("1234"), false);
    });


  });
}