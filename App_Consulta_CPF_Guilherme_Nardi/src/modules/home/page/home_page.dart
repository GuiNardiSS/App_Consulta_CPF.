import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../controller/address_store.dart';
import '../../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AddressStore store = AddressStore();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastLocation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.history);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Digite o CEP',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => store.searchCep(controller.text),
              child: const Text('Buscar'),
            ),
            Observer(
              builder: (_) {
                if (store.isLoading) return const CircularProgressIndicator();
                if (store.error.isNotEmpty) return Text(store.error);
                if (store.address == null) return const SizedBox.shrink();
                final a = store.address!;
                return ListTile(
                  title: Text('${a.cep} - ${a.localidade}/${a.uf}'),
                  subtitle: Text(a.logradouro),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}