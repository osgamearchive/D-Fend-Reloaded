DOSBox v0.72


=====
NOTA: 
=====

Nonostante speriamo che un giorno DOSBox faccia girare tutti i
programmi mai fatti per PC, ancora non siamo a quel punto. Attualmente,
DOSBox in esecuzione su un computer potente è più o meno l'equivalente
di un PC 486. DOSBox può essere configurato in modo da far girare
un certo numero di giochi DOS, dai classici in CGA/Tandy/PCjr fino
ai giochi dell'era di Quake.



=======
INDICE:
=======
1. Iniziare subito
2. FAQ
3. Uso
4. Programmi Interni
5. Tasti Speciali
6. Mapper
7. Layout della Tastiera
8. Funzione Multiplayer Seriale
9. Come giocare a giochi particolarmente esigenti
10. Risoluzione dei problemi
11. Il file di configurazione
12. Il file linguaggio
13. Costruire la tua versione di DOSBox
14. Ringraziamenti speciali
15. Contatti



===================
1. Iniziare subito:
===================

Digita INTRO in DOSBox per una rapida occhiata alle opzioni.
È importantissimo che impari velocemente concetti come montare drive,
DOSBox non crea automaticamente nessun drive (o sue parti) accessibili
dall'interno dell'emulazione.
Per maggiori informazioni vedi la FAQ "Ho una Z invece che una C al prompt"
e anche la descrizione del comando MOUNT (sezione 4).



=======
2. FAQ:
=======

Alcune domande poste frequentemente (FAQ):

D: Ho una Z invece che una C al prompt.
D: Come passo a schermo intero ?
D: Devo sempre digitare questi comandi? Nessuna automazione?
D: Il mio CD-ROM non funziona.
D: Il mouse non funziona.
D: Non c'è il suono.
D: Il suono è a singhiozzo, rallentato o comunque strano.
D: Non posso digitare \ o : in DOSBox.
D: L'input da tastiera soffre di rallentamenti.
D: Il cursore si muove sempre nella stessa direzione!
D: Il gioco/applicazione non riesce a trovare il suo CD-ROM.
D: Il gioco/applicazione gira troppo lentamente!
D: DOSBox può danneggiare il mio computer?
D: Vorrei cambiare la dimensione della memoria/velocità cpu/ems/IRQ soundblaster.
D: Attualmente, quali dispositivi sonori DOSBox emula?
D: DOSBox crasha all'avvio e sto eseguendo arts.
D: Ottimo README, ma ancora non capisco.




D: Ho una Z invece che una C al prompt.
R: Devi fare in modo che le tue directory diventino disponibili sottoforma di
   drive in DOSBox usando il comando "mount". Per esempio, sotto Windows, il
   comando "mount C D:\GAMES" creerà un drive C in DOSBox, che punta alla tua
   directory reale D:\GAMES. Sotto Linux, "mount c /home/nomeutente" creerà
   un drive C in DOSBox, che punta alla directory /home/nomeutente di Linux.
   Per spostarti nel drive appena montato digita "C:". Se tutto è andato bene,
   DOSBox mostrerà il prompt "C:\>".
   

D: Devo sempre digitare questi comandi? Nessuna automazione?
R: Nel file di configurazione di DOSBox c'è una sezione chiamata [autoexec].
   I comandi presenti in questa sezione vengono eseguiti ad ogni avvio di
   DOSBox, quindi puoi usarla per montare i drive.


D: Come passo a schermo intero ?
R: Premi alt-invio. In alternativa: Modifica il file di configurazione di
   DOSBox e cambia l'opzione fullscreen=false in fullscreen=true. Se la
   modalità a schermo intero non ti va bene, gioca con l'opzione fullresolution
   nel file di configurazione di DOSBox. Per tornare indietro dalla modalità
   schermo intero: Premi alt-invio di nuovo.


