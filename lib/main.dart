import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:local_auth/local_auth.dart';
import 'package:special_data_flutter/home_page.dart';
import 'package:special_data_flutter/keys.dart';
import 'package:special_data_flutter/parse/parse_service.dart';
import 'package:special_data_flutter/parse/student_parse_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:special_data_flutter/services/biometrics.dart';
import 'package:special_data_flutter/services/get_it.dart';
import 'package:special_data_flutter/services/storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
    registeredSubClassMap: <String, ParseObjectConstructor>{
      'Student': () => Student(),
    },
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  var username = "";
  var password = "";
  var rememberMe = false;
  var showPassword = false;
  var isBiometricEnabled = false;
  var isBiometricToggled = false;
  var biometricsType = null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initialize(context));
  }

  var passwordController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                    /*GestureDetector(
                  child: CommonWidgets.logo(context),
                  onTap: () {
                    logoTap();
                  },
                )*/
                    const Text("Special Data Logo"),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      key: const Key("emailTextFormField"),
                      controller: emailController,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                            key: const Key("rememberMeCheckbox"),
                            value: rememberMe,
                            checkColor: Colors.white,
                            onChanged: ((value) {
                              setState(() {
                                if (value!) {
                                  secureStorage.write(
                                      key: rememberMeKey, value: trueValue);
                                } else {
                                  secureStorage.write(
                                      key: rememberMeKey, value: falseValue);
                                }
                                rememberMe = value;
                              });
                            })),
                        const Expanded(child: Text("Remember Me"))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      key: const Key("passwordTextFormField"),
                      controller: passwordController,
                      obscureText: !showPassword,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Password",
                        suffixIcon: GestureDetector(
                            child: showPassword
                                ? const Icon(
                                    Icons.visibility,
                                    color: Colors.grey,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                            onTap: () => {
                                  setState(() {
                                    showPassword = !showPassword;
                                  })
                                }),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      child: Text(
                          key: const Key("lostPasswordButton"),
                          "Forgot Password",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                      onTap: () async {
                        //await forgotPasswordClicked();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        key: const Key("signInButton"),
                        onPressed: (() {
                          signIn(emailController.text, passwordController.text);
                        }),
                        child: const Text(
                          "Sign In",
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: (() {
                          createAccount();
                        }),
                        child: const Text("Create Account")),
                    if (isBiometricEnabled)
                      Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(children: [
                            const Text("Enable Biometric Sign In"),
                            const Spacer(),
                            Switch(
                                value: isBiometricToggled,
                                onChanged: ((value) {
                                  setState(() {
                                    isBiometricToggled = value;
                                  });
                                  secureStorage.write(
                                      key: biometricKey,
                                      value: value ? trueValue : falseValue);
                                })),
                            GestureDetector(
                              onTap: () async {
                                await biometricClicked();
                              },
                              child: biometricsType == BiometricType.face
                                  ? Icon(
                                      Icons.face,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 50,
                                    )
                                  : Icon(
                                      Icons.fingerprint,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 50,
                                    ),
                            ),
                          ]))
                  ])),
            )));
  }

  signIn(String username, String password) {}

  createAccount() {}

  biometricClicked() async {
    var authSuccess =
        await getIt<ABiometricsService>().verifyBiometricsForSignIn();
    if (authSuccess) {
      try {
        await getIt<AParseService>()
            .userParseService
            .signIn(username, (await secureStorage.read(key: passwordKey))!);
      } catch (e) {
        print((e as ParseError).message);
      }
    }
  }

  setupPage() async {
    var storedUsername = await secureStorage.read(key: usernameKey);
    var rememberMeCheck = await secureStorage.read(key: rememberMeKey);
    rememberMe = rememberMeCheck != null && rememberMeCheck == trueValue;
    if (rememberMe && storedUsername != null) {
      emailController.text = storedUsername;
    } else {
      emailController.text = "";
    }
    passwordController.text = "";

    setState(() {
      rememberMe;
    });
    //setupFirebase();
    checkBiometrics();
  }

  checkBiometrics() async {
    isBiometricEnabled =
        await getIt<ABiometricsService>().areBiometricsDeviceAvailable();
    biometricsType = await getIt<ABiometricsService>().getBiometricType();
    isBiometricToggled =
        await getIt<ABiometricsService>().areBiometricsUserEnabled();

    setState(() {
      biometricsType;
      isBiometricEnabled;
      isBiometricToggled;
    });

    // Automatic signin by biometrics if available
    if (isBiometricEnabled && isBiometricToggled) {
      await biometricClicked();
    }
  }

  initialize(BuildContext context) async {
    // username = await storage.read(key: "username") ?? "";
    // password = await storage.read(key: "password") ?? "";
    //encryptionKey = await storage.read(key: "encryptionKey") ?? "";
    final LocalAuthentication auth = LocalAuthentication();

    final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to sign in',
        options: const AuthenticationOptions(biometricOnly: true));

    if (didAuthenticate && mounted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }
}
