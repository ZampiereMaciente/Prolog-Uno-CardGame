% Nome: Renato Zampiere Maciente
% Reproduzir o jogo Uno em prolog.

% cores das cartas
cor(amarela).
cor(azul).
cor(verde).
cor(vermelho).

% valores das cartas de 0 a 9 e 1 a 9
valor(Number) :-
              between(0,9,Number).

valor(Number) :-
              between(1,9,Number).

% cartas especiais do Uno
especial(pula).
especial(pula).
especial(inverte).
especial(inverte).
especial(compra2).
especial(compra2).

% gerar as cartas coringas especiais
coringa(Cor, Valor) :-
    Cor = preto, between(1, 4, Valor).

coringa(Cor, Valor) :-
    Cor = compra4, between(1, 4, Valor).

% gerar um baralho completo
baralho(Baralho) :-
    findall([C, V], (cor(C), valor(V)), CartasNumericas),
    findall([C, E], (cor(C), especial(E)), CartasEspeciais),
    findall([C, V], (coringa(C, V)), CartasCoringa),
    append(CartasNumericas, CartasEspeciais, Aux),
    append(Aux, CartasCoringa, Baralho).
    %printLista(Baralho).

% ------------------------------------------------------
% predicado para contar o número de cartas no baralho
contarCartasBaralho(Quantidade) :-
    baralho(Baralho),
    length(Baralho, Quantidade).
% ------------------------------------------------------

% importe a biblioteca SWI-Prolog para o predicado random_permutation
:- use_module(library(random)).

% embaralhar o baralho
embaralharBaralho(BaralhoEmbaralhado) :-
    baralho(Baralho),
    random_permutation(Baralho, BaralhoEmbaralhado).

% criando mao dos jogadores
criaMaoJogadores(Jogador1,Jogador2,Monte,NovoBaralho,NumeroCartasNovoBaralho) :-
    embaralharBaralho(BaralhoEmbaralhado),
    length(Jogador1, 7),
    append(Jogador1, Restante1, BaralhoEmbaralhado),

    length(Jogador2, 7),
    append(Jogador2, Restante2, Restante1),

    length(Monte, 1),
    append(Monte, Restante3, Restante2),

    NovoBaralho = Restante3,
    length(NovoBaralho, NumeroCartasNovoBaralho).
    
% Predicado para adicionar duas cartas a mao do jogador
compraDuas(JogadorResult,N) :-
    criaMaoJogadores(Jogador1,_,_,NovoBaralho,_),
    length(JogadorAux,2),
    append(JogadorAux,_,NovoBaralho),
    append(Jogador1,JogadorAux,JogadorResult),
    length(JogadorResult,N),
    printLista(JogadorResult).

% Predicato para adicionar quatro cartas a mao do jogador
compraQuatro(JogadorResult,N) :-
    criaMaoJogadores(Jogador1,_,_,NovoBaralho,_),
    length(JogadorAux,4),
    append(JogadorAux,_,NovoBaralho),
    append(Jogador1,JogadorAux,JogadorResult),
    length(JogadorResult,N),
    printLista(JogadorResult).

% -----------------------------------------------------------
% Predicato para printar listas grandes com fins de debug
printLista([]).
printLista([Result|Rest]) :-
    writeln(Result),
    printLista(Rest).
% -----------------------------------------------------------

% predicato que inicia o jogo
inicioJogo() :-
    criaMaoJogadores(Jogador1,Jogador2,Monte,Baralho,_),
    write('mao do jogador 1: '),
    writeln(Jogador1),
    write('mao da maquina: '),
    writeln(Jogador2),
    write('monte: '),
    writeln(Monte),
    jogando(Jogador1,Jogador2,Monte,Baralho).

% chama o inicio do jogo
jogando(Jogador1,Jogador2,Monte,Baralho) :-
    jogador1(Jogador1,Jogador2,Monte,Baralho).

% tenta fazer uma jogada com a mao da maquina
realizaJogadaMaquina(Jogador2,Monte,Baralho,NovaMao,NovoMonte,Jogador1) :-
    (removeMao(Jogador2,Monte,NovaMao,NovoMonte),
    jogador1(Jogador1,NovaMao,NovoMonte,Baralho));
    
    compra_uma_baralho(Jogador2,Monte,Baralho,NovaMao,NovoBaralho),
    realizaJogadaMaquina(NovaMao,Monte,NovoBaralho,_,_,Jogador1).

