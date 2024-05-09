import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/constants/extensions.dart';
import 'package:chatlinxs/managers/firestore_manager.dart';
import 'package:chatlinxs/managers/local_db_manager/local_db.dart';
import 'package:chatlinxs/managers/navigation_manager/navigation_manager.dart';
import 'package:chatlinxs/models/onboarding_page.dart';
import 'package:chatlinxs/models/user.dart' as model;

class AuthProvider extends ChangeNotifier {
  double top = 50, left = 100;
  Timer? timer;
  PageController? pageController;
  int selectedPageIndex = 0;
  bool showForm = false;
  bool onOTPage = false;

  OnBoardingPageModel get page => pages[selectedPageIndex];

  List<OnBoardingPageModel> pages = [
    OnBoardingPageModel(
        "https://cdn-icons-png.flaticon.com/512/2103/2103620.png",
        "Conectate con tus\nCompañeros",
        "Para facilitar la comunicación y organización entre alumnos y profesores."),
    OnBoardingPageModel(
        "https://cdn-icons-png.flaticon.com/512/77/77087.png",
        "Seguridad\ny Privacidad",
        "Priorizamos tu seguridad y privacidad. Conversaciones protegidas con altos estándares. "),
    OnBoardingPageModel(
        "https://cdn-icons-png.flaticon.com/512/1189/1189175.png",
        "Comparte con tus\nCompañeros",
        "¡Comparte tus momentos al instante!. ¡Expresa y conecta fácilmente!"),
  ];

  String? verificationId;
  FirebaseAuth auth = FirebaseAuth.instance;

  void timerDispose() {
    timer?.cancel();
  }

  void reset() {
    verificationId = null;
    selectedPageIndex = 0;
    showForm = false;
    onOTPage = false;
    pageController = null;
  }

  startFloatingAnimation() {
    timerDispose();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      int threshold = 10;
      top = Random().nextInt(threshold).toDouble(); // 0-20
      left = Random().nextInt(threshold).toDouble(); // 0-20
    });
  }

  void initialize() {
    reset();
    startFloatingAnimation();
    pageController = PageController(initialPage: selectedPageIndex);
    notifyListeners();
  }

  void onLeftArrowClicked() {
    if (selectedPageIndex != 0) {
      if (pages.length - 1 == selectedPageIndex) {
        selectedPageIndex = 0;
        showForm = false;
      } else {
        pageController!.animateToPage(selectedPageIndex - 1,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(seconds: 2));
        selectedPageIndex--;
      }
    }
    notifyListeners();
  }

  void onRightArrowClicked() {
    if (selectedPageIndex != pages.length) {
      if (pages.length - 1 == selectedPageIndex) {
        showForm = true;
      } else {
        pageController!.animateToPage(selectedPageIndex + 1,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(seconds: 2));
        selectedPageIndex++;
      }
    }
    notifyListeners();
  }

  void onLeftArrowReset(isKeyboardOpened) {
    if (isKeyboardOpened) {
      FocusManager.instance.primaryFocus?.unfocus();
      return;
    }
    if (onOTPage) {
      onOTPage = false;
    } else if (showForm) {
      showForm = false;
      selectedPageIndex = 0;
    }
    notifyListeners();
  }

  Future<void> onSendOtpClicked(
    String email,
    String password,
    BuildContext context,
    Function(bool) onOTPageChanged,
  ) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print("Usuario autenticado: ${auth.currentUser?.uid}");
      final maanger = FirestoreManager();
      maanger.isUserExist(email: email).then((exists) async {
        if (exists) {
          model.User user = await maanger.getUser(email);
          LocalDB.setUser(user);
          NavigationManager.navigate(context, Routes.rootScreen);
        } else {
          print("No existe");
        }
      });
    } catch (error) {
      //onOTPage = true;
      print("Error de autenticación: $error");
      // Mostrar un diálogo de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error de autenticación"),
            content: Text(
                "Hubo un error al intentar autenticarse con las credenciales proporcionadas."),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Cerrar el diálogo
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Cerrar el diálogo

                  Navigator.of(context).pop();
                  noAccountClicked();
                },
                child: Text("No tengo cuenta"),
              ),
            ],
          );
        },
      );
    }

    notifyListeners();
  }

  void noAccountClicked() {
    onOTPage = true;
    notifyListeners();
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    try {
      // Intenta registrar al usuario con su correo electrónico y contraseña
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Si el registro es exitoso, retorna true
      return true;
    } catch (error) {
      // Si hay algún error durante el registro, imprímelo y retorna false
      print("Error en el registro: $error");
      return false;
    }
  }

  Future<void> onOtpSubmit(model.User user, BuildContext context) async {
    final maanger = FirestoreManager();

    bool signUpResult =
        await signUpWithEmailAndPassword(user.email, user.password!);
    // verify otp function
    if (signUpResult) {
      print("Fallo al intentar crear el usuario $signUpResult");
    }
    String? firebaseToken = await auth.currentUser?.getIdToken();

    maanger.isUserExist(email: user.email).then((exists) async {
      if (exists) {
        model.User us = await maanger.getUser(user.email);
        LocalDB.setUser(us);
        NavigationManager.navigate(context, Routes.rootScreen);
      } else {
        if (user.email != null &&
            user.password != null &&
            user.name != null &&
            user.picture != null &&
            user.phoneNumber != null) {
          model.User us = model.User(
              name: user.name,
              email: user.email,
              password: user.password,
              phoneNumber: user.phoneNumber,
              picture: user.picture,
              firstName: "",
              uuid: context.getUUid(),
              firebaseToken: firebaseToken);
          maanger.registerUser(us);
          LocalDB.setUser(us);
          NavigationManager.navigate(context, Routes.rootScreen);
        } else {
          print("datos vacios");
        }
        print("el usuario no existe");
      }
    });
  }
}