D: Il mio CD-ROM non funziona.
R: Per montare il tuo CD-ROM in DOSBox devi specificare qualche opzione addizionale
   all'atto del montaggio.
   Per abilitare il supporto CD-ROM (include MSCDEX):
     - mount d f:\ -t cdrom
   Per abilitare il supporto CD-ROM di basso livello (usa ioctl se possibile):
     - mount d f:\ -t cdrom -usecd 0
   Per abilitare il supporto SDL di basso livello:
     - mount d f:\ -t cdrom -usecd 0 -noioctl
   Per abilitare il supporto aspi di basso livello (win98 con l'aspi-layer installato):
     - mount d f:\ -t cdrom -usecd 0 -aspi
   
   Nei comandi: - d   lettera di drive che avrai nel DOSBox
                - f:\ percorso del CD-ROM nel tuo PC.
                - 0   Il numero del drive CD-ROM, ottenuto tramite mount -cd 
   Vedi anche la domanda: Il gioco/applicazione non riesce a trovare il suo CD-ROM.


D: Il mouse non funziona.
R: Solitamente, DOSBox capisce quando un gioco usa il controllo via mouse.
   Quando clicchi sullo schermo dovrebe essere catturato (cioè confinato alla
   finestra di DOSBox) e funzionare. Con certi giochi, la rilevazione del mouse
   da parte di DOSBox non funziona. In questo caso dovrai catturare il mouse
   manualmente premendo CTRL-F10.


D: Non c'è il suono.
R: Assicurati che il suono sia correttamente configurato nel gioco. Ciò può
   di solito essere fatto durante l'installazione o con un setup/setsound
   allegato al gioco. Prima controlla che sia possibile fare l'autorilevazione.
   Se non è disponibile prova a scegliere la soundblaster o soundblaster16
   con le impostazioni di default "address=220 irq=7 dma=1". Potresti anche
   dover impostare la musica midi all'indirizzo 330 come dispositivo.
   Questi parametri delle schede audio emulate possono essere cambiati nel
   file di configurazione di DOSBox.
   Se ancora non senti niente imposta il core su normal e usa valori più bassi
   per cycles (come cycles=2000). Assicurati inoltre che la tua scheda audio
   reale funzioni correttamente.


D: Il suono è a singhiozzo, rallentato o comunque strano.
R: Stai sfruttando troppa potenza CPU per mantenere DOSBox a quella velocità.
   Puoi abbassare i cicli, saltare dei fotogrammi, ridurre la frequenza di campionamento
   del dispositivo audio (vedi il file di configurazione di DOSBox) o del dispositivo
   mixer. Puoi anche aumentare il prebuffer nel file di configurazione.
   Se stai usando cycles=max o =auto, assicurati che non ci siano processi
   in sottofondo che interferiscano! (specialmente se accedono al disco rigido)


D: Non posso digitare \ o : in DOSBox.
R: E' un problema noto. Succede solo se il tuo layout di tastiera non è americano.
   Alcune possibili soluzioni:
     1. Cambia il layout tastiera del tuo sistema operativo.
     2. Usa / invece che \.
     3. Apri dosbox.conf e cambia usescancodes=false in usescancodes=true.
     4. Aggiungi i comandi che vuoi eseguire al "file di configurazione".
     5. Cambia il layout tastiera del DOS (vedi la Sezione 7 Layout Tastiera).
     6. Usa ALT-58 per : e ALT-92 per \.
     7. per \ prova i tasti vicino a "invio". Per ":" prova maiusc e i tasti
        tra "invio" e "l" (layout tastiera americano).
     8. Prova keyb.com dal FreeDOS (http://projects.freedos.net/keyb/).
        Cerca keyb2.0 pre4, poichè le versioni più vecchie o più nuove hanno
        un bug nelle procedure di caricamento.


D: L'input da tastiera soffre di rallentamenti.
R: Abbassa il livello di priorità nel file di configurazione di DOSBox
   come ad esempio "priority=normal,normal". Puoi anche provare
   a diminuire i cicli.


D: Il cursore si muove sempre nella stessa direzione!
R: Vedi se succede ancora quando disattivi l'emulazione joystick,
   imposta joysticktype=none nella sezione [joystick] del tuo file
   di configurazione di DOSBox. Puoi anche provare a scollegare ogni
   joystick. Se vuoi usare il joystick nei giochi, prova a impostare
   timed=false e assicurati di calibrare il joystick (sia nel tuo
   SO come anche nel gioco, o nel setup del gioco).


D: Il gioco/applicazione non riesce a trovare il suo CD-ROM.
R: Assicurati di montare il CD-ROM col parametro -t cdrom, ciò abiliterà
   l'interfaccia MSCDEX richiesta dai giochi DOS per interfacciarsi con i
   CD-ROM. Prova anche ad aggiungere la giusta etichetta (-label ETICHETTA).
   Per abilitare il supporto CD-ROM di basso livello, aggiungi il seguente
   parametro al mount: -usecd #, dove # è il numero del tuo drive CD-ROM
   riportato da mount -cd. Sotto Windows puoi specificare -ioctl o -aspi.
   Cerca la loro descrizione in questo documento per conoscerne il significato.


D: Il gioco/applicazione gira troppo lentamente!
R: Guarda nella sezione "Come avviare giochi pesanti" per maggiori
   informazioni.


D: DOSBox può danneggiare il mio computer?
R: Non più di qualsiasi altro programma che richieda molte risorse. L'incremento
   dei cicli non è un overclock della tua CPU reale. Impostare un valore troppo
   alto ha un effetto negativo sulle prestazioni del software che gira all'interno
   di DOSBox.


D: Vorrei cambiare la dimensione della memoria/velocità cpu/ems/IRQ soundblaster.
R: Puoi farlo! Basta che crei un file di configurazione: config -writeconf nomefile.
   Apri il tuo editor preferito e guarda le impostazioni. Per avviare DOSBox con
   i tuoi nuovi settaggi: dosbox -conf nomefile


D: Attualmente, quali dispositivi sonori DOSBox emula?
R: DOSBox emula diversi dispositivi sonori:
   - Altoparlante interno PC
     Questa emulazione include sia il generatore di note che diverse forme
     di output audio digitale attraverso l'altoparlante interno.
   - Creative CMS/Gameblaster
     E' la prima scheda rilasciata da Creative Labs(R).  La configurazione
     di default la piazza nella porta 0x220.  Andrebbe notato che abilitarla
     assieme all'emulazione Adlib potrebbe portare a conflitti.
   - Tandy 3 voice
     L'emulazione di questo hardware audio è completa ad eccezione del
     noise channel. Il noise channel non è ben documentato e di conseguenza
     vi si può andare solo per immaginazione, cercando l'accuratezza sonora.
   - Tandy DAC
     L'emulazione della Tandy DAC usa quella della soundblaster, quindi
     assicurati che l'emulazione soundblaster non sia disattivata nel file
     di configurazione di DOSBox. La Tandy DAC è emulata soltanto a livello
     di BIOS.
   - Adlib
     Presa in prestito dal MAME, questa emulazione è praticamente perfetta e
     include la possibilità dell'Adlib di riprodurre i suoni digitalizzati.
   - SoundBlaster 16/ SoundBlaster Pro I & II /SoundBlaster I & II
     Per default DOSBox fornisce suono a 16-bit Soundblaster 16.
     Puoi selezionare una versione diversa di SoundBlaster nel file di
     configurazione di DOSBox (Vedi Comandi Interni: CONFIG).
   - Disney Soundsource
     Usando la porta stampante, questo dispositivo sonoro produce soltanto
     audio digitale.
   - Gravis Ultrasound
     L'emulazione di questo hardware è quasi completa, anche se le funzioni
     MIDI sono state lasciate fuori, dato che è già stato emulato MPU-401
     in altro codice.
   - MPU-401
     Una interfaccia MIDI è anch'essa emulata.  Questo metodo di output
     sonoro funzionerà soltanto se usato con un dispositivo General Midi o
     MT-32.


D: DOSBox crasha all'avvio e sto eseguendo arts.
R: Non è un problema di DOSBox, comunque la soluzione è di impostare
   la variabile d'ambiente SDL_AUDIODRIVER su alsa o oss.


D: Ottimo README, ma ancora non capisco.
R: Potrebbe aiutarti uno sguardo a "The Newbie's pictorial guide
   to DOSBox" che si trova qui
   http://vogons.zetafleet.com/viewforum.php?f=39
   Prova anche il wiki di DOSBox:
   http://dosbox.sourceforge.net/wiki/
   (documenti in inglese)


Per altre domande leggi il resto di questo README e/o controlla il
sito/forum:
http://dosbox.sourceforge.net



=======
3. Uso:
=======

Una panoramica sui parametri di linea di comando da passare a DOSBox.
Gli utenti di Windows devono aprire cmd.exe o command.com o modificare
il collegamento a DOSBox.exe per poterli usare.
Le opzioni sono valide per tutti i sistemi operativi tranne quando
espressamente specificato nelle descrizioni:

dosbox [nome] [-exit] [-c comando] [-fullscreen] [-conf nomefile] 
       [-lang filelinguaggio] [-machine tipomacchina] [-noconsole]
       [-startmapper] [-noautoexec] [-scaler scaler | -forcescaler scaler]
       
dosbox -version

  nome
        Se "nome" è una directory verrà montata come drive C:.
        Se "nome" è un eseguibile, verrà montata la directory in cui "nome" si trova
        come drive C: e verrà eseguito "nome".
    
  -exit
        DOSBox si chiuderà quando l'applicazione DOS "nome" sarà terminata.

  -c comando
        Esegue il comando specificato prima di avviare "nome". Possono essere
        specificati comandi multipli. Ogni comando dovrebbe partire con "-c".
        Un comando può essere: un Programma Interno, un comando DOS o un
        eseguibile su un drive montato.

  -fullscreen
        Avvia DOSBox in modalità a schermo intero.

  -conf nomefile
        Avvia DOSBox con le impostazioni speficicate in "nomefile".
        Possono essere specificate diverse opzioni -conf.
        Vedi il Capitolo 10 per maggiori dettagli.

  -lang filelinguaggio
        Avvia DOSBox usando la lingua specificata in "filelinguaggio".

  -machine tipomacchina
        Imposta DOSBox per emulare un tipo specifico di macchina. Scelte valide
        sono: hercules, cga, pcjr, tandy, vga (default). Il tipo di macchina
        influenza sia la scheda video che le schede audio disponibili.

  -noconsole (Solo Windows)
        Avvia DOSBox senza mostrare la finestra console. L'output sarà
        ridirezionato verso stdout.txt e stderr.txt
	
  -startmapper
        Entra nel keymapper direttamente all'avvio. Utile per gli utenti
        con problemi di tastiera.

  -noautoexec
        Salta la sezione [autoexec] del file di configurazione caricato.

  -scaler scaler
        Usa lo scaler specificato da "scaler". Vedi il file di configurazione DOSBox
        per conoscere che scaler sono disponibili.

  -forcescaler scaler
        Simile al parametro -scaler, ma prova a forzare l'uso dello scaler
        specificato anche qualora non fosse adatto.

  -version
        mostra le informazioni di versione ed esce. Utile per i frontend.

Nota: Se un nome/comando/fileconfigurazione/filelinguaggio contiene uno
      spazio, metti l'intero nome/comando/fileconfigurazione/filelinguaggio
      tra doppi apici ("comando o nome di file"). Se hai bisogno, ecco come
      usare doppi apici all'interno di altri doppi apici (succede spesso
      con -c e mount).
      Gli utenti Windows e OS/2 possono usare apici singoli all'interno di
      doppi apici. Gli altri dovrebbero essere in grado di usare doppi apici
      preceduti dal carattere di escape, all'interno di altri doppi apici.
      win -c "mount c 'c:\programmi\'"
      linux -c "mount c \"/tmp/nome con spazio\""

Per esempio:

dosbox c:\atlantis\atlantis.exe -c "MOUNT D C:\SAVES"
  Questo monta c:\atlantis come c:\ ed esegue atlantis.exe.
  Prima di fare questo, monta C:\SAVES come drive D.

Sotto Windows, puoi anche trascinare directory/file sull'eseguibile di DOSBox.



=====================
4. Programmi Interni:
=====================

DOSBox supporta la maggior parte dei comandi DOS trovati in command.com.
Per avere una lista dei comandi interni digita "HELP" al prompt.

Inoltre sono disponibili i seguenti comandi:

MOUNT "Lettera Drive Emulato" "Drive o directory reale"
      [-t tipo] [-aspi] [-ioctl] [-noioctl] [-usecd numero] [-size dimensionedrive] 
      [-label etichettadrive] [-freesize dimensione_in_mb]
      [-freesize dimensione_in_kb (per i floppy)]
MOUNT -cd
MOUNT -u "Lettera Drive Emulato"

  Programma per montare le directory locali come drive dentro DOSBox.

  "Lettera Drive Emulato"
        La lettera di drive dentro DOSBox (es. C).

  "Lettera Drive Reale (solitamente per i CD-ROM in Windows) o Directory"
        La directory locale cui vuoi accedere da dentro DOSBox.

  -t tipo
        Tipo di directory montata. Valori supportati: dir (default),
        floppy, cdrom.

  -size dimensionedrive
        Imposta la dimensione del drive, dove dimensionedrive è nella forma
        "bps,spc,tcl,fcl":
           bps: byte per settore, di default 512 per i drive regolari e
                2048 per i drive CD-ROM
           spc: settori per cluster, di solito tra 1 e 127
           tcl: cluster totali, tra 1 e 65534
           fcl: cluster totali disponibili, tra 1 e tcl

  -freesize dimensione_in_mb | dimensione_in_kb
        Imposta la quantità di spazio libero disponibile sul drive in
        megabyte (drive regolari) o kilobyte (drive floppy).
        Si tratta di una versione semplificata di -size.

  -label etichettadrive
        Imposta il nome del drive a "etichettadrive". Richiesto da
        alcuni sistemi se l'etichetta del cd non è letta correttamente.
        Utile quando un programma non riesce a trovare il proprio CD-ROM.
        Se non specifichi un'etichetta e non è selezionato nessun supporto
        di basso livello (ciò avviene quando ometti -usecd # e/o -aspi o
        quando specifichi -noioctl):
          Per win32: l'etichetta è estratta dal "Drive Reale".
          Per Linux: l'etichetta è impostata su NO_LABEL.

        Se specifichi un'etichetta, questa verrà mantenuta fin quando il drive
        rimarrà montato. Non verrà modificata !!

  -aspi
        Forza l'uso del layer aspi. Valido soltanto se si sta montando un
        CD-ROM sotto sistemi Windows con un layer ASPI installato.

  -ioctl
        Forza l'uso dei comandi ioctl. Valido soltanto se si sta montando
        un CD-ROM sotto sistemi Windows che li supportino (Win2000/XP/NT).

  -noioctl   
        Forza l'uso di un layer CD-ROM SDL. Valido su tutti i sistemi.

  -usecd numero
        Forza l'uso del supporto cdrom SDL per il drive numero "numero".
        Il numero può essere trovato con -cd. Valido su tutti i sistemi.

  -cd
        Visualizza tutti i drive CD-ROM rilevati e i rispettivi numeri. Da
        usare con -usecd.

  -u
        Rimuove il mount. Non funziona per Z:\.

  Nota: E' possibile montare una directory locale come drive CD-ROM.
        In questo caso però mancherà il supporto hardware.

  In pratica MOUNT ti permette di connettere l'hardware reale al PC emulato da
  DOSBox. Quindi MOUNT C C:\GIOCHI dice a DOSBox di usare la tua directory
  C:\GIOCHI come drive C: in DOSBox. Ti permette anche di cambiare la lettera
  identificativa del drive per venire incontro a quei programmi che richiedono
  lettere di drive specifiche.
  
  Per esempio: Touche: Adventures of The Fifth Musketeer deve essere avviato
  sul tuo drive C:. Usando DOSBox e il suo comando mount, puoi ingannare il
  gioco e fargli credere di trovarsi nel drive C, mentre puoi continuare a
  mettere il gioco dove preferisci. Per esempio, se il gioco si trova in
  D:\GIOCHI\TOUCHE, il comando MOUNT C D:\GIOCHI\TOUCHE ti permetterà di
  avviare Touche dal drive D.

  Montare l'intero drive C con MOUNT C C:\ è ALTAMENTE sconsigliato! Stesso
  discorso vale per il montare la directory radice di qualsiasi altro drive,
  eccetto che per i CD-ROM (a causa della loro natura a sola lettura).
  In caso contrario, se fai errori all'interno del DOSBox potresti perdere
  tutti i tuoi file.
  E' consigliato mettere tutte le tue applicazioni/giochi in una sottodirectory
  e montare quella.

  Esempi di MOUNT:
  1. Per montare c:\DirX come floppy : 
       mount a c:\DirX -t floppy
  2. Per montare il cdrom di sistema E come cdrom sul drive D in DOSBox:
       mount d e:\ -t cdrom
  3. Per montare il drive CD-ROM di sistema nel punto di mount /media/cdrom come
     drive CD-ROM D in dosbox:
       mount d /media/cdrom -t cdrom -usecd 0
  4. Per montare un drive con ~870 mb di spazio disponibile (versione semplice):
       mount c d:\ -freesize 870
  5. Per montare un drive con ~870 mb di spazio disponibile (solo esperti, pieno controllo):
       mount c d:\ -size 512,127,16513,13500
  6. Per montare /home/user/dirY come drive C in DOSBox:
       mount c /home/user/dirY
  7. Per montare la directory da cui DOSBox è stato eseguito come D in DOSBox:
       mount d .


MEM
  Programma per visualizzare la quantità di memoria disponibile.


CONFIG -writeconf filelocale
CONFIG -writelang filelocale
CONFIG -set "sezione proprietà=valore"
CONFIG -get "sezione proprietà"

  CONFIG può essere usato per cambiare o visualizzare varie impostazioni di
  DOSBox durante la sua esecuzione. Può salvare le impostazioni correnti o
  le stringhe di linguaggio su disco. Informazioni a riguardo di tutte le
  possibili sezioni e proprietà possono essere trovate nella sezione 11
  (Il File di Configurazione).

  -writeconf filelocale
       Scrive la configurazione attuale su un file. "filelocale" è
       localizzato sul drive locale, non su un drive montato in DOSBox.
       Il file di configurazione controlla varie impostazioni di DOSBox:
       la quantità di memoria emulata, le schede audio emulate e tante
       altre cose. Permette anche l'accesso ad AUTOEXEC.BAT.
       Vedi la Sezione 11 (Il File di Configurazione) per ulteriori
       informazioni.

  -writelang filelocale
       Scrive le impostazioni di linguaggio attuali su un file. "filelocale"
       è localizzato sul drive locale, non su un drive montato in DOSBox.
       Il file di linguaggio controlla tutto l'output dei comandi interni
       visibile nel dosbox e il dos interno.

  -set "sezione proprietà=valore"
       CONFIG proverà a impostare la proprietà al nuovo valore. Attualmente
       CONFIG non è ancora in grado di riportare se il comando ha avuto
       successo o meno.

  -get "sezione proprietà"
       Il valore attuale della proprietà è riportato e memorizzato nella
       variabile di ambiente %CONFIG%. Questo è utile per memorizzarne il
       valore all'interno di file batch.

  Sia "-set" che "-get" funzionano dai file batch e possono essere usati per
  impostare i tuoi settaggi preferiti per ogni gioco. 
  
  Esempi:
  1. Per creare un file di configurazione nella tua directory corrente:
      config -writeconf dosbox.conf
  2. Per impostare i cicli cpu a 10000:
      config -set "cpu cycles=10000"
  3. Per disattivare l'emulazione ems:
      config -set "dos ems=off"
  4. Per controllare che cpu core si sta utilizzando:
      config -get "cpu core"


LOADFIX [-size] [programma] [parametri-programma]
LOADFIX -f
  Programma per ridurre la quantità di memoria disponibile. Utile per i vecchi
  programmi che non si aspettano di avere molta memoria disponibile.

  -size	        
        numero di kilobyte da "mangiare", default = 64 kb
  
  -f
        libera tutta la memoria precedentemente allocata
  
Esempi:
  1. Per avviare mm2.exe e allocare 64kb di memoria
     (mm2 avrà 64 kb in meno disponibili) :
     loadfix mm2
  2. Per avviare mm2.exe e allocare 32kb di memoria :
     loadfix -32 mm2
  3. Per liberare la memoria precedentemente allocata :
     loadfix -f


RESCAN
  Fa sì che DOSBox rilegga la struttura delle directory. Utile se hai fatto
  qualche cambiamento sui drive montati da fuori DOSBox. (CTRL - F4 fa la stessa
  cosa!)
  

MIXER
  Fa sì che DOSBox visualizzi i correnti settaggi di volume.
  Ecco come cambiarli:
  
  mixer canale sinistra:destra [/NOSHOW] [/LISTMIDI]
  
  canale
      Può essere uno dei seguenti: MASTER, DISNEY, SPKR, GUS, SB, FM.
  
  sinistra:destra
      I livelli di volume in percentuale. Se preceduti da una D, sono
      espressi in decibel (esempio mixer gus d-10).
  
  /NOSHOW
      Evita che DOSBox mostri i risultati se imposti uno dei
      livelli di volume.

  /LISTMIDI
      Lista i dispositivi midi disponibili sul tuo PC (Windows). Per
      selezionare un dispositivo diverso dal midi-mapper standard di
      Windows, aggiungi una riga 'config=id' alla sezione [midi] del file
      di configurazione, dove 'id' è il numero del dispositivo ottenuto
      tramite LISTMIDI.


IMGMOUNT
  Una utilità per montare immagini disco e immagini CD-ROM in DOSBox.
  
  IMGMOUNT DRIVE [fileimmagine] -t [tipo_immagine] -fs [formato_immagine] 
            -size [dimensionesettoreinbyte, settoripertestina, testine, cilindri]

  fileimmagine
      Locazione dei file immagine da montare in DOSBox. La locazione può
      essere su un drive montato dentro DOSBox, o sul tuo disco reale.
      E' anche possibile montare immagini CD-ROM (ISO o CUE/BIN), se ti
      serve cambiare le immagini "in corsa" specificale tutte in successione.
      I CD-ROM, potranno essere scambiati con CTRL-F4 in qualsiasi momento.
   
  -t 
      I seguenti sono tipi di immagine validi:
        floppy: Specifica una immagine floppy.  DOSBox rileverà automaticamente la
                geometria del disco ( 360K, 1.2MB, 720K, 1.44MB, ecc).
        iso:    Specifica un'immagine iso CD-ROM.  La geometria è settata
                automaticamente per la dimensione. Può essere in formato iso o cue/bin.
        hdd:    Specifica un'immagine disco rigido. Va impostata la corretta geometria
                del drive perchè essa funzioni.

  -fs 
      I seguenti sono formati di file system validi:
        iso:  Specifica il formato CD-ROM ISO 9660.
        fat:  Specifica che l'immagine usa il file system FAT. DOSBox proverà a
              montare questa immagine come un drive in DOSBox e a rendere i file
              disponibili da dentro la shell.
        none: DOSBox non proverà a leggere il file system del disco. Questo è
              utile se ti serve formattarlo o se vuoi avviare il disco usando
              il comando BOOT.  Quando usi il filesystem "none", devi specificare
              il numero del drive (2 o 3, dove 2 = master, 3 = slave) piuttosto
              che una lettera di drive.
              Per esempio, per montare una immagine da 70MB come drive slave,
              dovresti digitare:
                "imgmount 3 d:\test.img -size 512,63,16,142 -fs none" 
                (senza doppi apici)  Confrontalo con un mount per leggere il drive
                in DOSBox, che sarebbe qualcosa del genere:
                "imgmount e: d:\test.img -size 512,63,16,142"

  -size
     Le specifiche in Cilindri, Testine e Settori del drive.
     Richiesto per montare immagini disco rigido.
     
  Esempio su come montare immagini CD-ROM:
    1a. mount c /tmp
    1b. imgmount d c:\mia_iso.iso -t iso
  o (funziona ugualmente):
    2. imgmount d /tmp/mia_iso.iso -t iso


BOOT
  Boot avvia immagini floppy o immagini disco rigido indipendentemente dal
  sistema operativo emulato da DOSBox. Questo ti permetterà di avviare
  i dischetti di avvio o altri sistemi operativi dentro DOSBox.
  Se il sistema emulato è PCjr (machine=pcjr) il comando boot può essere
  usato per caricare cartucce PCjr (.jrc).

  BOOT [diskimg1.img diskimg2.img .. diskimgN.img] [-l letteradrive]
  BOOT [cart.jrc]  (solo PCjr)

  diskimgN.img
     Questo può essere qualsiasi numero di immagini floppy disk che si
     vuole montare dopo che DOSBox abbia avviato la lettera di drive
     specificata.
     Per cambiare tra le varie immagini, premi CTRL-F4 per passare al
     successivo disco nella lista. La lista ricomincerà da capo quando
     raggiunta la fine.

  [-l letteradrive]
     Questo parametro ti permette di specificare il drive da cui effettuare
     il boot. Per default è il drive A, il floppy.  Puoi anche avviare
     una immagine disco rigido montata come master specificando "-l C"
     senza i doppi apici, o come slave specificando "-l D"
     
   cart.jrc (solo PCjr)
     Quando l'emulazione di PCjr è attivata, le cartucce possono essere
     caricate col comando BOOT. Il supporto, tuttavia, è ancora limitato.


IPX

  Devi abilitare il networking IPX nel file di configurazione di DOSBox.

  Tutto il networking IPX è gestito attraverso il programma interno DOSBox
  IPXNET. Per aiuto riguardo il networking IPX da dentro DOSBox, digita
  "IPXNET HELP" (senza doppi apici) e il programma mostrerà i comandi
  e la documentazione.

  Al fine di impostare una rete vera e propria, un sistema deve essere il
  server. Per impostarlo, digita "IPXNET STARTSERVER" (senza doppi apici)
  all'interno di una sessione DOSBox. La sessione server DOSBox si aggiungerà
  automaticamente alla rete IPX virtuale. Per ogni computer aggiuntivo che
  dovrà far parte della rete IPX virtuale, dovrai digitare
  "IPXNET CONNECT <nome host o indirizzo IP del computer>".
  Per esempio, se il tuo server è bob.dosbox.com, dovrai digitare
  
  Per giocare a giochi che necessitano di Netbios, serve un file chiamato
  NETBIOS.EXE fornito da Novell. Stabilisci la connessione IPX come spiegato
  sopra, quindi avvia "netbios.exe".

  Segue una lista di comandi IPXNET come riferimento:

  IPXNET CONNECT 

     IPXNET CONNECT apre una connessione a un tunneling server IPX in
     esecuzione su un'altra sessione DOSBox. Il parametro "indirizzo"
     specifica l'indirizzo IP o il nome host del computer server. Puoi
     anche specificare la porta UDP da usare. Per default IPXNET usa la
     porta 213 - assegnata da IANA per il tunneling IPX - per le connessioni.

     La sintassi di IPXNET CONNECT è: 
     IPXNET CONNECT indirizzo <porta> 

  IPXNET DISCONNECT 

     IPXNET DISCONNECT chiude la connessione col tunneling server IPX.

     La sintassi di IPXNET DISCONNECT è:
     IPXNET DISCONNECT 

  IPXNET STARTSERVER 

     IPXNET STARTSERVER avvia un tunneling server IPX in questa sessione DOSBox.
     Per default, il server accetterà le connessioni sulla porta UDP 213,
     anche se questo può essere cambiato. Quando il server è avviato, DOSBox
     avvierà automaticamente una connessione client al server stesso.

     La sintassi di IPXNET STARTSERVER è:
     IPXNET STARTSERVER <porta>

     Se il server è dietro ad un router, la porta UDP <porta> deve essere
     inoltrata a quel computer.

     Sui sistemi basati su Linux/Unix i numeri di porta minori di 1023 possono
     essere usati soltanto con i privilegi di amministratori. Su questi sistemi
     usare porte maggiori di 1023.

  IPXNET STOPSERVER

     IPXNET STOPSERVER ferma il tunneling server IPX in esecuzione in questa
     sessione DOSBox. Bisogna però assicurarsi che tutte le altre connessioni
     siano anch'esse terminate, dato che fermare il server può causare blocchi
     sulle altre macchine che ancora lo stanno utilizzando.

     La sintassi di IPXNET STOPSERVER è: 
     IPXNET STOPSERVER

  IPXNET PING

     IPXNET PING manda in broadcast una richiesta di ping attraverso il
     network IPX. In risposta, tutti gli altri computer connessi risponderanno
     al ping e sarà riportato il tempo necessario a ricevere ed inviare il
     messaggio di ping.

     La sintassi di IPXNET PING è: 
     IPXNET PING

  IPXNET STATUS

     IPXNET STATUS visualizza lo stato del network IPX sulla sessione corrente
     di DOSBox. Per una lista di tutti i computer connessi alla rete usa il
     comando IPXNET PING.

     La sintassi di IPXNET STATUS è: 
     IPXNET STATUS 


KEYB [codicelinguaggio [codepage [filecodepage]]]
  Cambia il layout della tastiera. Per informazioni dettagliate riguardo
  i layout della tastiera, guarda la Sezione 7.

  [codicelinguaggio] è una stringa che consiste di due caratteri (o in casi
     speciali anche di più), ad esempio GK (Grecia) o IT (Italia). Specifica
     il layout di tastiera da utilizzare.

  [codepage] è il numero del codepage da utilizzare. Il layout tastiera deve
     fornire supporto per il codepage specificato, altrimenti il caricamento
     del layout non andrà a buon fine.
     Se non viene specificato nessun codepage, verrà caricato un codepage
     opportuno per il layout che è stato scelto.

  [filecodepage] può essere usato per caricare codepage che non sono ancora inclusi
     dentro DOSBox. E' necessario soltanto quando DOSBox non trova il codepage.


  Esempi:
  1) Per caricare il layout tastiera tedesco (che usa automaticamente il codepage 858):
       keyb gr
  2) Per caricare il layout russo con codepage 866:
       keyb ru 866
     Per potere usare i caratteri russi premi ALT+MAIUSC-DI-DESTRA.
  3) Per caricare il layout francese con codepage 850 (dove il codepage
     è definito in EGACPI.DAT):
       keyb fr 850 EGACPI.DAT
  4) Per caricare il codepage 858 (senza un layout di tastiera):
       keyb none 858
     Questo può essere usato per cambiare il codepage per l'utility keyb2 del freedos.



