import 'package:mobx/mobx.dart';
import 'package:hive/hive.dart';
import '../model/address_model.dart';
import '../service/address_service.dart';

part 'address_store.g.dart';

class AddressStore = _AddressStoreBase with _$AddressStore;

abstract class _AddressStoreBase with Store {
  final _service = AddressService();

  @observable
  AddressModel? address;

  @observable
  bool isLoading = false;

  @observable
  String error = '';

  @action
  Future<void> searchCep(String cep) async {
    try {
      isLoading = true;
      error = '';
      address = await _service.fetchAddressByCep(cep);

      final box = Hive.box<AddressModel>('history');
      box.add(address!);
    } catch (e) {
      error = 'Erro ao buscar o CEP';
    } finally {
      isLoading = false;
    }
  }
}