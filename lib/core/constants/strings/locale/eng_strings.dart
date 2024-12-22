class EngStrings {
  EngStrings._();

  ///Splash screen
  static const String splashTitleText1 = "Asset";
  static const String splashTitleText2 = "Tracker";

  ///Login and Register Screen
  static const String signIn = "Sign In";
  static const String signUp = "Sign Up";
  static const String forgetPassword = "Forget Password?";
  static const String textForGoToRegister = "Don’t have an account? ";
  static const String textForGoToLogin = "Already have an account? ";
  static const String requiredEmail = "Email is required";
  static const String requiredPassword = "Password is required";
  static const String requiredUsername = "Username is required";
  static const String labelEmail = "Email";
  static const String hintTextEmail = "Enter the email";
  static const String labelPassword = "Password";
  static const String hintTextPassword = "Enter the password";
  static const String labelUsername = "Username";
  static const String hintTextUsername = "Enter the username";
  static const String warningPasswordLength =
      "Password must be at 6 least characters";
  static const String invalidEmail = "Please enter a valid email address";
  static const String forgetPasswordScreenTitle = "Forget Password";
  static const String forgetPasswordScreenText =
      "Please enter your email and we will send \nyou a link to return to your account";
  static const String forgetPasswordScreenButtonText = "Continue";
  static const String fogetPasswordScreenNoAccountText =
      "Don’t have an account? ";

  ///Exception messages
  static const String networkError = "Check your internet connection.";
  static const String userNotFound = "User not found. Please try again.";
  static const String wrongPassword = "Incorrect password. Please try again.";
  static const String emailAlreadyInUse =
      "This email address is already in use.";
  static const String accountExistsWithDifferentCredential =
      "This email address is already in use with a different credential.";
  static const String unknownError = "An unknown error occurred.";
  static const String timeout = "Timed out. Please try again.";
}