Per ulteriori informazioni usa il parametro /? dopo i vari comandi.



==================
5. Tasti Speciali:
==================

ALT-ENTER     Passa alla visualizzazione a schermo intero (e viceversa).
ALT-PAUSE     Pausa l'emulazione.
CTRL-F1       Avvia il keymapper.
CTRL-F4       Aggiorna la cache directory per tutti i drive! Cambia l'immagine disco  montata.
CTRL-ALT-F5   Avvia/Ferma la registrazione dell'output video su un filmato.
CTRL-F5       Salva uno screenshot. (png)
CTRL-F6       Avvia/Ferma la registrazione dell'output audio su un file wave.
CTRL-ALT-F7   Avvia/Ferma la registrazione dei comandi OPL.
CTRL-ALT-F8   Avvia/Ferma la registrazione dei comandi MIDI raw.
CTRL-F7       Diminuisce il frameskip.
CTRL-F8       Aumenta il frameskip.
CTRL-F9       Chiude istantaneamente DOSBox.
CTRL-F10      Cattura/Rilascia l'uso del mouse.
CTRL-F11      Rallenta l'emulazione (diminuisce i cicli DOSBox).
CTRL-F12      Accelera l'emulazione (aumenta i cicli DOSBox).
ALT-F12       Sblocca la velocità (bottone turbo).

