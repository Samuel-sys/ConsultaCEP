import 'package:BuscaCEP/bloc/endereco_bloc.dart';
import 'package:BuscaCEP/model/endereco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EnderecoBloc bloc = EnderecoBloc();

  final mask = MaskedTextController(mask: "00000-000");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          TextField(
            controller: mask,
            decoration: InputDecoration(hintText: "Digite o CEP"),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              bloc.input.add(value);
            },
            // onSubmitted: (cep) => bloc.input.add(cep), outro metodo de fazer a consulta
            maxLength: 9, // tem que contar o "-" do CEP
          ),
          Column(
            children: [
              StreamBuilder<Endereco>(
                //Strem do bloc (local de saida de dados)
                stream: bloc.output,

                //ele colocar o "default" do Endereço como valor inicial
                initialData: Endereco(),

                builder: (context, snapshot) {
                  //atribui o valo do endereço que foi buscado para variavel endereco
                  var endereco = snapshot.data;

                  //caso tenha algum erro na consulta
                  if (snapshot.error != null) {
                    return Text("Erro ao realiza a consulta do CEP");
                  }

                  // //mostra que esta sendo feita a consulta
                  // else if (snapshot.connectionState ==
                  //     ConnectionState.waiting) {
                  //   return Center(child: CircularProgressIndicator());
                  // } Erro Visual

                  //dados do endereço consultado
                  else {
                    return ListTile(
                      title: Text(endereco.logradouro),
                      subtitle: Text("${endereco.localidade} - ${endereco.uf}"),
                      leading: Text(endereco.cep),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
