# Organização de eventos

CMP2304 — Tecnologia de Construção de Software I — P3, versão 21.

Aplicativo Flutter que permite cadastrar, listar, editar e excluir eventos. Cada evento possui nome, local e responsável. Todos os campos são obrigatórios e espaços isolados não são aceitos. Os dados ficam em uma lista em memória, atualizada com `setState`, e são descartados quando o aplicativo é encerrado.

## Executar

Com o Flutter SDK instalado (Dart 3 e Flutter com suporte a `flutter_bootstrap.js`), abra esta pasta no terminal:

```bash
flutter pub get
flutter run -d chrome
```

A estrutura incluída tem como alvo a plataforma web. Para gerar arquivos de suporte Android, se necessário, execute `flutter create --platforms=android .` na pasta do projeto.

## Testar

```bash
flutter test
```

Exemplo: Feira Tech, Auditório, Paula. É possível editar o registro tocando nele ou no ícone de lápis e excluir usando o ícone de lixeira.