Questi sono i tasti di default. Possono essere cambiati col keymapper.

I file salvati/registrati possono essere trovati in directory_corrente/capture
(può essere modificata nel file di configurazione).
La directory deve esistere prima di avviare DOSBox, altrimenti non verrà
salvato/registrato niente !


NOTA: Quando aumenti i cicli di DOSBox oltre le capacità che il tuo computer
può gestire, avrai l'effetto opposto, cioè quello di rallentare l'emulazione.
Questo valore massimo consentito varia da computer a computer.



==========
6. Mapper:
==========

Quando avvii il mapper del DOSBox (con CTRL-F1 o col parametro -startmapper
quando avvii DOSBox) ti viene presentata una tastiera virtuale e un joystick
virtuale.

Questi dispositivi virtuali corrispondono ai tasti che DOSBox riporterà
alle applicazioni DOS. Se clicchi su un tasto col tuo mouse, potrai vedere
nell'angolo in basso a sinistra quale evento vi è associato (EVENT) e a
quali eventi è attualmente collegato.

Event: EVENT
BIND: BIND
                        Add   Del
mod1  hold                    Next
mod2
mod3


EVENT
    Il tasto o bottone/asse del joystick che DOSBox riporterà alle applicazioni DOS.
BIND
    Il tasto sulla tua tastiera reale o il bottone/asse/stick sul tuo joystick
    reale (come riportato da SDL) che è connesso all'EVENT.
