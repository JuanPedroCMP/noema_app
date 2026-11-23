# Plano de desenvolvimento de recursos

## Estado encontrado

- O logotipo dentro do app acompanha o tema. O Android tem ícone adaptativo e
  camada monocromática, cuja tonalização é controlada pelo launcher. A janela
  Linux atualiza seu ícone de acordo com o ColorScheme ativo; ativos de
  launcher/instalação de desktop permanecem estáticos.
- O grafo agora aceita patches de IA com prévia, validação de IDs/endpoints,
  checagem de concorrência e aplicação transacional; descrições de nós novos ou
  renomeados voltam para a fila local.
- A descrição de nó já recebe todo o grafo em formato compacto: títulos e
  relações com IDs sequenciais, sem descrições extensas.
- O painel do nó agora monta pacotes mistos configuráveis de múltipla escolha,
  questões dissertativas, Feynman e flashcards, com prévia e gravação atômica.
- A pontuação já soma o peso das alternativas corretas selecionadas, subtrai o
  das incorretas e mostra os pontos líquidos; a escala de revisão continua
  limitada a 0..1 por contrato.
- A geração automática para o nó recomendado é uma preferência persistida,
  desativada por padrão e configurável por tipo de questão. Quando ativada, o
  app gera sem interromper se o nó estiver vazio; se já houver exercícios,
  flashcards ou recursos vinculados, pede confirmação antes de acrescentar o
  pacote configurado. Recursos existentes são incluídos no contexto da IA.
- Descrições, correções e pacotes enfileirados são processados por tarefas
  persistentes do WorkManager: one-off no Android, `BGProcessingTask` no iOS e
  systemd no Linux. Conclusões importantes usam notificação local em Android,
  iOS e Linux, além de SnackBars enquanto o shell está aberto.
- Pacotes manuais oferecem prévia ou enfileiramento persistente em segundo plano.
  Se a tela for fechada durante a prévia, o resultado é salvo/notificado
  enquanto o processo continua vivo; para sobreviver ao encerramento, deve-se
  escolher o enfileiramento.
- O ícone da janela Linux é renderizado do ColorScheme ativo, sobre fundo
  neutro e dentro de forma arredondada. O app Android mantém a camada
  monocromática adaptativa; quem define sua cor é o launcher, não o tema interno
  do Noema. Ícones de instalação/launcher Windows e macOS permanecem estáticos.

## Entregas desta rodada

- Corrigido o identificador `create_flashcards` e o nome `weight` enviado no
  prompt de múltipla escolha. O cálculo líquido e a exibição dos pontos já
  existiam e permanecem cobertos por testes.
- Adicionada edição de grafo por IA e geração de pacote misto, sem alterações na
  API.
- O ícone Android preserva o fundo neutro, a camada monocromática tematizável e
  uma margem maior para máscaras adaptativas. A logo interna e o ícone de janela
  Linux acompanham a paleta do app; os ícones de instalação Windows/macOS não.
- Corrigida a permissão `INTERNET` no manifesto principal Android, necessária
  para builds release e tarefas de IA fora do modo debug.
- O plugin de notificações foi fixado em `flutter_local_notifications 22.3.3`,
  compatível com o Android SDK 36 do projeto, e o core library desugaring foi
  habilitado.
- Verificações finais desta revisão: `flutter analyze` sem issues, 212 testes
  passam e o bundle Linux debug compila. O build Android release havia passado
  na rodada anterior.

## Plano e critérios de aceite

1. **Marca adaptável**
   - Logo dentro do app e ícone de janela Linux acompanham a paleta ativa.
   - Preservar a camada monocromática Android para lançadores que aplicam
     tonalização temática; o app não pode impor a cor interna do tema ao launcher.
   - Ícones de instalação Windows/macOS e atalhos de launcher Android são
     controlados pelo sistema e permanecem estáticos/tonalizados pelo sistema.

