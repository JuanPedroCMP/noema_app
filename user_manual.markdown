# Manual do usuário do Noema

Este manual explica como usar o aplicativo Noema em cada tela, quais campos devem ser preenchidos, quais ações estão disponíveis e como cada funcionalidade funciona no dia a dia.

O objetivo deste guia é funcionar como referência prática para o uso final do app, cobrindo todos os módulos principais em um único arquivo.

## 1. Visão geral do app

O Noema é um sistema de estudo e organização de conhecimento com foco em:

- Notas e anotações
- Grafos de conceitos
- Exercícios e revisão
- Flashcards
- Sessões de estudo
- Configuração pessoal
- Processamento assistido por IA

A navegação principal do app é organizada em um shell com os itens abaixo:

- Início
- Notas
- Grafos
- Flashcards
- Sessões
- Configuração
- Fila de IA

Quando o usuário ainda não está autenticado, o app redireciona para a tela de login. Depois do login, ele volta para a página acessada anteriormente ou para a tela inicial.

---

## 2. Acesso e autenticação

### 2.1 Tela de login

Local: primeira tela exibida para usuários não autenticados.

Campos:

- Usuário: nome de usuário ou identificador do cadastro
- Senha: senha da conta

Ações:

- Entrar: valida as credenciais e acessa o app
- Esqueceu a senha?: inicia o fluxo de recuperação
- Criar conta: vai para a tela de cadastro

Validações:

- Usuário e senha são obrigatórios
- Se qualquer um estiver vazio, a autenticação não é concluída
- Credenciais incorretas geram erro de autenticação

### 2.2 Tela de cadastro

Local: acessada via "Criar conta".

Campos:

- Nome de usuário
- Nome de exibição
- E-mail
- Senha
- Confirmação da senha

Regras:

- Todos os campos são obrigatórios
- A senha precisa ter no mínimo 6 caracteres
- A confirmação de senha precisa ser idêntica à senha
- Se a senha não coincidir, o app avisa que as senhas não conferem

Ações:

- Criar conta: registra o usuário e redireciona para o login
- Voltar: retorna para a tela de login

### 2.3 Recuperação de senha

Acesso: botão "Esqueceu a senha?" na tela de login.

Fluxo:

1. Informe o usuário ou e-mail da conta
2. Solicite o código de recuperação
3. Digite o código recebido
4. Informe a nova senha
5. Confirme a nova senha
6. Salve a alteração

Validações:

- Usuário/e-mail obrigatório para gerar código
- Código inválido ou expirado gera erro
- Senhas diferentes geram aviso
- A alteração bem-sucedida pede que o usuário faça login novamente

---

## 3. Tela inicial

Local: rota principal após autenticação.

A tela inicial serve como ponto de entrada para o estudo e organização. Ela pode apresentar:

- boas-vindas ao usuário
- visão do conteúdo estudado
- ações rápidas para acessar sessões, notas e grafos
- botão para sair do app

Ações disponíveis:

- Acessar sessões de estudo
- Acessar notas
- Acessar grafos
- Encerrar sessão com logout

Observação:

- O logout encerra a autenticação ativa e retorna para a tela de login.

---

## 4. Módulo de notas

### 4.1 Lista de notas

Local: menu "Notas".

Nesta tela o usuário pode:

- Buscar notas existentes
- Criar novas anotações
- Importar arquivos
- Exportar notas
- Ver notas na área ativa ou na lixeira
- Abrir, restaurar e excluir notas

### 4.2 Criar nota

Ações:

- Botão de criação de nova nota
- O app geralmente pede um título antes de abrir a nota

Campo obrigatório:

- Título da nota

Validação:

- Título vazio não é aceito
- O app pode avisar se a nota com esse nome já existe

### 4.3 Importar nota

Ações disponíveis:

- Importar arquivo de nota

Formatos compatíveis podem incluir:

- Markdown
- TXT
- HTML
- JSON/Quill
- PDF com texto selecionável
- Arquivo de documento compatível

Fluxo:

1. Selecionar arquivo
2. O conteúdo é convertido para o formato interno do app
3. O app pode pedir o título da nota
4. A nota é salva no sistema

### 4.4 Exportar nota

Ao abrir uma nota, o usuário pode exportar o conteúdo em formatos como:

- Markdown
- HTML
- TXT
- JSON/Quill

A exportação salva o arquivo localmente no dispositivo.

### 4.5 Lixeira e restauração

Na lista de notas há separação entre:

- notas ativas
- notas arquivadas/lixeira

Ações possíveis:

- mover para lixeira
- restaurar nota
- excluir definitivamente

Importante:

- A exclusão definitiva é destrutiva e normalmente exige confirmação.

### 4.6 Editor de notas

Ao abrir uma nota, o usuário acessa o editor:

- título da nota
- conteúdo em editor rico
- histórico de versões
- links ou conceitos relacionados
- ações de salvar e exportar
- apoio de IA para melhorar o texto

Elementos principais:

- Campo de título
- Área de escrita
- Indicador de salvamento
- Botões de ações da nota

Funcionalidades do editor:

- Salvamento manual
- Auto-save
- Criação de versões da nota
- Visualização do histórico
- Vinculação de conceitos do grafo
- Melhoria de texto com IA
- Remoção de links e conceitos relacionados

Indicadores visuais:

- conteúdo pendente de salvamento
- nota salva com sucesso
- erro de salvamento

### 4.7 Regras do editor

- O título da nota deve ser preenchido para identificá-la corretamente
- Alterações podem ser salvas manual ou automaticamente
- O sistema salva versões periódicas ou quando solicitadas

---

## 5. Módulo de grafos

### 5.1 Lista de grafos

Local: menu "Grafos".

Nesta tela o usuário pode:

- ver seus grafos
- criar grafo vazio
- criar grafo com ajuda da IA
- importar grafo em formato JSON
- abrir um grafo existente
- excluir um grafo

### 5.2 Criar grafo vazio

Campos:

- Título do grafo (obrigatório)
- Descrição (opcional)

Validação:

- Título vazio é bloqueado

Ações:

- Criar grafo

### 5.3 Criar grafo com IA

Este fluxo gera a estrutura inicial do mapa de conhecimento com ajuda da IA.

Campos:

- tema ou assunto
- objetivo de aprendizagem ou instrução extra

Uso:

- o usuário descreve o tema
- a IA cria uma estrutura com conceitos e links
- a estrutura pode ser revisada antes do salvamento final

### 5.4 Importar grafo em JSON

Ação opcional de criação/importação.

Campo:

- JSON do grafo

Uso:

- cole a estrutura do grafo em formato JSON
- o app tenta importar os nós e as relações

### 5.5 Excluir grafo

Ação disponível na lista de grafos.

A exclusão geralmente exige confirmação por ser uma ação destrutiva.

### 5.6 Página do grafo

Ao abrir um grafo, o usuário acessa a área de edição visual.

Elementos da página:

- nome do grafo
- descrição
- contagem de nós e relações
- ferramentas de organização
- busca por conceitos
- ajuste de zoom
- canvas de relacionamento

Ferramentas principais:

- organizar automaticamente o grafo
- criar nó
- criar relação entre conceitos
- buscar conceito
- ajustar visualização
- ampliar/reduzir zoom
- ajustar tela ao mapa

### 5.7 Nós e relações

No grafo, o usuário pode:

- criar nós de conhecimento
- vincular nós por relações
- editar título e descrição do conceito
- associar exercícios a um nó
- associar flashcards a um nó
- abrir detalhes do nó

Dica:

- O grafo funciona como base para diversos módulos do app, especialmente exercícios, flashcards e sessões de estudo.

---

## 6. Exercícios

### 6.1 Lista de exercícios de um nó

Local: dentro de um nó do grafo ou na lista de exercícios.

Na página de exercícios, o usuário pode ver:

- título da questão
- tipo da questão
- status de revisão
- ações para responder, editar ou excluir

Filtros disponibilizados:

- todos
- para revisar
- abertas
- múltipla escolha

Também há busca por texto.

### 6.2 Criar questão dissertativa ou Feynman

Campos:

- Título
- Enunciado
- Tipo:
  - Dissertativa
  - Método Feynman
- Resposta de referência (opcional)

Ações:

- salvar questão
- gerar com IA
- responder
- visualizar questão

Validações:

- título obrigatório
- enunciado obrigatório
- tipo deve ser selecionado