mod1,2,3 
    Modfiers. Questi sono tasti che devono essere premuti durante la pressione del
    tasto BIND. mod1 = CTRL e mod2 = ALT. Vengono in genere usati soltanto quando
    vuoi cambiare i tasti speciali del DOSBox.
Add 
    Aggiunge un nuovo BIND per questo EVENT. In pratica aggiunge un tasto dalla
    tua tastiera o un evento dal joystick (pressione di un tasto, movimento di
    un asse) che produrrà un EVENT in DOSBox.
Del 
    Elimina il BIND a questo EVENT. Se un EVENT non ha BIND, allora non è
    possibile far partire questo evento in DOSBox (cioè non vi è modo di usare
    quel tasto o quel bottone del joystick).
Next
    Scorre la lista di collegamenti che si riferiscono a questo EVENT.


Esempio:
Q1. Vuoi che la X della tua tastiera produca una Z nel DOSBox.
    A. Clicca sulla Z del mapper. Clicca su "Add".
       Ora premi il tasto X sulla tua tastiera.

Q2. Se clicchi su "Next" un paio di volte, noterai che anche la Z sulla tua
    tastiera produce una Z in DOSBox.
    A. Quindi scegli la Z di nuovo, e clicca su "Next" fin quando non avrai la
       Z sulla tastiera. Ora clicca "Del".