2. **Edição de grafo com IA**
   - Enviar somente títulos de nós e relações completas, usando IDs numéricos
     sequenciais e IDs de relações igualmente compactos.
   - Usar um contrato de resposta de patch separado da criação inicial: excluir,
     renomear, adicionar nós marcados como novos e adicionar/editar/excluir
     relações.
   - Traduzir IDs compactos para IDs locais somente após validar o patch inteiro;
     persistir em transação e não aceitar IDs/endpoints desconhecidos.
   - Regerar em segundo plano a descrição de nós novos ou renomeados.

3. **Contexto compacto para descrições (implementado)**
   - Enviar o mapa inteiro como títulos e relações compactas, identificando o nó
     alvo, sem descrições longas nem IDs locais.
   - Validar a resposta e preservar descrições existentes quando uma geração
     automática não for necessária.

4. **Pacotes de estudo**
   - Configurar a quantidade de questões por tipo e de flashcards.
   - Gerar tipos em paralelo respeitando a fila/concurrency limit existente.
   - Validar cada resultado, apresentar prévia e salvar o pacote de modo atômico.

5. **Conteúdo automático do próximo nó**
   - Manter configuração persistida, desativada por padrão, com quantidades
     ajustáveis para múltipla escolha, dissertativas, Feynman e flashcards.
   - Quando ativada, gerar em segundo plano sem confirmação se o nó não tiver
     material de estudo existente; caso já tenha, pedir confirmação antes de
     acrescentar o pacote.
   - Usar recursos de estudo vinculados como contexto, deduplicar tarefas
     ativas, exibir estado na fila e notificar ao concluir.

6. **Pontuação de múltipla escolha (implementada)**
   - Somar o peso de cada alternativa correta selecionada e subtrair o peso de
     cada incorreta selecionada.
   - Normalizar o resultado para a escala de revisão existente, mantendo um
     comportamento padrão para alternativas sem peso e persistindo os pontos
     líquidos para auditoria/apresentação.

7. **Execução fora da página e avisos (implementado com limites do SO)**
   - Manter tarefas independentes da tela que as iniciou, com fila persistente,
     recuperação de tarefas interrompidas por lease/heartbeat, retries
     limitados e prevenção de duplicatas.
   - As tarefas persistidas são agendadas pelo WorkManager Android, por
     `BGProcessingTask` no iOS e pelo worker systemd experimental no Linux. No
     iOS, o identificador permitido é declarado no `Info.plist` e seus handlers
     são registrados no `AppDelegate` para suportar relançamento do app.
   - Notificações de sistema estão integradas para conclusões importantes em
     Android, iOS e Linux; a permissão de notificações iOS/Android é solicitada
     quando o usuário enfileira uma tarefa.
   - A geração manual com prévia não é retomável após morte do processo; a
     opção explícita de enfileiramento persiste o pedido e usa o worker.
   - WorkManager pode adiar jobs e não executa durante force-stop; o iOS decide
     quando executar `BGProcessingTask` e pode cancelá-la; no Linux, o worker
     experimental requer sessão systemd do usuário. Nenhum app local pode
     garantir execução após force-stop, encerramento forçado ou restrições do
     sistema.
   - O fluxo manual de pacote oferece prévia e continua após fechar a tela se o
     processo permanecer vivo; sua geração não é retomável após encerramento do
     processo. A geração automática do nó recomendado é enfileirada e retomável.

8. **Verificação integrada**
   - Cobrir migração v9→v10, payloads, idempotência do worker, compactação e
     aplicação transacional do patch, concorrência, tipos e pesos.
   - Rodar testes focados, análise estática e builds Android/Linux.

## Sequência de implementação

Marca adaptável e pontuação estão atendidas dentro dos limites de launcher. O
contrato de edição de grafo e o contexto compacto já estão integrados à tela. O
gerador de pacote alimenta a prévia manual e o worker, com opção manual de fila
persistente; permanecem como limites a execução após force-stop e a retomada da
prévia manual após encerramento do processo.
