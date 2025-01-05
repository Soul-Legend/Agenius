# Agenius

O projeto é implementado usando a abordagem datapath-controle.

• Para iniciar o jogo o usuário ativa a entrada de reset, SW (1), e passamos ao estado ST ART onde são activados os
comandos de reset (R1 e R2). Nesse estado os displays HEX5 e HEX4 mostrarão a letra L de level e o nível de jogo,
respectivamente, os displays HEX3 e HEX2 mostrarão a letra t de time e o tempo máximo de jogo, respectivamente,
e por último, os displays HEX1 e HEX0 mostrarão a letra r de round e o valor da rodada do jogo, respectivamente.
O nível de jogo, tempo máximo de jogo e rodada serão explicados a seguir. Do estado ST ART passamos diretamente
ao estado SET U P .

• Uma vez no estado SET U P o usuário deve escolher uma das quatro velocidades iniciais de jogo com os Switches 9
e 8, SW (9..8), uma das quatro sequencias de jogo possíveis com os Switches 7 e 6, SW (7..6), e o número máximo
de iterações por sequencia com os Switches 5 e 2, SW (5..2). As frequências iniciais de jogo serão 0, 5Hz, 1Hz, 2Hz
e 3Hz. O nível de jogo será mostrado no HEX4. Damos inicio ao jogo ativando a entrada enter SW (0) e passando
ao estado P lay_F P GA.

• Uma vez no estado P LAY _F P GA é ativada a sequencia seleccionada a qual será mostrada nos LEDR(3..0). Dita
sequencia possui 16 linhas de atribuição de 4-bits e um exemplo de sequencia decSeq00.vhd está disponível na
pasta de projeto no M oodle da disciplina. Corre a cargo do aluno fazer as outras três sequências à sua escolha. É
importante destacar que a sequencia pode ter apenas um ”1” lógico por linha e que a sequencia tem estar variando
continuamente. Na primeira rodada será apresentada uma linha da sequencia, na segunda rodada serão apresentadas
duas e assim sucessivamente. A cada rodada, a frequência da sequência apresentada será incrementada em 0, 2Hz.
Uma vez terminada a sequência, o jogo passa para o próximo estado, P LAY _U SER, quando esteja ativo um sinal
de status, chamado end_F P GA.

• Uma vez no estado P LAY _U SER o usuário deve indicar com os botões de pressão KEY (3..0) a sequencia mostrada
no estado anterior. A sequência replicada será apresentada nos LEDG(3 .. 0) na DE2, caso seja testado no emulador
on-line, devera ser usado os LEDR(17 ..14). Neste estado, o displays HEX2 mostrará uma contagem ascendente de
0 a 9 com frequência de 1Hz. Se o tempo acaba é ativado um sinal de status end_time e o jogo passa ao estado
RESU LT , se não terminou o tempo e o usuário introduz a sequencia que achar correta então se ativa um sinal de
status end_user, o jogo passa ao estado CHECK.

• No estado CHECK se avalia se o usuário errou na replicação da sequência. Se o usuário replicou a sequência
corretamente, um sinal de status match está ativo e o jogo passa ao estado N EXT _ROU N D. Se o usuário errou
passa ao estado RESU LT . Nesse estado habilitamos um comando para contar a rodada, que é mostrada no HEX0.
• No estado N EXT _ROU N D se avalia um sinal de status win que indica se o jogo chegou ao último valor da
sequência. Se chegou então win está ativo e o jogo passa ao estado RESU LT caso contrario passa ao estado
P LAY _F P GA. Neste estado serão resetadas as contagens das sequências das FPGA e o usuário.

• No estado RESU LT será mostrado a pontuação final em Hexadecimal nos displays HEX1 e HEX0. Para o nível
de jogo j, uma sequência i (selecionados com os SW (9..6)) e o resultado das rodadas, a pontuação final será
64 × j + 4 × rodadas + i. Corre a cargo do aluno implementar a dita operação com a menor lógica possível. Nesse
estado os displays HEX5, HEX4, HEX3, HEX2 mostrarão F P gA ou U SEr indicando quem ganhou o jogo e no
LEDR(4) o status win. Nesse estado o usuário deverá pressionar reset para passar a ST ART e reiniciar o jogo.

• Visando evitar problemas de temporização em função do aperto de um KEY por um ser humano durar muitos ciclos
de clock, o Button Press Synchronizer (ButtonSync) foi desenvolvido. O jogo pode ser
reiniciado em qualquer momento com o SW(1), reset.

![image](https://github.com/user-attachments/assets/cf49fee8-39bb-472a-9e08-56f751d37160)
![image](https://github.com/user-attachments/assets/4f4584c9-7245-497b-bd1e-04484e605133)