### 6.3 Criar questão de múltipla escolha

Campos:

- Título
- Enunciado
- Alternativas
- Alternativa correta
- Explicação opcional

Ações:

- salvar questão
- gerar com IA
- responder
- visualizar resposta

Validações:

- título obrigatório
- enunciado obrigatório
- é necessário ter alternativas válidas
- a questão precisa ter uma resposta correta

### 6.4 Responder exercícios

Ao responder uma questão, o app registra:

- tempo de resposta
- resposta do usuário
- resultado da avaliação
- próxima data de revisão

O app pode corrigir automaticamente, dependendo da configuração de correção e das integrações de IA.

### 6.5 Histórico de respostas

A lista de respostas permite ao usuário verificar:

- quando respondeu
- qual foi a resposta
- como a questão foi avaliada
- qual foi o status da revisão

---

## 7. Flashcards

### 7.1 Visão geral

Local: menu "Flashcards".

O módulo de flashcards ajuda o usuário a revisar conceitos em formato de pergunta e resposta.

Funcionalidades:

- visualizar cards
- revisar decks
- criar flashcards
- editar ou excluir cards
- associar flashcards a nós de um grafo

### 7.2 Criar flashcard

Campos comuns:

- título do card
- pergunta ou afirmação
- resposta ou conceito-chave
- conceito relacionado

Regras:

- o flashcard precisa ter conteúdo válido para ser salvo
- o vínculo com um conceito ou deck ajuda na revisão específica

### 7.3 Revisão de flashcards

Ao iniciar a revisão:

- o app escolhe os cards pendentes ou vencidos
- exibe a frente do card
- depois mostra a resposta
- o usuário avalia o desempenho

Possíveis avaliações:

- fácil
- médio
- difícil

Essas avaliações influenciam a próxima data de revisão do card.

### 7.4 Decks personalizados

O usuário pode:

- criar decks por tema
- organizar flashcards por assunto
- revisar somente determinado conjunto

---

## 8. Sessões de estudo

### 8.1 Lista de sessões

Local: menu "Sessões".

Aqui o usuário vê suas sessões criadas.

Ações:

- criar nova sessão
- abrir sessão existente
- editar sessão
- iniciar sessão
- arquivar sessão

Status possíveis:

- em andamento
- concluída
- interrompida
- rascunho

### 8.2 Criar sessão

Campos:

- título da sessão
- descrição (opcional)
- duração alvo em minutos
- seleção de questões ou atividades

Fluxo:

1. crie ou escolha uma sessão
2. selecione questões relacionadas ao assunto
3. defina a duração e a descrição
4. salve

Importante:

- é necessário ter pelo menos uma questão selecionada para iniciar a sessão

### 8.3 Iniciar sessão

Ao iniciar a sessão, o app:

- registra o início da atividade
- salva um log de progresso
- apresenta uma questão por vez
- mede o tempo de duração

Ações disponíveis durante a sessão:

- avançar para próxima questão
- interromper sessão
- salvar histórico de progresso

### 8.4 Interrupção e conclusão

Se o usuário interromper a sessão:

- o progresso atual é salvo no histórico
- a sessão pode aparecer como interrompida

Se a sessão terminar:

- o status muda para concluída
- o número de atividades concluídas e a duração real são registrados no histórico

---

## 9. Configuração

Local: menu "Configuração".

A tela de configuração centraliza ajustes pessoais e preferências do app.

### 9.1 Perfil

Campos editáveis:

- nome de usuário
- nome de exibição
- e-mail
- senha

Ações:

- editar perfil
- alterar senha

Validações:

- senha e confirmação precisam coincidir
- campos vazios ou inválidos geram erro

### 9.2 Tema de cores

Acesso: seção de visualização.

Funcionalidades:

- criar tema
- alterar tema ativo
- editar tema visual
- alternar entre modo claro e escuro

### 9.3 Tipografia

Funcionalidades:

- criar tema tipográfico
- selecionar tema ativo
- ajustar fonte principal e destaques
- ajustar escala de texto

### 9.4 Chaves de API

Acesso: seção de integrações.

Uso:

- cadastrar chave do provedor de IA
- atualizar ou remover chave
- habilitar integrações de geração assistida por IA