% condicao de vitoria do jogo
jogador1(Jogador1,_,_,_) :- Jogador1 = [], writeln('jogador 1 Venceu!').
jogador1(_,Jogador2,_,_) :- Jogador2 = [], writeln('jogador 2 Venceu!').
jogador1(Jogador1,Jogador2,_,Baralho) :-
    (Baralho = [],
    length(Jogador1, Quantidade1),
    length(Jogador2, Quantidade2),
    Quantidade2 > Quantidade1,
    writeln('jogador 1 venceu!'));

    (Baralho = [],
    length(Jogador1, Quantidade1),
    length(Jogador2, Quantidade2),
    Quantidade1 > Quantidade2,
    writeln('jogador 2 venceu!'));
    
    Baralho = [],
    length(Jogador1, Quantidade1),
    length(Jogador2, Quantidade2),
    Quantidade1 == Quantidade2,
    writeln('empate entre os jogadores!').

% predicato que realiza a jogada do jogador
jogador1(Jogador1,Jogador2,Monte,Baralho) :-
    nl,
    writeln('vez do jogador'),
    writeln('mao do jogador'),
    printLista(Jogador1),
    write('monte: '),
    writeln(Monte),
    jogadaUsuario(Jogador1,Jogador2,Monte,Baralho,_,_,_).

% condicao de vitoria do jogo
jogadaMaquina(Jogador1,_,_,_,_,_,_) :- Jogador1 = [], writeln('jogador 1 Venceu!').
jogadaMaquina(_,Jogador2,_,_,_,_,_) :- Jogador2 = [], writeln('jogador 2 Venceu!').
jogadaMaquina(Jogador1,Jogador2,_,Baralho,_,_,_) :-
    (Baralho = [],
    length(Jogador1, Quantidade1),
    length(Jogador2, Quantidade2),
    Quantidade2 > Quantidade1,
    writeln('jogador 1 venceu!'));

    (Baralho = [],
    length(Jogador1, Quantidade1),
    length(Jogador2, Quantidade2),
    Quantidade1 > Quantidade2,
    writeln('jogador 2 venceu!'));
    
    Baralho = [],
    length(Jogador1, Quantidade1),
    length(Jogador2, Quantidade2),
    Quantidade1 == Quantidade2,
    writeln('empate entre os jogadores!').

% predicato que realiza a jogada da maquina
jogadaMaquina(Jogador1,Jogador2,Monte,Baralho,NovaMao,NovoMonte,_) :-
    nl,
    writeln('vez da maquina'),
    writeln('mao da maquina'),
    printLista(Jogador2),
    write('monte: '),
    writeln(Monte),
    realizaJogadaMaquina(Jogador2,Monte,Baralho,NovaMao,NovoMonte,Jogador1).

% predicato que realiza a jogada do jogador
jogadaUsuario(Jogador,Jogador2,Monte,Baralho,NovaMao,NovoMonte,NovoBaralho) :-
    nl,
    write('digite uma carta, no caso de nao ter a carta digite 1: '),read(Term),
    (member(Term, Jogador),
    removeMaoJagador(Jogador,Monte,Term,NovaMao,NovoMonte),
    jogadaMaquina(NovaMao,Jogador2,NovoMonte,Baralho,_,_,_));
    
    compra_uma_baralho(Jogador,Monte,Baralho,NovaMao,NovoBaralho),
    jogadaUsuario(NovaMao,Jogador2,Monte,NovoBaralho,_,_,_).
     
% predicato para comprar uma carta do baralho para a mao
compra_uma_baralho(_,_,Baralho,_,_) :- Baralho = [], jogando1(_,_,_,Baralho).
compra_uma_baralho(Jogador,Monte,Baralho,NovaMao,NovoBaralho) :-
    Baralho = [Primeira|_],
    adicionar_lista_primeira_posicao(Primeira, Jogador, NovaMao),
    delete(Baralho,Primeira,NovoBaralho),
    writeln('--------------------------------------------------------------'),
    writeln('compra uma pra mao, nova mao: '),
    printLista(NovaMao),
    write('monte: '),
    writeln(Monte),
    write('novo baralho: '),
    writeln(NovoBaralho),
    writeln('--------------------------------------------------------------'), nl.

