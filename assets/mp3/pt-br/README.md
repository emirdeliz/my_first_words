# Áudios MP3 - Português Brasil

Esta pasta contém os arquivos de áudio MP3 para as palavras e frases do app.

## Estrutura de arquivos

Os arquivos devem seguir o padrão de nomenclatura baseado no texto:
- Texto: "Olá" → Arquivo: `ola.mp3`
- Texto: "Estou com fome" → Arquivo: `estou_com_fome.mp3`

## Palavras que precisam de áudio

### Necessidades Básicas
- fome.mp3
- sede.mp3
- banheiro.mp3
- sono.mp3
- dor.mp3
- ajuda.mp3

### Emoções
- feliz.mp3
- triste.mp3
- bravo.mp3
- com_medo.mp3
- animado.mp3
- cansado.mp3

### Atividades
- brincar.mp3
- comer.mp3
- beber.mp3
- dormir.mp3
- ler.mp3
- desenhar.mp3

### Social
- ola.mp3
- tchau.mp3
- por_favor.mp3
- obrigado.mp3
- desculpe.mp3
- sim.mp3
- nao.mp3

## Como adicionar novos áudios

1. Grave ou obtenha o arquivo MP3
2. Nomeie o arquivo seguindo o padrão (texto em minúsculas, espaços substituídos por underscore)
3. Coloque o arquivo nesta pasta
4. O app automaticamente detectará e usará o áudio quando disponível

## Testando a funcionalidade

Para testar se a funcionalidade está funcionando:

1. Adicione um arquivo MP3 real (ex: `ola.mp3`) nesta pasta
2. Execute o app
3. Toque no card "Olá" 
4. O app deve tocar o MP3 se disponível, ou usar TTS como fallback

## Nota importante

- O app sempre tentará tocar o MP3 primeiro
- Se o MP3 não estiver disponível, usará TTS como fallback
- Isso garante que o app sempre funcione, mesmo sem áudios MP3
