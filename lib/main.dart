import 'package:flutter/material.dart';

void main() => runApp(const EventosApp());

class Evento {
  final String nome;
  final String local;
  final String responsavel;

  const Evento(this.nome, this.local, this.responsavel);
}

class EventosApp extends StatelessWidget {
  const EventosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Organização de eventos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF174A82)),
        useMaterial3: true,
      ),
      home: const ListaEventos(),
    );
  }
}

class ListaEventos extends StatefulWidget {
  const ListaEventos({super.key});

  @override
  State<ListaEventos> createState() => _ListaEventosState();
}

class _ListaEventosState extends State<ListaEventos> {
  final List<Evento> eventos = [];

  Future<void> abrirFormulario([int? indice]) async {
    final resultado = await Navigator.of(context).push<Evento>(
      MaterialPageRoute(
        builder: (_) => FormularioEvento(
          evento: indice == null ? null : eventos[indice],
        ),
      ),
    );
    if (!mounted || resultado == null) return;
    setState(() {
      if (indice == null) {
        eventos.add(resultado);
      } else {
        eventos[indice] = resultado;
      }
    });
  }

  Future<void> excluir(int indice) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir evento?'),
        content: Text('Deseja remover ${eventos[indice].nome}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (!mounted || confirmar != true) return;
    setState(() => eventos.removeAt(indice));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organização de eventos'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: eventos.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_available, size: 64, color: Colors.blueGrey),
                  SizedBox(height: 16),
                  Text('Nenhum evento cadastrado'),
                  Text('Toque em Novo evento para começar.'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
              itemCount: eventos.length,
              itemBuilder: (context, indice) {
                final evento = eventos[indice];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(evento.nome),
                    subtitle: Text(
                      'Local: ${evento.local}\nResponsável: ${evento.responsavel}',
                    ),
                    isThreeLine: true,
                    onTap: () => abrirFormulario(indice),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Editar',
                          icon: const Icon(Icons.edit),
                          onPressed: () => abrirFormulario(indice),
                        ),
                        IconButton(
                          tooltip: 'Excluir',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => excluir(indice),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Novo evento'),
      ),
    );
  }
}

class FormularioEvento extends StatefulWidget {
  final Evento? evento;
  const FormularioEvento({super.key, this.evento});

  @override
  State<FormularioEvento> createState() => _FormularioEventoState();
}

class _FormularioEventoState extends State<FormularioEvento> {
  final chaveFormulario = GlobalKey<FormState>();
  late final TextEditingController nome;
  late final TextEditingController local;
  late final TextEditingController responsavel;

  @override
  void initState() {
    super.initState();
    nome = TextEditingController(text: widget.evento?.nome ?? '');
    local = TextEditingController(text: widget.evento?.local ?? '');
    responsavel = TextEditingController(text: widget.evento?.responsavel ?? '');
  }

  @override
  void dispose() {
    nome.dispose();
    local.dispose();
    responsavel.dispose();
    super.dispose();
  }

  String? validar(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  void salvar() {
    if (!chaveFormulario.currentState!.validate()) return;
    Navigator.pop(
      context,
      Evento(nome.text.trim(), local.text.trim(), responsavel.text.trim()),
    );
  }

  Widget campo(String titulo, TextEditingController controller, IconData icone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: titulo,
          prefixIcon: Icon(icone),
          border: const OutlineInputBorder(),
        ),
        validator: validar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.evento == null ? 'Cadastrar evento' : 'Editar evento'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: chaveFormulario,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  campo('Evento', nome, Icons.event),
                  campo('Local', local, Icons.location_on_outlined),
                  campo('Responsável', responsavel, Icons.person_outline),
                  FilledButton.icon(
                    onPressed: salvar,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