Q3. Provando in DOSBox, noti che la pressione di X fa apparire ZX.
     A. La X sulla tua tastiera è ancora mappata alla X! Clicca sulla X della
        tastiera del mapper e scorri con "Next" fin quando non trovi il tasto X.
        A questo punto clicca su "Del".


Esempi riguardanti il rimappare il joystick:
  Hai un joystick collegato, funziona bene sotto DOSBox e vuoi giocare
  ad un gioco che funziona solo con la tastiera, col tuo joystick (assumeremo
  che il gioco è controllato attraverso le frecce direzionali sulla
  tastiera):
    1) Avvia il mapper, quindi clicca su una delle frecce al centro
       della parte sinistra dello schermo (proprio sopra i bottoni mod1
       e mod2). EVENT dovrebbe essere key_left. Orra clicca su Add e
       muovi il joystick nella relativa direzione, questo dovrebbe aggiungere
       un evento al BIND.
    2) Ripeti il punto precedente per le altre tre direzioni. E' anche
       possibile rimappare anche i bottoni del joystick (fuoco/salto).
    3) Clicca su Save, quindi su Exit e prova con qualche gioco.

  Vuoi invertire l'asse y del joystick perchè un gioco di simulazione aerea
  usa il movimento sopra/sotto in un modo che non ti va, e non è configurabile
  nel gioco stesso:
    1) Avvia il mapper e clicca su Y- nello spazio del joystick in alto (questo
       si riferisce al primo joystick se ne hai due attaccati) o nello spazio in
       basso (secondo joystick o, se ne hai solo uno attaccato, l'altra croce
       di assi).
       EVENT dovrebbe essere jaxis_0_1- (o jaxis_1_1-).
    2) Clicca su Del per eliminare i collegamenti correnti, quindi clicca Add e muovi
       il tuo joystick in basso. Dovrebbe essere creato un nuovo collegamento.
    3) Ripeti per Y+, salva il layout e prova qualche gioco.



