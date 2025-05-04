import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../home/model/address_model.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  void _openMap(AddressModel address) async {
    final query = Uri.encodeComponent(
        '${address.logradouro}, ${address.bairro}, ${address.localidade} - ${address.uf}');
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Não foi possível abrir o mapa.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<AddressModel>('history');

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<AddressModel> items, _) {
          if (items.isEmpty) {
            return const Center(child: Text('Nenhum CEP salvo ainda.'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final address = items.getAt(index)!;
              return ListTile(
                title: Text('${address.cep} - ${address.localidade}/${address.uf}'),
                subtitle: Text(address.logradouro),
                trailing: IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () => _openMap(address),
                ),
              );
            },
          );
        },
      ),
    );
  }
}