import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs.dart';

class VKAuthButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RaisedButton(
        child: Text("Войти в ВК"),
        onPressed: () async {
          var accessToken = await Navigator.pushNamed(context, "/vk-auth");
          context.bloc<VKBloc>().add(VKAccessTokenSetEvent(accessToken));
        },
      );
}