Se cambi le associazioni di default, puoi salvare i tuoi cambiamenti cliccando
su "Save". DOSBox salverà le nuove associazioni su una locazione specificata
nel file di configurazione (mapperfile=mapper.txt). All'avvio, DOSBox caricherà
il suddetto file, se è presente nel file di configurazione.



=========================
7. Layout della Tastiera:
=========================

Per passare ad un diverso layout di tastiera, puoi usare sia la voce
"keyboardlayout" nella sezione [dos] di dosbox.conf, oppure il comando
keyb.com interno di DOSBox. Entrambi accettano codici linguaggio conformi
al DOS (vedere in basso), ma solo usando keyb.com è possibile specificare
dei codepage personalizzati.

Cambiare layout
  DOSBox supporta un certo numero di layout di tastiera e di codepage per
  default, in questo caso è necessario speficicare solo l'identificativo
  del layout (come keyboardlayout=it nel file di configurazione di DOSBox,
  o l'uso di "keyb it" al prompt dei comandi di DOSBox).
  
  Certi layout di tastiera (ad esempio il layout GK codepage 869 e il layout
  RU codepage 808) hanno il supporto per i layout doppi che possono essere
  attivati premento ALT-DI-SINISTRA+SHIFT-DI-DESTRA e disattivati premendo
  ALT-DI-SINISTRA+SHIFT-DI-SINISTRA

File esterni supportati
  I file .kl del freedos sono supportati (freedos keyb2 keyboard layoutfiles)
  come anche le librerie del freedos keyboard.sys/keybrd2.sys/keybrd3.sys che
  consistono in tutti i file .kl disponibili.
  Vedi http://projects.freedos.net/keyb/ per layout di tastiera precompilati
  nel caso che quelli integrati in DOSBox non dovessero funzionare, o nel caso
  che vengano rilasciati layout nuovi/più aggiornati.

  Possono essere usati sia i file .CPI (file codepage compatibili con MSDOS)
  che .CPX (file codepage freedos compressi con UPX). Alcuni codepage sono
  inclusi in DOSBox in modo che nella maggior parte dei casi non sia necessario
  andare a cercare file codepage esterni. Se ti serve un file codepage diverso
  (o presonalizzato), copialo nella directory del file di configurazione di
  DOSBox in modo che sia accessibile da DOSBox.

  Layout aggiuntivi possono essere aggiunti copiando il corrispondente file
  .kl dentro la directory di dosbox.conf e usando la prima parte del nome del
  file come codice linguaggio.
  Esempio: Per il file UZ.KL (layout tastiera per l'Uzbekistan) specifica
           "keyboardlayout=uz" in dosbox.conf.
  L'integrazione dei pacchetti di layout tastiera (come keybrd2.sys) funziona
  in modo simile.  


Nota che il layout di tastiera permette di immettere caratteri stranieri,
ma NON è possibile usarli nei nomi dei file. Cerca di evitarli sia dentro
DOSBox che nel tuo sistema operativo, in quei file/directory che saranno
poi accessibili da DOSBox.



================================
8. Funzione Multiplayer Seriale:
================================
 
DOSBox può emulare un cavo nullmodem seriale attraverso una rete e
internet. Può essere configurato attraverso la sezione [serialports]
nel file di configurazione di DOSBox.

Per creare una connessione nullmodem, uno dei lati deve agire da server e
uno da client.

Il server deve essere impostato nel file di configurazione di DOSBox così:
   serial1=nullmodem

Il client:
   serial1=nullmodem server:<IP o nome del server>

Ora avvia il tuo gioco e scegli nullmodem / serial cable / already connected
come metodo multiplayer su COM1. Imposta lo stesso baudrate su entrambi i
computer.

Inoltre possono essere specificati parametri aggiuntivi per controllare il
comportamento della connessione nullmodem. Questi sono tutti i parametri:

 * port:         - Numero porta TCP. Default: 23
 * rxdelay:      - quanto a lungo (millisecondi) mettere in attesa i dati ricevuti
                   se l'interfaccia non è pronta. Aumenta questo valore se
                   incontri molti errori di overrun nella Status Window di DOSBox.
                   Default: 100
 * txdelay:      - quanto a lungo trattenere i dati prima di inviare un pacchetto.
                   Default: 12
                   (riduce l'overhead della rete)
 * server:       - Questo nullmodem sarà una connessione client al server specificato.
                   (Se non viene specificato un server: sii un server.)
 * transparent:1 - Invia solo i dati seriali, nessun handshake RTS/DTR. Usa questo
                   parametro se ti connetti a qualsiasi altra cosa che non sia un
                   nullmodem.
 * telnet:1      - Interperta dati Telnet dal sistema remoto. Imposta trasparente
                   automaticamente.
 * usedtr:1      - La connessione non sarà stabilita fun quando DTR non è attivato
                   dal programma DOS. Utile per i terminali modem.
                   Imposta trasparente automaticamente.
 * inhsocket:1   - Usa un socket passato a DOSBox da linea di comando. Imposta
                   trasparente automaticamente. (Eredità dei Socket: Viene usato
                   per giocare vecchi giochi DOS sui nuovi software BBS.)

Esempio: Essere server in ascolto sulla porta TCP 5000.
   serial1=nullmodem server:<IP o nome del server> port:5000 rxdelay:1000



==================================================
9. Come giocare a giochi particolarmente esigenti:
==================================================

DOSBox emula la CPU, il suono e le schede video, e altre periferiche di un
PC, tutte allo stesso tempo. La velocità di una applicazione DOS emulata
dipende da quante istruzioni possono essere emulate, che è impostabile
(numero di cicli).

Cicli CPU
  Per default (cycles=auto) DOSBox prova a rilevare se un gioco ha bisogno
  di tutti i cicli possibili per essere eseguito. Puoi forzare questo
  comportamento impostando cycles=max nel file di configurazione di DOSBox.
  Allora la finestra di DOSBox mostrerà una riga "Cpu Cycles: max" in alto.
  In questa modalità puoi ridurre la quantità di cicli su base percentuale
  (premi CTRL-F11) o aumentarla nuovamente (CTRL-F12).
  
  A volte impostare in maniera manuale il numero di cicli porta a risultati
  migliori, ad esempio specificando nel file di configurazione cycles=30000.
  Durante l'esecuzione delle applicazioni DOS puoi aumentare i cicli con
  CTRL-F12 anche di più, ma avrai comunque il limite della potenza del tuo
  processore reale. Puoi vedere in che misura è impegnato andando sul Task
  Manager di Windows 2000/XP o nel Monitor di Sistema in Windows 95/98/ME.
  Quando la CPU sarà usata al 100%, non vi è più modo di velocizzare DOSBox,
  a meno che tu non riduca la quantità di CPU occupata dalle parti di DOSBox
  non strettamente legate alla CPU.

Core CPU
  Sulle architetture x86 puoi provare a forzare l'uso di un core ricompilato
  dinamicamente (imposta core=dynamic nel file di configurazione di DOSBox).
  Di solito questo fornisce migliori risultati se l'autorilevazione (core=auto)
  fallisce. E' bene accoppiarvi cycles=max. Nota che potrebbero esserci dei
  giochi che funzionano peggio col core dinamico, o che non funzionino affatto!

Emulazione grafica
  L'emulazione VGA è una parte molto esigente di DOSBox in termini di uso
  della CPU. Aumenta il numero di fotogrammi saltati (in passi di uno)
  premendo CTRL-F8. L'uso della CPU dovrebbe scendere quando si usa un
  numero di cicli fisso.
  Vai indietro di un passo e ripeti questo fin quando il gioco gira
  abbastanza velocemente per i tuoi gusti. Nota che questo è un baratto:
  perdi in fluidità video ciò che guadagni in velocità.

Emulazione sonora
  Puoi anche provare a disattivare il suono attraverso l'utilità di setup dei
  giochi per ridurre ulteriormente il carico sulla CPU. Impostando nosound=true
  NON disabiliti l'emulazione sonora, ma semplicemente la riproduzione dell'output.

Inoltre cerca di chiudere tutti i programmi eccetto DOSBox per riservargli
la quantità massima possibile di risorse.


Configurazione avanzata dei cicli:
I settaggi cycles=auto e cycles=max possono avere dei parametri per ottenere
diversi standard quando si avviano i programmi. La sintassi è
  cycles=auto ["default modalità reale"] ["default modalità protetta"%] 
              [limit "limite cicli"]
  cycles=max ["default modalità protetta"%] [limit "limite cicli"]
Esempio:
  cycles=auto 1000 80% limit 20000
  userà cycles=1000 per i giochi in modalità reale, 80% CPU variabile per i giochi
  in modalità protetta con un limite superiore di 20000



============================
10. Risoluzione dei problemi
============================

DOSBox crasha proprio dopo averlo avviato:
  - usa diversi valori per l'opzione output= nel file di
    configurazione
  - prova ad aggiornare i driver video e le DirectX

L'avvio di un certo gioco chiude DOSBox, causa un crash o blocca tutto:
  - vedi se funziona con una installazione incontaminata di DOSBox
    (file di configurazione non modificato)
  - provalo col sonoro disattivato (usa il programma di configurazione
    del suono incluso nel gioco, oppure imposta sbtype=none e gus=false nel
    file di configurazione di DOSBox)
  - cambia alcune opzioni nel file di configurazione di DOSBox, in particolare:
      core=normal
      un numero fisso di cicli (ad esempio cycles=10000)
      ems=false
      xms=false
    oppure combinazioni dei settaggi sopra
  - usa loadfix prima di avviare il gioco

Il gioco esce al prompt di DOSBox con qualche strano messaggio di errore:
  - leggi il messaggio di errore attentamente e prova a localizzarne la causa
  - prova i suggerimenti delle sezioni sopra
  - monta in modo diverso i drive, dato che alcuni giochi sono schizzinosi
    riguardo i percorsi, per esempio se hai usato "mount d d:\giochi\abc" prova
    "mount c d:\giochi\abc" e "mount c d:\giochi"
  - se il gioco richiede un CD-ROM assicurati di usare "-t cdrom" quando
    monti, e prova altri parametri diversi (come ioctl, usecd e label, vedi
    la sezione appropriata)
  - controlla i permessi sui file del gioco (togli gli attributi di sola lettura,
    aggiungi i permessi in scrittura ecc.)
  - prova a reinstallare il gioco da dentro DOSBox


==============================
11. Il file di configurazione:
==============================

Un file di configurazione può essere generato usando CONFIG.COM, che può
essere trovato nel drive interno Z: quando avvii DOSBox. Leggi la sezione
dei programmi interni del readme per sapere come usare CONFIG.COM.
Puoi modificare il file di configurazione generato, per personalizzare
DOSBox.

Il file è diviso in varie sezioni (i cui nomi sono racchiusi tra [] ).
Alcune sezioni hanno opzioni che puoi impostare.
# e % indicano righe commentate.
Il file di configurazione generato contiene i settaggi attuali. Puoi modificarli
e avviare DOSBox col parametro -conf per caricare il file e usare i nuovi settaggi.

DOSBox caricherà i settaggi per prima cosa da ~/.dosboxrc (Linux),
~\dosbox.conf (Win32) o "~/Library/Preferences/DOSBox Preferences" (MACOSX).
Successivamente DOSBox caricherà tutti i file di configurazione specificati col
parametro -conf. Se non viene specificato nessun file di configurazione col parametro
-conf, DOSBox cercherà il file dosbox.conf nella directory corrente.


=======================
12. Il file linguaggio:
=======================

CONFIG.COM può generare un file linguaggio (CONFIG -writelang filelinguaggio).
Leggilo, e (si spera) capirai come cambiarlo.
Avvia DOSBox col parametro -lang per usare il tuo nuovo file linguaggio.
In alternativa, puoi impostarne il nome nel file di configurazione nella
sezione [dosbox]. Troverai un'opzione language= che puoi cambiare alla bisogna.



========================================
13. Costruire la tua versione di DOSBox:
========================================

Scarica i sorgenti.
Guarda l'INSTALL che sta al loro interno.



============================
14. Ringraziamenti speciali:
============================

Vedi il file THANKS.


=============
15. Contatti:
=============

Vai nel sito:
http://dosbox.sourceforge.net
per gli indirizzi email (pagina Crew).
