import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs.dart';

typedef OnAuthComplete = void Function();

class VKAuthButton extends StatelessWidget {
  final OnAuthComplete onAuthComplete;

  const VKAuthButton({Key key, this.onAuthComplete}) : super(key: key);

  @override
  Widget build(BuildContext context) => RaisedButton(
        child: Text("Войти в ВК"),
        onPressed: () async {
          var accessToken = await Navigator.pushNamed(context, "/vk-auth");
          context.bloc<VKBloc>().add(VKAccessTokenSetEvent(accessToken));

          if (onAuthComplete != null) {
            onAuthComplete();
          }
        },
      );
}