Observação:

- o app informa que as chaves devem ser tratadas com cuidado e que o uso depende do provedor configurado

### 9.5 Conta Google

Funcionalidades:

- verificar vínculo com conta Google
- ligar conta Google
- desligar conta Google

### 9.6 Preferências

Opções disponíveis:

- idioma do app
  - usar idioma do dispositivo
  - Português
  - English
- modo de correção de exercícios
  - automática com IA
  - manual
- controle de geração simultânea de tarefas de IA
  - nível de concorrência de 1 a 8

Essas configurações são salvas por conta do usuário e podem ser recarregadas ou atualizadas conforme o comportamento do app.

---

## 10. Fila de IA

Local: menu "Fila de IA".

A fila de IA centraliza tarefas automáticas relacionadas a geração e processamento.

### 10.1 Status da fila

A tela mostra:

- fila em andamento
- tarefas pendentes
- tarefas em tentativa de nova execução
- falhas
- tarefas concluídas

Ações disponíveis:

- pausar fila
- retomar fila
- atualizar fila
- limpar tarefas concluídas

### 10.2 Categorias da fila

As tarefas podem aparecer em categorias como:

- na fila
- em retentativa
- falhas
- concluídas

### 10.3 Limpeza de histórico

A ação de limpar histórico concluído remove tarefas finalizadas e antigas da fila, normalmente com confirmação do usuário.

### 10.4 Situações em que a IA é usada

A IA pode ser usada para:

- gerar grafos e conceitos
- melhorar notas
- criar exercícios
- gerar questão de múltipla escolha
- criar e avaliar respostas
- dar suporte na revisão e correção

---

## 11. Fluxos práticos de uso

### 11.1 Fluxo recomendado para estudar

1. Faça login
2. Crie ou abra um grafo
3. Adicione conceitos e relacionamentos
4. Crie exercícios e flashcards
5. Organize uma sessão de estudo
6. Revise as respostas
7. Acompanhe a fila de IA para tarefas automáticas

### 11.2 Fluxo recomendado para anotações

1. Crie uma nota
2. Escreva ou importe conteúdo
3. Relacione a nota a conceitos do grafo
4. Use IA para melhorar o texto
5. Salve e crie versões quando necessário

### 11.3 Fluxo recomendado para revisão ativa

1. Crie questões e cards
2. Realize a revisão
3. Avalie o desempenho
4. O sistema agenda uma próxima revisão com base na resposta

### 11.4 Fluxo recomendado para sessões de estudo

1. Crie uma sessão
2. Selecione as questões
3. Defina duração e descrição
4. Inicie a sessão
5. Avance ou interrompa conforme necessário
6. Revise o histórico de progresso

---

## 12. Dicas práticas e cuidados

- O título é obrigatório em notas e grafos
- Senhas devem coincidir para cadastro e alteração
- Exclusão e arquivamento geralmente exigem confirmação
- Recursos de IA dependem de provedor e chave configurados
- Algumas integrações podem não funcionar se a rede ou o serviço estiver indisponível
- Sessões em andamento devem ser interrompidas com cuidado porque o progresso é registrado no histórico

---

## 13. Campos obrigatórios em resumo

### Notas
- Título

### Grafos
- Título

### Login
- Usuário
- Senha

### Cadastro
- Nome de usuário
- Nome de exibição
- E-mail
- Senha
- Confirmação da senha

### Alteração de senha
- Senha
- Confirmação da senha

### Sessão de estudo
- Título
- Questões selecionadas
- Duração alvo (recomendada)

### Exercícios
- Título
- Enunciado
- Alternativas válidas em múltipla escolha

---

## 14. Conclusão

O Noema é um aplicativo de estudo estruturado em torno de organização de conhecimento, revisão ativa e apoio de inteligência artificial. A combinação de notas, grafos, flashcards, exercícios e sessões permite criar um fluxo contínuo de aprendizagem e reforço de memória.

Para usar o app com eficiência, o ideal é:

- organizar conceitos em grafos
- transformar esses conceitos em exercícios e flashcards
- revisar com sessões de estudo
- manter perfil e preferências personalizadas
- monitorar a fila de IA quando houver processamento automático

Este manual serve como guia completo para o uso diário do aplicativo.
