import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/address_model.dart';

class AddressService {
  Future<AddressModel> fetchAddressByCep(String cep) async {
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      return AddressModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao buscar o CEP');
    }
  }
}