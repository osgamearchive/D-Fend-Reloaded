
-----------------------------------
DOSBox 0.73 em Português/Brasileiro
-----------------------------------

Traduzido por Lex Leite / ableite@msn.com

A Versão em português para a galera brazuka!!

1. Notas do autor sobre tradução
2. Alteração do idioma
3. Futuras versões
4. Agradecimentos
5. Dicas (Windows XP) (INICIANTES, LEIAM ISTO)
6. Método Fácil (Altamente recomendado para versão 0.73)

Qualquer dúvida na instalação da tradução contate-me.

-------------------------------------
1. Notas do autor sobre tradução
-------------------------------------
a. A versão 0.73 do DosBOX possui um bug. Quando o arquivo de configuração é
   criado com a tradução a estrutura do texto interno fica incorreta.
   Provavelmente isso não será corrigido nessa versão. Recomendo que use o já
   traduzido incluido nesse arquivo ZIP. (dosbox-0.73.conf)

b. A tradução do arquivo de idioma do DOSBox está completa. Já comecei o trabalho
   de traduzir o arquivo LeiaMe.TXT (README.TXT) do DOSBox.
   Porém uma nova versão foi feita, então preciso rever alguns textos.

c. A tradução foi feita com base no arquivo original em inglês e com o arquivo de
   tradução em espanhol o que ajudou para deixar a tradução ainda melhor.

d. Não pude testar certas telas do DOSBox. Telas como a inicial onde existe uma
   grande caixa azul, podem estar malfeitas por conta da numeração que pode ter
   ficado errada, porém creio que esteja tudo correto.


-----------------------------------------------------
2. Para alterar o idioma do DOSBox para Português:
-----------------------------------------------------
   Atenção: A pasta onde se encontra o arquivo de configuração do DosBOX foi
   alterada na versão 0.73 do DosBOX. Agora a pasta esta localizada em:
   "C:\Documents and Settings\Usuario\Configurações locais\Dados de aplicativos\DOSBox"
   no windows XP. No vista deverá estar numa pasta de caminho semelhante.
   Substitua "usuario" pelo seu nome do seu usuario no computador.
   Sempre que eu me referir a pasta de configuração do DosBOX, vá até a pasta citada acima.

   Para facilitar a instalação da tradução simplesmente copie os 2 arquivos
   "portuguese.lang" e "dosbox-0.73.conf" para a pasta de configuração
   do DosBOX. (Método fácil)

   Se essa pasta não existir, abra o DosBOX e logo em seguida feche-o. Ela deverá
   ter sido criada pelo próprio programa agora.
   

a. Copie o arquivo portuguese.lang incluído no arquivo compactado para a
   a pasta de configuração do DOSBox.

b. Abra o arquivo de configuração do DOSBox (Por Padrão, dosbox-0.73.conf),
   localizado na mesma pasta, com um editor de texto comum. Na seção [dosbox] há uma linha
   "language=". Adicione o nome do arquivo com a tradução.
   Se esta linha não for encontrada, simplesmente adicione-a.
   Ex: language=portuguese.lang

c. Para que o arquivo de configuração também fique em português, uma vez feito
   o passo anterior, escreva dentro do DOSBox no drive Z: "CONFIG -writeconf arquivo".
   Isto criará um novo arquivo de configuração com nome "arquivo", na pasta do DOSBox,
   com os textos em português. Delete o arquivo de configuração original e substitua
   pelo recém criado, mudando o nome deste para o do original (Delete o arquivo
   dosbox.conf original e mude o nome do arquivo recém criado para "dosbox.conf").
   OBS. NA VERSÃO 0.73 EXISTE UM BUG NESSE COMANDO. A IMPRESSÃO DO ARQUIVO FICA
   INCORRETA. UTILIZE O ARQUIVO CONTIDO NO ZIP.


d. Para que os caracteres fiquem corretos é necessário a alteração do codepage do
   Dosbox. No DOSBox digite "KEYB BR" (sem as aspas). O teclado agora deverá ser o
   ABNT2 e os caracteres deverão aparecer corretamente.
   Ou adicione "br" no arquivo de configurações do dosbox na seção [dos] em keyboard
   layout. keyboardlayout=br
   OBS. Há um BUG no KEYB, a tecla "?" não funciona.


-----------------------
3. Futuras versões
-----------------------

   Dei o melhor de mim nesta tradução e espero que não contenha erros. Porém posso
   ter deixado passar alguma letrinha ou acento. Se você detectar algum erro, poderá
   me contatar pelo meu e-mail (ableite@msn.com) para que eu possa consertá-lo e numa
   futura versão o DOSBox fique corretamente traduzido.


-----------------------
4. Agradecimentos
-----------------------

   Obrigado a equipe do DOSBox por ter feito esse programa maravilhoso, onde eu posso
   jogar jogos da época em que eu era um garotinho no Windows XP/Vista, que não da mais
   suporte ao verdadeiro MS-DOS.

   Obrigado a Gustavo Queipo de LLano Álvarez, pois usei seus arquivos de tradução em
   espanhol. Arquivos que me ajudaram a criar uma tradução ainda melhor para o português.

   Obrigado aos meus colegas que me incentivaram!

   E um Obrigado reservado, para caso eu tenha esquecido de colocar aqui alguém que
   me ajudou.

-------------------------------
5. Dicas (Windows XP/Vista)
-------------------------------

   Para quem está começando a usar o DosBOX agora e quiser começar a jogar antes de
   aprender a usá-lo completamente faça o seguinte:

   Abra o arquivo de configurações do DosBOX.
   Na ultima linha desse arquivo está seção de auto execução [autoexec] de comandos
   que serão sempre executados quando o DOSBox for iniciado.
   Logo abaixo da última linha copie e cole o texto abaixo:

----corte aqui----

mount c c:\
mount d d:\ -t cdrom
c:
dir/p

----corte aqui----

   Obviamente o "c c:\" é para o HD que estiver na unidade c: e o "d d:\" para onde
   estiver a unidade de cd-rom. No windows geralmente essas letras são padrão, logo,
   basta copiar e colar. Se não, altere as letras para as unidades corretas.


-----------------------------------------------
6. Método Fácil (Recomendado para versão 0.73)
-----------------------------------------------

   PODE NÃO FUNCIONAR EM ALGUNS COMPUTADORES!!!
   Copie os arquivos "dosbox-0.73.conf" e "portuguese.lang" para a pasta de
   configuração do DosBOX.
   Abra o executável.

   Se algum erro ocorrer/não funcionar coloque o arquivo "dosbox-0.73B.conf" na pasta de
   configuração do Dosbox, delete o arquivo "dosbox-0.73.conf" e renomeie o
   "dosbox-0.73B.conf" para "dosbox-0.73.conf".
   Abra o executável.



