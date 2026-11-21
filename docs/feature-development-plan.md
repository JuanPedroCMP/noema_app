# Plano de desenvolvimento de recursos

## Estado encontrado

- O logotipo dentro do app já acompanha o tema. O Android já tem ícone
  adaptativo e camada monocromática; os ativos instaláveis de desktop são
  estáticos por natureza.
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
- Abrir o nó recomendado agora cria uma tarefa persistida para as categorias
  ausentes (múltipla escolha, dissertativa e flashcards); o worker Android/Linux
  gera e salva o pacote e impede duplicação quando uma tarefa é repetida.
- Descrições, correções e pacotes enfileirados são processados por tarefas
  one-off do WorkManager no Android e systemd no Linux. Conclusões importantes
  usam notificação local e o shell também mostra SnackBars.
- Pacotes manuais oferecem prévia ou enfileiramento persistente em segundo plano.
  Se a tela for fechada durante a prévia, o resultado é salvo/notificado
  enquanto o processo continua vivo; para sobreviver ao encerramento, deve-se
  escolher o enfileiramento.
- Ícones de desktop estão em fundo neutro e consistentes com a marca, mas
  arquivos de launcher permanecem estáticos. O logotipo dentro do app acompanha
  o tema e o launcher Android oferece a camada monocromática tematizável.

## Entregas desta rodada

- Corrigido o identificador `create_flashcards` e o nome `weight` enviado no
  prompt de múltipla escolha. O cálculo líquido e a exibição dos pontos já
  existiam e permanecem cobertos por testes.
- Adicionada edição de grafo por IA e geração de pacote misto, sem alterações na
  API.
- O ícone Android preserva o fundo neutro, a camada monocromática tematizável e
  uma margem maior para máscaras adaptativas. A logo dentro do app já acompanha
  as cores do tema; ícones de desktop continuam estáticos.
- Corrigida a permissão `INTERNET` no manifesto principal Android, necessária
  para builds release e tarefas de IA fora do modo debug.
- O plugin de notificações foi fixado em `flutter_local_notifications 22.3.3`,
  compatível com o Android SDK 36 do projeto, e o core library desugaring foi
  habilitado.
- Verificações finais: APK Android release e bundle Linux debug compilam; 208
  testes passam. Há uma falha isolada no teste de largura de camadas de
  `sugiyama_test.dart`, sem relação com os arquivos de IA/filas alterados.

## Plano e critérios de aceite

1. **Marca adaptável**
   - Revisar os ativos nativos Android e desktop para fundo neutro, formas
     seguras e consistência com a marca existente.
   - Preservar a camada monocromática Android para lançadores com ícones
     temáticos. Ícones instaláveis de desktop não acompanham em tempo real o
     tema Flutter sem integração específica de cada sistema.

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
   - Ao abrir o próximo nó recomendado, enfileirar conteúdo somente para
     categorias ausentes e deduplicar tarefas ativas por nó.
   - Criar questões e flashcards vinculados ao nó; exibir o estado na fila e
     emitir notificação quando o pacote terminar.

6. **Pontuação de múltipla escolha (implementada)**
   - Somar o peso de cada alternativa correta selecionada e subtrair o peso de
     cada incorreta selecionada.
   - Normalizar o resultado para a escala de revisão existente, mantendo um
     comportamento padrão para alternativas sem peso e persistindo os pontos
     líquidos para auditoria/apresentação.

7. **Execução fora da página e avisos (parcial)**
   - Manter tarefas independentes da tela que as iniciou, com fila persistente,
     recuperação após interrupção, retries limitados e prevenção de duplicatas.
   - Tarefas persistidas continuam após navegação e são agendadas no Android e
     Linux; retries e IDs estáveis evitam perder ou duplicar pacotes.
   - Notificações de sistema estão integradas para conclusões importantes. A
     geração manual com prévia não é retomável após morte do processo; a opção
     explícita de enfileiramento persiste o pedido e usa o worker.
   - WorkManager pode adiar jobs e não executa durante force-stop. No Linux, o
     worker experimental requer sessão systemd do usuário; sandbox Flatpak/Snap
     não é suportado e restrições de rede/backoff são ignoradas pelo plugin.
     Nenhum app local pode garantir execução após force-stop.
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
