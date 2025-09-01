# Instruções de Instalação e Execução

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:

1. **Flutter SDK** (versão 3.0.0 ou superior)
   - [Guia de instalação do Flutter](https://flutter.dev/docs/get-started/install)
   - Execute `flutter doctor` para verificar se tudo está configurado corretamente

2. **Dart SDK** (versão 3.0.0 ou superior)
   - Geralmente vem junto com o Flutter

3. **Editor de código**
   - **VS Code** com extensão Flutter (recomendado)
   - **Android Studio** com plugin Flutter
   - **IntelliJ IDEA** com plugin Flutter

4. **Emuladores/Dispositivos**
   - **Android**: Android Studio com AVD Manager
   - **iOS**: Xcode com simulador iOS (apenas macOS)
   - **Web**: Navegador moderno

## Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/yourusername/my-first-words-flutter.git
cd my-first-words-flutter
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Verifique a configuração

```bash
flutter doctor
```

Certifique-se de que não há problemas reportados.

## Executando o Aplicativo

### Android

1. **Conecte um dispositivo Android** ou **inicie um emulador**
2. Execute:
   ```bash
   flutter run
   ```

### iOS (apenas macOS)

1. **Abra o simulador iOS** ou **conecte um dispositivo iOS**
2. Execute:
   ```bash
   flutter run
   ```

### Web

```bash
flutter run -d chrome
```

## Estrutura do Projeto

```
my_first_words_flutter/
├── lib/
│   ├── constants/          # Constantes e strings
│   ├── models/            # Modelos de dados
│   ├── providers/         # Gerenciamento de estado
│   ├── screens/           # Telas do aplicativo
│   ├── services/          # Serviços de negócio
│   ├── widgets/           # Componentes reutilizáveis
│   └── main.dart          # Ponto de entrada
├── android/               # Configurações Android
├── ios/                   # Configurações iOS
├── web/                   # Configurações Web
├── pubspec.yaml           # Dependências
└── README.md              # Documentação
```

## Funcionalidades Principais

### 🎯 Quadro de Comunicação
- **4 categorias**: Necessidades Básicas, Emoções, Atividades, Social
- **3 níveis de aprendizado**: Palavras simples → Frases → Conversação
- **Interface visual intuitiva** com ícones e cores

### 🌍 Suporte Multilíngue
- Português (Brasil e Portugal)
- Inglês
- Espanhol
- Alemão

### 🔊 Recursos de Áudio
- **Síntese de voz** (texto para fala)
- **Reconhecimento de fala**
- **Configurações personalizáveis** (volume, velocidade, pitch)
- **Feedback tátil**

### ⚙️ Configurações
- **Temas**: Claro, escuro, sistema
- **Acessibilidade**: Alto contraste, texto grande
- **Controles parentais**: Gerenciar itens disponíveis

## Solução de Problemas

### Erro: "flutter: command not found"
- Certifique-se de que o Flutter está no PATH
- Reinicie o terminal após a instalação

### Erro: "No supported devices connected"
- Verifique se o dispositivo/emulador está conectado
- Execute `flutter devices` para listar dispositivos disponíveis

### Erro: "Gradle build failed"
- Limpe o cache: `flutter clean`
- Reinstale as dependências: `flutter pub get`

### Erro: "iOS build failed"
- Verifique se o Xcode está atualizado
- Execute `flutter doctor` para verificar problemas específicos do iOS

## Comandos Úteis

```bash
# Verificar status do Flutter
flutter doctor

# Listar dispositivos disponíveis
flutter devices

# Limpar cache
flutter clean

# Reinstalar dependências
flutter pub get

# Executar testes
flutter test

# Construir APK para Android
flutter build apk --release

# Construir para iOS
flutter build ios --release

# Construir para Web
flutter build web --release
```

## Próximos Passos

1. **Personalize o aplicativo**:
   - Adicione novos itens de comunicação
   - Modifique cores e temas
   - Adicione novos idiomas

2. **Teste em diferentes dispositivos**:
   - Teste em tablets
   - Verifique a responsividade
   - Teste recursos de acessibilidade

3. **Implemente funcionalidades adicionais**:
   - Sistema de progresso
   - Estatísticas de uso
   - Backup e sincronização

## Suporte

Se encontrar problemas:

1. Verifique se seguiu todos os passos de instalação
2. Execute `flutter doctor` e verifique a saída
3. Consulte a [documentação oficial do Flutter](https://flutter.dev/docs)
4. Abra uma issue no repositório do projeto

## Contribuindo

Contribuições são bem-vindas! Por favor:

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

---

**Boa sorte com o desenvolvimento! 🚀**