% predicado para verificar carta na mao do jogador
testeLista(Term,Primeiro,Segundo) :-
    Term = [Primeiro,Segundo].

% predicato para remover uma carta da mao do jogador
removeMaoJagador(Jogador,Monte,Term,NovaMao,NovoMonte) :-
    (verificaMonte(Monte,ValorEsquerda,_),
    testeLista(Term,Primeiro,_),
    ValorEsquerda == Primeiro,
    adicionar_lista_primeira_posicao(Term, Monte, NovoMonte),
    remove_lista(Jogador, Term, NovaMao));
    
    verificaMonte(Monte,_,ValorDireita),
    testeLista(Term,_,Segundo),
    ValorDireita == Segundo,
    adicionar_lista_primeira_posicao(Term, Monte, NovoMonte),
    remove_lista(Jogador, Term, NovaMao).

% predicato para remover uma carta da mao da maquina
removeMao(Jogador,Monte,NovaMao,NovoMonte) :-
    (verificaMonte(Monte,ValorEsquerda,_),
    encontra_lista_com_elemento(Jogador, ValorEsquerda, ListaComElemento),
    adicionar_lista_primeira_posicao(ListaComElemento, Monte, NovoMonte),
    writeln('--------------------------------------------------------------'),
    write('novo monte: '),
    writeln(NovoMonte),
    remove_lista(Jogador, ListaComElemento, NovaMao),
    write('nova mao: '),
    writeln(NovaMao),
    writeln('--------------------------------------------------------------')),nl;

    verificaMonte(Monte,_,ValorDireita),
    encontra_lista_com_elemento(Jogador, ValorDireita, ListaComElemento),
    adicionar_lista_primeira_posicao(ListaComElemento, Monte, NovoMonte),
    write('novo monte: '),
    writeln(NovoMonte),
    remove_lista(Jogador, ListaComElemento, NovaMao),
    write('nova mao: '),
    writeln(NovaMao),
    writeln('--------------------------------------------------------------'),nl.

encontra_lista_com_elemento(ListaDeListas, Elemento, ListaComElemento) :-
    member(Sublista, ListaDeListas),   % Para cada Sublista em ListaDeListas
    member(Elemento, Sublista),         % Se o Elemento estiver em Sublista
    ListaComElemento = Sublista,!.        % Define ListaComElemento como Sublista

adicionar_lista_primeira_posicao(Lista, ListaDeListas, NovaListaDeListas) :-
    append([Lista], ListaDeListas, NovaListaDeListas).

% Predicato para separar a primeira lista do monte em duas variaveis
verificaMonte(Monte,ValorEsquerda,ValorDireita) :-
    Monte = [PrimeiraLista|_],
    PrimeiraLista = [Esquerda,Direita|_],
    ValorEsquerda = Esquerda,
    ValorDireita = Direita.

% Predicado para remover uma lista de outra lista
remove_lista(Lista, ListaRemover, ListaSemRemover) :-
    delete(Lista, ListaRemover, ListaSemRemover).

% Para testar as possibilidades de vitoria, modifique o predicato inicioJogo() por
% inicioJogo(Jogador1, Jogador2, Monte, Baralho).

% vence jogador1
% inicioJogo([[vermelho,2],[verde,5],[azul,5]],[[verde,2],[amarelo,5],[verde,5]],[[vermelho,9]],[[azul,6],[amarelo,5]]).

% vence jogador1 pelo baralho vazio e menos carta na mao
% inicioJogo([[vermelho,4],[verde,5],[azul,8],[amarelo,5]],[[verde,4],[azul,4]],[[vermelho,9]],[[azul,6],[amarelo,5]]).

% vence jogador2
% inicioJogo([[verde,5],[azul,7]],[[azul,5]],[[vermelho,5]],[[verde,6],[verde,8]]).

% empate entre os jogadores
% inicioJogo([[verde,5],[azul,7]],[[azul,5],[azul,5]],[[vermelho,5]],[]).

% vence jogador1 com baralho vazio
% inicioJogo([[verde,5]],[[azul,5],[azul,5]],[[vermelho,5]],[]).

% vence jogador2 com o baralho vazio
% inicioJogo([[verde,5],[azul,5]],[[azul,5]],[[vermelho,5]],[]).

