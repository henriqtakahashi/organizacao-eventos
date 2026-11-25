import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:organizacao_eventos/main.dart';

void main() {
  testWidgets('Validação, cadastro, edição e exclusão', (tester) async {
    await tester.pumpWidget(const EventosApp());
    expect(find.text('Nenhum evento cadastrado'), findsOneWidget);
    await tester.tap(find.text('Novo evento'));
    await tester.pumpAndSettle();
    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), '   ');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsNWidgets(3));
    await tester.enterText(campos.at(0), 'Feira Tech');
    await tester.enterText(campos.at(1), 'Auditório');
    await tester.enterText(campos.at(2), 'Paula');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Feira Tech'), findsOneWidget);
    expect(find.text('Local: Auditório\nResponsável: Paula'), findsOneWidget);
    await tester.tap(find.text('Feira Tech'));
    await tester.pumpAndSettle();
    expect(find.text('Paula'), findsOneWidget);
    await tester.enterText(campos.at(2), 'Maria');
    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();
    expect(find.text('Feira Tech'), findsOneWidget);
    expect(find.text('Local: Auditório\nResponsável: Maria'), findsOneWidget);
    await tester.tap(find.byTooltip('Excluir'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Excluir'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum evento cadastrado'), findsOneWidget);
  });
}
