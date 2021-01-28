import 'dart:async';

import 'package:BuscaCEP/model/endereco.dart';
import 'package:dio/dio.dart';

class EnderecoBloc {
  //controler principal do arquivo bloc
  // ignore: close_sinks
  final StreamController<String> _controler = StreamController();

  //entrada de dados
  Sink<String> get input => this._controler.sink;

  //saida de dados
  Stream<Endereco> get output => this
      ._controler
      .stream
      .where((cep) => cep.length > 8) //condição para o retorno de dados
      .asyncMap((cep) => _seachCEP(cep)); //tipo do retorno

  //gera a URL de consulta de CEP na API
  String _url(String cep) => "https://viacep.com.br/ws/$cep/json/";

  //Busca de CEP (Gerda um objeto Endereco com os dados consultados)
  Future<Endereco> _seachCEP(String cep) async {
    //O CEP vem com o "-" que não pode constar na URL por isso e feito
    //a remoção do "-" do CEP antes de fazer a consulta na API
    var urlAPI = this._url(cep.replaceAll("-", ""));

    //informa no consule a Url utilizada para a consulta
    print("Url de consulta na API: $urlAPI");

    Response response = await Dio().get(urlAPI);

    //informa no console que esta sendo feita a consulta do CEP
    print("Buscando CEP $cep");

    //se a API retornar algum erro ele entrega um Endereço generico informando
    //que o endereço não foi localizado.
    if (response.data['erro'] == true) {
      //Informa no console que ocorreu um erro na consulta
      print("Erro ao consulta o CEP $cep");

      return Endereco(cep: cep);
    }

    //retorna o endereço solicitado
    return Endereco.fromJson(response.data);
  }
}
