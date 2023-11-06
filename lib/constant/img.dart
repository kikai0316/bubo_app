import 'package:flutter/cupertino.dart';

DecorationImage appLogoImg() {
  return const DecorationImage(
    image: AssetImage("assets/img/logo.png"),
    fit: BoxFit.cover,
  );
}

DecorationImage notImg() {
  return const DecorationImage(
    image: AssetImage("assets/img/not.png"),
    fit: BoxFit.cover,
  );
}
