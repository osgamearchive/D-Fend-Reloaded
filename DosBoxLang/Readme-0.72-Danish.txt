DOSBox v0.72


======
NOTAT: 
======


Selvom Vi håber at DOSBOX en dag vil kunne køre alle programmer der
nogensinde er lavet til PCen, er vi der ikke endnu. Lige nu er
DOSBox, der kører på en high-end maskine nogenlunde lig med en 486
PC. DOSBox Kan indstilles til at køre en bred vifte af DOS spil, fra
CGA/Tandy/PCjr klassikere til spil fra Quake æraen.



======
INDEX:
======
1. Hurtigstart
2. FAQ (Ofte Stillede Spørgsmål)
3. Brug
4. Interne Programmer
5. Specielle taster
6. Mapper (Tastatur og joystick indstillinger)
7. Keyboard Layout
8. Serial Multiplayer feature
9. Hvordan resource-krævende spil køres
10. Problemløsning
11. Config-filen (indstillingsfilen)
12. Sprog-filen
13. Hvordan du bygger din egen version af DOSBox
14. Special thanks
15. Contact


===============
1. Hurtigstart:
===============

 For en hurtig introduktion, skriv INTRO i DOSBox.
Det er vigtigt at du bliver dus med det at montere(mount-kommandoen),
DOSBox gør ikke selv automatisk drev(ene) (eller dele af drev(ene)), 
tilgængelige for emuleringen. 
Se FAQ : "Jeg har et Z istedet for C ved prompten", 
og beskrivelsen af Mount kommandoen (sektion 4).



=======
2. FAQ:
=======

Nogle ofte Stillede Spørgsmål: (Q:= spørgsmål A:=svar)


Q: Jeg har et Z istedet for C ved prompten.
Q: Skal jeg altid udføre disse kommandoer? Automatisering?
Q: Hvordan ændrer jeg til fuldskærm modus?
Q: Min CD-ROM virker ikke.
Q: Musen virker ikke.
Q: Der er ingen lyd.
Q: Lyden hakker eller lyder mærkelig.
Q: Jeg kan ikke skrive \ eller : i DOSBox.
Q: Keyboardet/tastaturet lagger.
Q: Cursoren/markøren bevæger sig altid i een retning!
Q: Spillet/programmetgamet kan ikke finde sin CD-ROM.
Q: Spillet/programmetgamet kører meget langsomt!
Q: Kan DOSBOX skade min computer?
Q: Jeg vil gerne ændre Hukommelses-mængde/Cpu hastighed/ems/soundblaster IRQ.
Q: Hvilken lyd-hardware emuler DOSBOX lige nu?
Q: DOSBox går ned under opstart, og jeg kører arts
Q: Storartet README, men jeg forstår det stadig ikke.





Q: Jeg har et Z istedet for C ved prompten.
A: Du kan gøre dine mapper/directories/biblioteker brugbare som drev i DOSBOX
   ved hjælp af "mount" kommandoen. F. Eks. vil (i Windows) kommandoen 
   "mount C D:\GAMES" give dig et C drevi DOSBOG som peger mod dit Windows 
   D:\GAMES directory.
   I Linux, vil "mount c /home/username" give dig et C drev i DOSBox som
   peger mod /home/username i Linux.
   Skriv "C:" for at skifte til det førnævnte monterede drev. Hvis Alting gik godt,
   vil DOSBox will vise the prompten "C:\>".


Q: Skal jeg altid udføre disse kommandoer? Automatisering?
A: Der er i DOSBox's config-fil en [autoexec] sektion. Kommandoerne som er skrevet der
   køres når DOSBox startes, så du kan bruge denne sektion til at montere.


Q: Hvordan ændrer jeg til fuldskærm modus?
A: Tast alt-enter. Alternativt: Ret DOSBox's config-fil og ændr muligheden   
   fullscreen=false til fullscreen=true. Leg med muligheden : fullresolution hvis
   fuldskærms modus ser forkert ud efter din mening. Tryl alt-enter igen for at 
   komme tilbage fra fuldskærms modus.


Q: Min CD-ROM virker ikke.
A: For at montere din CD-ROM i DOSBox Skal du specificere yderligere nogle mulig-
   heder når du monterer CD-ROMMEN. 
   For at muliggøre den mest grundlæggende CD-ROM understøttelse :
     - mount d f:\ -t cdrom
   For at muliggøre lav-niveau SDL-understøttelse :   
     - mount d f:\ -t cdrom -usecd 0
   For at muliggøre lav-niveau ioctl-understøttelse(win2k/xp/linux) :
     - mount d f:\ -t cdrom -usecd 0 -ioctl
   For at muliggøre lav-niveau aspi-understøttelse(win98 med aspi-lag installeret) :
     - mount d f:\ -t cdrom -usecd 0 -aspi
   
   Kommandoerne :   - d   drevbogsta får du i DOSBox
                    - f:\ placering af cdrom i din PC.
                    - 0   Nummerey af ´CD-ROM drevet, findes med mount -cD   
   Se også spørgsmålet : Spillet/programmetgamet kan ikke finde sin CD-ROM.


Q: Musen virker ikke.
A: Normalt finder DOSBox ud af om et spil bruger Mus.Når du klikker på skærmen
   (DOSBOX vinduet)skulle den låse/bindes, og virke. 
   Ved nogle spil virker dette ikke, så du må selv låse/binde musen, ved at taste
   CTRL-F10.


Q: Der er ingen lyd.
A: Vær sikker på at lyden er korrekt indstillet i spillet. Dette gøres under 
   installationen eller med et setup/setsound program som følger med spillet. 
   Se først om der er auto-detektion. Hvis der ikker er det, så prøv at vælge
   soundblaster eller soundblaster16 med default settings : "address=220 irq=7 
   dma=1". Du måtte også ønske at vælge midi på address 330 som musik enhed.
   Parametrene til de emulerede lydkort kan ændres i DOSBOX's config-fil.
   Hvis du stadig ikke får nogen lyd kan du sætte core til normal og bruge nogle 
   lavere valgte cycles værdier (F.eks. cycles=2000). Vær også sikker på at din
   lydenhed leverer lyd.


Q: Lyden hakker eller lyder mærkelig.
A: Du bruger for meget cpu kraft til at holde DOSBOX kørende ved den aktuelle 
   hastighed. Du kan nedsætte cycles, skippe frames reducere sampling raten på
   den pågældende lydenhed (se DOSBox's config-fil) eller mixer-enheden.
   Du kan også forøge prebufferen i config-filen. 
   Hvis du bruger cycles=max or =auto , så vær sikker på at der ingen baggrundspro-
   cesser er, som forstyrrer! (særlig hvis de brugerharddisken)

Q: Jeg kan ikke skrive \ eller : i DOSBox.
A: Dette er et kendt problem. Detopstår kun hvis dit keyboard/tastatur layout 
   ikke er US.
   Nogle mulige løsninger:
     1. Skift keyboard layout i dit operativsystem.
     2. Brug / istedet.
     3. Åbn Dosbox.conf og lav usescancodes=false om til usescancodes=true.
     4. Tilføj de kommandoer(extra) som du vil køre i "config-filen".
     5. Lav dos keyboard layoutet om (se Sektion 7 Keyboard Layout).
     6. Brug ALT-58 for : og ALT-92 for \.
     7. prøv tasterne omkring "enter" for \ og prøv shift og tasterne imellem 
        "enter" and "l" (US keyboard layout) for ":" .
     8. Prøv keyb.com fra FreeDOS (http://projects.freedos.net/keyb/).
        Se efter keyb2.0 pre4 da ældre og nyere versioner er kendt for at have 
        fejl i deres indlæsningsrutiner.


Q: Keyboardet/tastaturet lagger.
   Sænk prioritetssindstillingen i DSOBox's config-fil, prøv f.eks. :
   "priority=normal,normal". Du kan også sætte et lavere antan cycles.


Q: Cursoren/markøren bevæger sig altid i een retning!
   Se om det stadig sker hvis du slår joystick emuleringen fra,
   sæt joysticktype=none i [joystick] sektionen i DOSBox's config-fil.
   Du skal måské også prøve at trække stik(ene) ud på dit/dine joystick(s).
   Hvis du ønsker at bruge joystick i spillet, prøv så at sætte timed=false,
   calibrér joysticket(både dit OS og i spillet eller dit spils' setup).


Q: Spillet/programmetgamet kan ikke finde sin CD-ROM.
A: Vær sikker på at montere CD-ROMMEN med -t cdrom switchen, dette vil starte
   MSCDEX fladen som DOS spil kræver for at give adgang til CD-ROM.
   Prøv også at tilføje korrekt label/etikét (-label LABEL). 
   Brug mount: -usecd #, hvor # er nummeret på CD-ROM drevet, for lav-niveau 
   understøttelse (# findess medmount -cd)
   Under Windows kan du specificere -ioctl eller -aspi. Se beskrivelse andetsteds
   i dette dokument.
   Prøv at lave et CD-ROM image(helst CUE/BIN), og brug DOSBox's interne 
   IMGMOUNT kommando til at montere imaget. Dette muliggør meger god lav-niveau
   CD-ROM support på alle operativ systemer.

Q: Spillet/programmetgamet kører meget langsomt!
A: Se i sektionen "Hvordan man kører resource-krævende spil" for mere 
   information.


Q: Kan DOSBOX skade min computer?
A: DOSBox kan ikke skade din computer mere et hvilket som helst andet resource
   krævende program. forøgelse af cycles overclock ikke din fysiske CPU.
   for høj sat cycles har en negativ ydelses effekt på software der køre i DOSBOX.


Q: Jeg vil gerne ændre Hukommelses-mængde/Cpu hastighed/ems/soundblaster IRQ.
A: Dette er muligt! Duskal bare lave en config-fil: config -writeconf configfile.
   Start din favorit editor og gennemse indstillingerne. For at starte DOSBox
   med dine nye indstillinger: dosbox -conf config-fil


Q: Hvilken lyd-hardware emuler DOSBOX lige nu?
A: DOSBox emulerer fleres lydenheder:
   - Intern PC speaker/højtaler
     Denne emulering inkludérer både tonegenerator og flere former af digitalt 
     lydoutput gennem den interne speaker/højtaler.
   - Creative CMS/Gameblaster
     Dette er det første kort lavet af Creative Labs(R). Default 
     indstillinger er sat til port 0x220.  Det bør bemærkes at det kan give pro-
     blemer at bruge det sammen med Adlib emulering.
   - Tandy 3 voice 
     Emuleringen af denne lyd hardware er komplet med undtagelse af støjkanalen.
     Støjkanalen er ikke særlig godt dokumenteret  og er som sådan kun et bedste 
     gæt på lydens nøjagtighed.
   - Tandy DAC
     Emuleringen af Tandy DAC bruger the soundblaster emulatering, derfor 
     vær sikker på at soundblaster ikke er slået fra i DOSBox's config-fil.
     Tandy DAC er kun emuleret på bios-niveau.
   - Adlib
     Lånt fra MAME, denne emulering er næsten perfektog indeholder Adlib's evne
     til næsten at kunne spille digitalliseret lyd.
   - SoundBlaster 16/ SoundBlaster Pro I & II /SoundBlaster I & II
     Default leverer DOSBox Soundblaster 16 niveau 16-bit stereo sound. 
     Du kan vælge en anden SoundBlaster version i DOSBOX'sconfig-fil (Se Interne
     kommandoer: CONFIG).
   - Disney Soundsource
     Som bruger af printer porten, kan denne lydenhed kun udsende digital lyd.
   - Gravis Ultrasound
     Emuleringen af denne hardware er næsten komplet, selvom midimuligheden er
     udeladt, siden en MPU-401 er emuleret in anden kode.
   - MPU-401
     En  MIDI gennemgangs flade er også emuleret.  Denne type lyd-udgang vir-
     ker kun brugt sammen med en General Midi eller MT-32 device.


Q: DOSBox går ned under opstart, og jeg kører arts
A: Dette er i virkeligheden ikke et DOSBOX problem, men løsningen er at sætte 
   environment variable SDL_AUDIODRIVER to alsa or oss.


Q: Storartet README, men jeg forstår det stadig ikke.
A: Et kig på "The Newbie's pictorial guide to DOSBox" lokaliseret på 
   http://vogons.zetafleet.com/viewforum.php?f=39 kan måské hjælpe dig.
   Prøv også the wiki of dosbox:
   http://dosbox.sourceforge.net/wiki/


For more questions read the remainder of this README and/or check 
the site/forum:
http://dosbox.sourceforge.net




========
3. Brug:
========

Et overblik over kommandolinie options/mulighederne du kan bruge med DOSBox.
Windows  brugere må åbne cmd.exe eller command.com eller rette i
Genvej/shortcut til DOSBox.exe for dette.
Mulighederne er brugbare for alle operativ systemerThe medmindre der står andet
i options beskrivelsen:

dosbox [navn] [-exit] [-c command] [-fullscreen] [-conf congfigfile] 
       [-lang sprog-fil] [-machine maskinetype] [-noconsole]
       [-startmapper] [-noautoexec] [-scaler scaler | -forcescaler scaler]
       
dosbox -version

  name   
        Hvis "navn" er et directory/en mappe/et bibliotek bliver  det/den/det 
        monteret som C: drevet.
        Hvis "navn" er en eksekverbar fil, bliver "navn"s directory/mappe/bibliotek
        monteret som C: drevet "navn" eksekveret.
    
  -exit  
        DOSBox lukker sig selv når programmet "navn" afsluttes.

  -c command
        Kører den specificerede kommando "navn" køres. Der kan specificeres flere 
        kommandoer. Hver kommando starter dog med "-c".
        En kommando kan være et internt program, en DOS kommando eller en eksekverbar
        fil på et monteret drev.

  -fullscreen
        Starter DOSBox i fuldskærm modus.

  -conf configfile
        Starer DOSBox med options/muligheder specificeret i "configfile".
        Der kan være flere -conf options.
        Se kapitel 10 for flere detaljer.

  -lang sprog-fil
        Start DOSBox med sproget specificeret i"sprog-fil".

  -machine maskinetype
        Sæt DOSBox til at emulere en speciel typemaskine. brugbare valg er:
        hercules, cga, pcjr, tandy, vga (default). Valget af maskinetype anfægter
        både grafikkort og tilgængelige lydkort.

  -noconsole (Windows Only)
        Start DOSBox uden at vise konsol-vinduet. Output bliver omstillet til
        stdout.txt and stderr.txt
	
  -startmapper
        Få direkte adgang til the keymapper ved opstart. Brugbar hvis du har 
        keyboard/tastatur problemer.

  -noautoexec
        Skipper [autoexec] sektionen af den indlæste config-fil.

  -scaler scaler
        Bruger scaleren angivet med "scaler". Se i DOSBox's config-fil
        hvilke scalere du kan bruge.

  -forcescaler scaler
        Ligesom -scaler parameteren, men prøver at tvinge brugen af
        den specificerede scaler selvom den måské ikke passer.

  -version
        Skriver version information og afslutter. Brugbar for Frontends.

Note: Sæt hele navn/kommando/config-fil/sprogfil i "" anførelsestegn hvis
      navn/kommando/config-fil/sprogfil indeholder et mellemrum.("kommando 
      eller fil navn"). Hvis du har brug for at bruge anførelsestegn indeni 
      anføressestegn (mest sandsynlig med -C og mount). 
      EWindows og OS/2 brugere kan bruge 'enkelte anførelsestegn' indeni alm.
      anførelsestegn. Andre skulle kunne bruge escaped alm. anførelsestegn indeni
      alm. anførelsestegn.
      win -c "mount c 'c:\program files\'" 
      linux -c "mount c \"/tmp/navn med mellemrum\""

For eksempel:

dosbox c:\atlantis\atlantis.exe -c "MOUNT D C:\SAVES"
  Denne kommando monterer c:\atlantis som c:\ og kører atlantis.exe.
  efter at have monteret C:\SAVES som D drevet.

Under Windows kan du også "trække og slippe" /directories/mapper/biblioteker og 
eksekverbare filer på DOSBox.exe og genveje til samme.



=======================
4. Interne Programmmer:
=======================

DOSBox understøtter de fleste DOS kommandoer der bruges i command.com.
Du kan skrive "HELP" ved prompten(efterfulgt af enter) for at få en liste over interne de kommandoer.

Desuden er de følgende kommandoer tilgængelige: 

MOUNT "Emuleret Drev bogstav" "Rigtige Drev eller Directory" 
      [-t type] [-aspi] [-ioctl] [-usecd nummer] [-size drevstørrelse] 
      [-label drevlabel] [-freesize størrelse_i_mb]
      [-freesize size_in_kb (floppies)]  
MOUNT -cd
MOUNT -u "Emuleret Drev Bogstav"

  Program til at montere lokale directories/mapper/biblioteker som drev i DOSBox.

  "Emuleret Drev Bogstav"
        Drev Bogstavet i dosbox (f.eks. C).

  "Rigtige Drev bogstav (normalt for CD-ROMMer i Windows) or Directory"
        Det/den lokale directory/mappe/bibliotek du ønsker at tilgængeligt i dosbox.

  -t type
        Type af monteret directory. følgende kan bruges: dir (default),
        floppy, cdrom.

  -size drevstørrelse     
        Sætter størrelsen på drevet, hvor drevstørrelse er angivet i :
        "bps,spc,tcl,fcl":
           bps: bytes pr sektor, default 512 for regulære drev og
                2048 for CD-ROM drev
           spc: sektorer pr klynge, normalt mellem 1 and 127
           tcl: total klynger, mellem 1 and 65534
           fcl: total frie klynger, mellem 1 og tcl

  -freesize størrelse_i_mb
        Sætter mængden af fri plads på drev i megabytes.
        (regulære drev) eller kilobytes  (floppy drev).
        Dette er en simplere version af -size.	

  -label drevlabel
        Sætter navnet på drevet til "drevlabel". Er nødvendigt på nogle systemer
        hvis cd'ens label bliver læst korrekt. Værdifuldt nåtr et program ikke 
        kan finde sin cdrom. Hvis du ikke specificerer en/et label og der er valgt
        lav-niveau understøttelse (-usecd # and/or -ioctl/aspi): 
          For win32: label bliver hentet fra "Rigtige Drev".
          For Linux: label bliver sat til NO_LABEL.

        Hvis du specificerer en/et label, vil den/dette label vare lioge så længe
        som dreveter monteret. Det vil ikke blive opdateret !!

  -aspi
        Tvinger brugen af aspi-lag. Kun brugbar hvis cdrom monteres under 
        Windows systems with ASPI-Lag.

  -ioctl   
        Tvinger brug af ioctl Kommandoers. Kun brugbar hvis cdrom monteres under 
        et Windows OS som understøtter dem (Win2000/XP/NT).

  -noioctl   
        Tvinger brug af SDL CD-ROM lag. Virker på alle systemer.
 
  -usecd nummer
        Tvinger brug af SDL cdrom understøttelse for drev nummmer.
        Nummeret kan findes med  -cd. Brugbart på alle systemer.

  -cd
        Viser alle fundne cdrom drev og deres numre Bruges sammen med -usecd.

  -u
        Fjerner monteringen. Virker ikke for Z:\.

  Note: Det er muligt at montere lokalt directory/mappe/bibliotek som cdrom drev. 
        ..Så mangler Hardware Understøttelse.

  I bund og grund tillader MOUNT dig at montere reel hardware til DOSBox's emu-
  lret PC.
  Så MOUNT C C:\GAMES får DOSBox til at bruge dit  C:\GAMES directory som C:
  i DOSBox. MOUNT tillader dig også også at ændre drev-bogstavs-identifikation 
  for programmer som kræver specielle drev-bogstaver.
  
  For example: Touche: Adventures of The Fifth Musketeer skal køres på dit C:
  drev. Når du bruger DOSBox og mount ommandoen, kan du snyde programmet til at
  tro at det er på C drevet, og i virkeligheden placere det hvor du har lyst. For
  eksempelkan du hvis spillet er i D:\OLDGAMES\TOUCHE,vil kommandoen
  MOUNT C D:\OLDGAMES tillade dig at køre Touche D drevet.

  Det er ikke anbefalet at Montere hele C drevet med MOUNT C C:\ Det samme gælder
  for at montere roden et andet drev, bortset fra CD-ROMer (grundet af deres ikke 
  skrivebare natur). Ellers kan du eller DOSBox lave fejl - så du risikerer at 
  miste alle dine filer.
  Det anbefales at du placerer alle dine programmer/spil i et/en
  underdirectory/undermappe/underbibliotek og monterer det/den.

  Generelle MOUNT Eksempler:
  1. At montere c:\DirX som diskette : 
       mount a c:\DirX -t floppy
  2. At montere system cdrom drev E as cdrom drev D i DOSBox:
       mount d e:\ -t cdrom
  3. At montere system cdrom drev på mountpoint /media/cdrom as cdrom drive D 
     in dosbox:
       mount d /media/cdrom -t cdrom -usecd 0
  4. At montere et drev with 870 mb free diskspace (simpel version):
       mount c d:\ -freesize 870
  5. At montere et dreve with 870 mb free diskspace (kun eksperter, fuld kontrol):
       mount c d:\ -size 4025,127,16513,1700
  6. At montere /home/user/dirY som drev C in DOSBox:
       mount c /home/user/dirY
  7. At montere directory hvor DOSBox blev startet som D i DOSBox:
       mount d .


MEM
  Program til at vise størrelsen på fri hukommelse.


CONFIG -writeconf lokal-fil
CONFIG -writelang lokal-fil
CONFIG -set "sektion egenskab=værdi"
CONFIG -get "sektion egenskab"

  CONFIG kan bruges til at ændre eller forespørge forskellige indstillinger i 
  DOSBox under brug. CONFIG kan gemme "nuværende indstillinger" og "sprogstrenge"
  til disken(f.eks generere en dansk dosbox.conf).CONFIGInformation om alle 
  mulige sektioner kan findes i sektion 11 (CONFIG-filen).

  -writeconf lokal-fil
       Skriver de nuværende indstillinger til fil "lokal-fil" er lokaliseret på 
       det lokale drev ikke på et monteret drev i DOSBox. 
       CONFIG-filen kontrollerer forskellige DOSBox-indstillinger : 
       størrelsen på emuleret hukommelse, de emulerede lydkortog mange andre ting
       CONFIG-filen giver dig også adgang til AUTOEXEC.BAT.
       Se sektion 11 (Config-Filen) for mere information.

  -writelang lokal-fil
       Skriver de nuværende sprog-indstillinger til fil. "lokal-fil" er lokali-
       seret på det lokale drev ikke på et monteret drev i DOSBox. 
       Sprog-filen kontrolerer alle synlige output fra de interne kommandoer og
       den interne dos.

  -set "sektion egenskab=værdi"
       CONFIG vil prøve at sætte pågældende egenskab til en ny værdi. Lige nu
       kan CONFIG ikke fortælle om kommandoen lykkedes eller ikke.

  -get "sektion egenskab"
       Nuværende værdi af pægældende egenskabskrives og gfemmes i miljø-variablen 
       %CONFIG%.Denne kan bruges til at gemme værdien når man bruger batch filer.
1
  Både "-set" og "-get" virker fra batch filer og kan bruges til at generere egne
  indstillinger for hvert spil.
  
  Eksempler:
  1. At lave  en configfil i nuværende directory/mappe/bibliotek:
      config -writeconf dosbox.conf
  2. At sætte cpu cycles til 10000:
      config -set "cpu cycles=10000"
  3. At afbryde ems hukommelses emulering:
      config -set "dos ems=off"
  4. At se hvilken cpu core/kerne der bruges.
      config -get "cpu core"


LOADFIX [-size] [program] [program-parameters]
LOADFIX -f
  Program til at reducere mængden af fri hukommelse. Brugbar til gamle
  programmer der ikke forventer meget fri hukommelse. 

  -size	        
        antal kilobytes to "æde op", default = 64kb
  
  -f
        frigør alt tidligere allokeret hukommelse
  

Eksempler:
  1. At starte mm2.exe og allokere 64kb hukommelse 
     (mm2 will have 64 kb less available) :
     loadfix mm2
  2. At starte mm2.exe og allokere 32kb hukommelse :
     loadfix -32 mm2
  3. At frigøre tidligere allokeret hukommelse :
     loadfix -f


RESCAN
  Får DOSBox til at genindlæse directory/mappe/biblioteks strukturen. Brugbar 
  hvis du har ændret noget, på et monteret drev, udenfor DOSBox. (CTRL - F4 
  gør også dette!)
  

MIXER
  Får DOSBox til at vise nuværende lydindstillinger. 
  Herer mulighederne for at ændre dem:
  
  mixer channel left:right [/NOSHOW] [/LISTMIDI]
  
  channel
      Kan være : MASTER, DISNEY, SPKR, GUS, SB eller FM.
  
  left:right
      Lydniveauet i procent. Hvis du sætter D foran ændres det til 
      deciBell (eksempel mixer gus d-10).
  
  /NOSHOW
      Forhindrer DOSBox  i at vise resultatet hvis du sætter et lydniveau.

  /LISTMIDI
      Skriver en liste over tilgængelige midi enheder på din pc (Windows). 
      Du kan vælge en anden enhed end Windows default midi-mapper, ved at til-
      en linie 'config=id' til [midi] sektionen in the Config-filen, hvor 'id' 
      er nummeret på enheden fra listemn genereret af LISTMIDI.


IMGMOUNT
  Et program til am montere disk images og CD-ROM images i DOSBox (f.eks. en iso).
  
  IMGMOUNT DREV [imagefil] -t [image_type] -fs [image_format] 
            -size [sectorsbytesize, sectorsperhead, heads, cylinders]

  imagefil
      Placering af image-file der skal monteres i DOSBox. Placeringen kan være på 
      et monteret drev i DOSBox, eller på din fysiske disk. Det er også muligt at
      montere CD-ROM images (ISOer eller CUE/BIN), Hvis du har brug for at kunne 
      "skifte cd" skal du skrive alle images i rækkefølge.
      CD'erne kan skiftes med CTRL-F4 til enhver tid.
   
  -t 
      Følgende er godkendte image typer:
        floppy: Specificerer et eller flere floppy image(s).  DOSBox finder selv 
        diskens geometri( 360K, 1.2MB, 720K, 1.44MB, osv.).
        iso:    Specificerer et CD-ROM iso image.  Geometrien bliver sat automatisk
                sat. Kan være en iso eller cue/bin.
        hdd:    Specificerer etharddisk image. Den brugelige CHS geometri skal
                skrives for at det virker.

  -fs 
      Følgende er brugbare filsystem formater:
        iso:  Specificerer ISO 9660 CD-ROM formatet.
        fat:  Specificerer at imaget bruger FAT filsystemet. DOSBox vil forsøge
              at montere dette image som et drev i DOSBox og gøre filerne tilgængelige 
              i DOSBox.
        none: DOSBox Gør ikke noget forsøg på at læse filsystemet på disken.
              Dette bruges hvis duhvis du skal formatere den eller starte den med med 
              BOOT kommandoen.  Når du bruger "none" filsystem, er det bedre at
              specificere drevnummer (2 eller 3, 
               2 = master, 3 = slave) end et drevbogstav.  
              For eksempel monteres et 70MB image som slave drev, 
              sådan:
                "imgmount 3 d:\test.img -size 512,63,16,142 -fs none" 
                (uden anførelsestegn)  sammenlignet med en montering for at læse 
                drevet i DOSBox, som ser sådan ud: 
                "imgmount e: d:\test.img -size 512,63,16,142"

  -size 
     Specificering af drevets Cylinders, Heads og Sectors.
     Er ødvendigt for at montere drev images.
     
  Et eksempel på hvordan man monterer CD-ROM images:
    1a. mount c /tmp
    1b. imgmount d c:\miniso.iso -t iso
  eller (som også virker):
    2. imgmount d /tmp/miniso.iso -t iso


BOOT
  Boot starter floppy images eller hard disk images uafhængigt af operativ-
  systemes emuleringen DOSBOX tilbyder. Dette tillader dig at spille starter disketter
  eller starte andre operativsystemer via.
  Hvis det valgte emulerede system er PCjr (machine=pcjr) kan boot kommandoen
  bruges til at indlæse PCjr magasiner (.jrc). 

  BOOT [diskimg1.img diskimg2.img .. diskimgN.img] [-l drevbogstav]
  BOOT [cart.jrc]  (PCjr only)

  diskimgN.img 
     Kan være et relativt nummer på diskette/floppy -images der ønskes,monteret
     efter at DOSBox starter(boots) det specificerede drevbogstav.
     du kan taste CTRL-F4 for at skifte fra nuværende disk til næste  next disk
     på listen. Listen starter forfra efter sidst disk image.

  [-l drevbogstav]
     Denne parameter tillader dig at specificere drevet du vil starte fra.  
     Default er A drevet, floppy drevet. Du kan også starte et harddisk image 
     monteret som master ved at specificere "-l C" uden anførelsestegn, eller
     drevet som slave ved at specificere "-l D"
     
   cart.jrc (PCjr only)
     Når emulering af PCjr er slået til, kan man indlæse magasiner med 
     BOOT kommandoen. Der er stadig begrænset understøttelse.


IPX

  Det er nødvendigt at muliggøre IPX netværk i DOSBox's Config-fil.

  Al IPX-netværk bliver styret gennem det interne DOSBox program IPXNET. 
  For hjælp til IPX netværk i DOSBox, tast "IPXNET HELP" (uden anførelsestegn),
  så får du en liste over kommandoer og relevant dokumentation. 

  Hvad angår at sætte et netværk op, skal den ene PC være server. Dette sker med 
  kommandoen : "IPXNET STARTSERVER" (uden anførelsestegn) i en kørende DOSBox. 
  Server DOSBox'en tilføjer automatisk sig selv til det virtuelle IPX netværk.
  Du skal taste "IPXNET CONNECT <computer værts name eller IP>" for hver eneste 
  computer som tilføjes det virtuelle IPX netværk, 
  For eksempel, hvis din server er på bob.dosbox.com, skal du taste 
  "IPXNET CONNECT bob.dosbox.com" på hver eneste ikke-server maskine. 
  
  At spille spil der kræver Netbio skal du bruge en fil som hedder NETBIOS.EXE 
  fra Novell. Opret IPX forbindelsen som forklaret ovenover og kør så "netbios.exe". 

  Følgende er en IPXNET kommando reference: 

  IPXNET CONNECT 

     IPXNET CONNECT  åbner forbindelsen til en IPX kanaliseret server, som kører
     på en anden DOSBox maskine. "addresse" parameteren specificerer IP adressen
     eller værtsnavnet på server-PC'en. Du kan også specificere hvilken UDP port
     du vil bruge. Default bruger IPXNET port 213 - den til IPX kanaliseret 
     tildelte IANA port - til sin forbindelse. 

     Syntaxen for IPXNET CONNECT er: 
     IPXNET CONNECT addresse <port> 

  IPXNET DISCONNECT 

     IPXNET DISCONNECT lukker forbindelsen til den IPX kanaliserende server. 

     Syntaxen for IPXNET DISCONNECT er: 
     IPXNET DISCONNECT 

  IPXNET STARTSERVER 

     IPXNET STARTSERVER starter en IPX kanaliserende server på den kørende DOSBox. 
     Default, vil serveren acceptere forbindelser på UDP port 213, selvom dette kan 
     ændres. DOSBox opretter automatisk en klient-forbindelse til IPX 
     kanaliseringsserveren når denne er startet.

     Syntaxen for IPXNET STARTSERVER er:
     IPXNET STARTSERVER <port>

    Hvis serveren er bag en router skal UDP port <port> videresendes til den computer.

     På Linux/Unix-based systemer kan port numbers lavere end 1023 kun bruges med 
     root privilegier. Brug porte højere end 1023 på disse systemer.

  IPXNET STOPSERVER

     IPXNET STOPSERVER stopper the IPX kanaliserings-sreveren som er kører på nuværende
     DOSBox. Man bør forsikre sig om at alle andre forbindelser til også er af-
     sluttet, da nedlukning af serveren kan være skyld i lockups/frysninge på andre 
     maskiner som stadig benytter IPX kanaliserings-serveren. 

     The syntax for IPXNET STOPSERVER is: 
     IPXNET STOPSERVER 

  IPXNET PING

     IPXNET PING rundsender en ping forespørgsel på det IPX kanaliserede netværk.
     Til svar vil alle de tilsluttede computere rapportere tiden det tog at sende 
     og modtage ping forespørgslen. 

     The syntax for IPXNET PING is: 
     IPXNET PING

  IPXNET STATUS

     IPXNET STATUS rapporterer statusr på nuværende DOSBox's IPX kanaliserede 
     netværk. Hvis du vil have en liste over alle computere tilsluttet netværket,
     brug IPXNET PING kommandoen. 

     Syntaxen for IPXNET STATUS er: 
     IPXNET STATUS 


KEYB [Sprogkode [kodeside [kodesidefil]]]
  Ændrer keyboard layoutet.Vær venlig at se side 7, hvis du ønsker detaljeret 
  informationom om atstatur layouts.

  [Sprogkode] er en streng bestående af 2 bogstaver (i specielle tilfælde flere),
  nogle eksempler er : GK (Greece),  IT (Italy) eller DK (danmark). Den specificerer
  hvilket keyboard/tastatur layout der skal bruges.

  [kodeside] er nummeret på kodesiden der skal brugess. Keyboard/tastatur layoutet 
  skal give understøttelse for den specificerede kodeside, ellers kan layoutet ikke 
  indlæses. Hvis der ikke er angivet nogen kodeside, bliver der automatisk valgt 
  en passende kodeside for det ønskede layout.

  [kodesidefil] kan bruges til at indlæse kodesider som endnu ikke er indbyggede i 
   DOSBox. Det bruges kun når DOSBox ikke kan finde kodesiden.


  Eksempler:
  1) At indlæse det tyske Keyboard/tastatur layout (bruger automatisk kodeside 858):
       keyb gr
  2) At indlæse det russiske Keyboard/tastatur layout med kodeside 866:
       keyb ru 866
     For at kunne skrive russiske bogstaver tast ALT+RIGHT-SHIFT.
  3) At indlæse det franske Keyboard/tastatur layout med kodeside 850 (hvor kode-
      siden er defineret i filen EGACPI.DAT):
       keyb fr 850 EGACPI.DAT
  4) Atindlæse kodeside 858 (uden keyboard/tastatur layout):
       keyb none 858
     Dette kan bruges til at ændre kodesiden for freedos's keyb2 program.



Hvis du vil vide mere, brug /? efter (program)kommandoen.




====================
5. Specielle taster:
====================

ALT-ENTER     Fuldskærm til/fra.
ALT-PAUSE     Pause DOSBox.
CTRL-F1       Starter the keymapper.
CTRL-F4       Skifter imellem monterede disk-images. Opdaterer 
              directory-/mappe-/bibliotek-lageret for alle drev!
CTRL-ALT-F5   Starter/Stopper optagelse af film af skærmbillede. (avi video optagelse)
CTRL-F5       Gemmer et skærmbillede. (png)
CTRL-F6       Starter/Stopper optagelse af lyd til en wave file.
CTRL-ALT-F7   Starter/Stopper optagelse af OPL kommandoer.
CTRL-ALT-F8   Starter/Stopper optagelse af rå MIDI kommandoer.
CTRL-F7       Formindske tab af frames/rammer.
CTRL-F8       Forstørre tab af frames/rammer.
CTRL-F9       Slukke dosbox.
CTRL-F10      Binde/frigøre musen.
CTRL-F11      Sløve emularingen (Nedsætte DOSBox Cycles).
CTRL-F12      Sætte mere fart på emuleringen (Øge DOSBox Cycles).
ALT-F12       Frigøre hastighed (turbo knap).

Sådan er default tastebindinger. De kan ændres med keymapper.

Gemte indspillede filer kan findes can be found in nuværende_directory/capture 
(kan ændres i Config-filen). 
Hvis Directoriet/mappen/biblioteket ikke eksisterer inden du starter DOSBox, 
bliver der ikke gemt/optaget noget!


NOTA: Hvis du øger DOSSBox's cycles over computerens maximum ydeevne, vil det give 
samme virkning som at sløve emuleringen.
Maximum varierer fra computer to computer.



===============================================
6. Mapper (Tastatur og joystick indstillinger):
===============================================

Når du starter the DOSBox mapper (enten med CTRL-F1 eller med -startmapper
som kommandolinieargument) bliver du presenteret for et virtuelt 
keyboard/tastatur og et virtualt joystick.

Disse virtuelle enheder reagere på tasterne/knapperne som DOSBox videresender til
DOS programmer. Hvis du klikker på en tast/knap med din mus, kan du se nederst
i venstre hjørne, hvilken funktion den er bundet til (EVENT) og hvilke funktioner
der lige nu er bundet.

Event: EVENT
BIND: BIND
                        Add   Del
mod1  hold                    Next
mod2
mod3


EVENT
    Tasten eller joystick akse/knap/hat DOSBox videresender til DOS program/spil.
BIND
    Knappen på dir fyssike keyboard/tastatur eller akse/knap/hat på dit/dine fy-
    siske joystick(s) (som meddelt af SDL) som er bundet til EVENT(en).
mod1,2,3 
    Modfiers. Dette er taster du skal have nedtrykkede imens du taster BIND. 
    mod1 = CTRL og mod2 = ALT. Disse bliver generelt kun brugt når du ønsker at 
    ændre DOSBox's specielle taster.
Add 
    Tilføjer en ny BIND til denne EVENT. Tilføjer grundlæggende en tast fra dit 
    keyboard/tastatur eller en funktion joysticket (trykket knap, akse/hat bevæ-
    gelse) dette skaber en EVENT(handling) i DOSBox.
Del 
    Sletter denne  EVENT's BIND. Hvis en EVENT ingen BINDS har, er det ikke muligt 
    at udløse den i DOSBox (man kan ikke udløse tasten eller joystick-funktionen).
Next
    Gennemgå listen over bindinger som leder til denne EVENT.


Eksempel:
Q1. Du ønsker at X'et på dit keyboard/tastatur skriver Z i DOSBox.
    A. Klik på Z'et i keyboard mapper. klik "Add". 
       tryk nu x tasten på dit keyboard/tastatur. 

Q2. Hvis du klikker "Next" et par gange, vil du bemærke es, at Z'et på dit 
    keyboard/tastatur også laver et Z i DOSBox.
    A. Derfor skal du vælge Z igen, og vælge "Next" til du har Z på dit
    keyboard. Vælg nu "Del".

Q3. Hvis du prøver det i DOSBox, vil du bemærke at når du taster X kommer ZX
    frem.
     A. X'et på dit keyboard/tastatur er også stadig kortlagt til X! Klik på
        X'et i keyboard mapper og søg med "Next" til du finder den kortlagte
        X tast. Klik "Del".


Eksempler på at omprogramere joysticket:
  Du har et joystick tilsluttet, det virker fint i DOSBox og du ønsker at spille
  et kun-for-keyboard/tastatur spil med joysticket (det formodes at spillet
  kontrolleres med piletasterne på keyboardet/tastaturet):
    1) Start mapper, klik så på en af pilene i midten af venstre side af skærmen
       (lige over Mod1/Mod2 knapperne).
       EVENT skal være key_left. Klik nu på Add og flyt dit joystick i samme ret-
       ning(som pilen peger), dette skulle tilføje en handling til BIND.
    2) Gentag ovenstående for de sidste 3 retninger, i tilføjelse kan knapperne
       på joysticket også omprogrameres (fire/jump).
    3) Kilk på Save, så på Exit og test det med et spil.

  Hvis du ønsker at ændre y-aksen på joysticket fordi nogle flysimulatorer bruger
  joystickens op/ned  bevægelse på en mådedu ikke kan lide, og det ikke kan ind-
  stilles i selve spillet:
    1) Start mapper og klik på Y- i det øvre joystick felt (dette er for det første 
       joystick hvis du har to joysticks tilsluttet) eller det nedre joystick 
       felt (andet joystick eller, hvis du kun har et joystick tilsluttet, anden akses kryds).
       EVENT skulle være jaxis_0_1- (eller jaxis_1_1-).
    2) Klik på Del for at fjerne nuværende binding, klik så på Add og flyt dit
       joystick nedad. der skulle nu være  skabt et nyt bind.
    3) Gentag dette for Y+, gem layoutet og test det til slut i et spil.



Hvis du ændrer default mapping, kan du gemme dine ændringer ved at klikke på
"Save". DOSBox gemmer din mapping til en lokalitet specificeret i config-filen
(mapperfile=mapper.txt). DOSBox indlæser din mapperfile, hvis den er tilstede i
config-filen.



===================
7. Keyboard Layout:
===================

For at skifte til et andet keyboard/tastatur layout, kan bruges enten punktet
"keyboardlayout" i [dos]-sektionen i dosbox.conf, eller det interne DOSBox
program keyb.com. Begge dele accepterer dos-afpassede sprog koder (se nedenunder), 
men du kan kun indlæse ne sprogkode-fil med keyb.com.

Skiftning af Layout
  DOSBox understøtter default et vist antal keyboard/tastatur layouts  og kode-
  sider,i disse tilfælde er det kun nødvendigt at specificere sprogkoden (som f.eks
  keyboardlayout=sv i DOSBox's config-fil, eller "keyb sv" ved DOSBox's kommando
  prompt).
  
  Nogle keyboard/tastatur layouts (f.eks sprogkode GK kodeside 869 og sprogkode RU
  kodeside 808) har understøttelse for dobbelt-layouts som kan aktiveres med
  tasterne LEFT-ALT+RIGHT-SHIFT og deaktiveres med tasterne LEFT-ALT+LEFT-SHIFT.

Understøttede eksterne filer
  The freedos .kl filer er understøttede (freedos keyb2 keyboard layoutfiles) 
  ligesom the freedos keyboard.sys/keybrd2.sys/keybrd3.sys bibliotekerne som 
  består af alle tilgængelige .kl filer.
  Se på http://projects.freedos.net/keyb/ for prækompilereded keyboard layouts
  hvis de DOSBosx-integrerede layouts, af en eller anden grund ikke virker, er 
  opdaterede eller, der er nye tilgængelige. 

  Både .CPI (MSDOS/kompatible kodeside filer) og .CPX (freedos UPX-komprimerede
  kodeside filer) kan bruges. Nogle kodesider er indbygget i DOSBox så det for 
  det meste ikke er nødvendigt at tænke på kodeside filer. Hvis du har brug for 
  en anden (eller en specielt tilpasset) kodeside fil, kan du kopiere den ind i
  Directoriet/mappen/biblioteket hvor DOSBox config-fil er så DOSBox kan finde den.

  Yderligere layouts kan tilføjes ved at kopiere de tilsvarende .kl-file til
  dosbox.conf's directory/mappe/bibliotek og bruge første del af fil-navnet som
  sprog-kode.
  Eksempel: For filen UZ.KL (keyboard/tastatur layout for Uzbekistan) specificeres
           "keyboardlayout=uz" i dosbox.conf.
  Integreringen af keyboard layout pakker (som keybrd2.sys) virker på samme måde.


Læg mærke til at keyboard/tastatur layoutet tillader udenlandske karaktérer at 
blive skrevet, men der er ikke understøttelse for dem i filnavne. Prøv at undgå 
at undgå dem(tegnene) både i DOSBox og det værts operativ system som er til gængeligt
fra DOSBox.



==============================
8. Serial Multiplayer feature:
==============================
 
DOSBox kan emulere et serialt nullmodem kabel over netværk og internet.
Dette kan konfigureres i [serialports] sektionen i DOSBox's Config-fil.

For at oprette en nullmodem forbindelse, skal én være server og én klient.

Serveren skal sættes sådan op i DOSBox's config-fil:
   serial1=nullmodem

Klient:
   serial1=nullmodem server:<IP eller navn på serveren>

Start nu spillet og vælg nullmodem / serial cable / already connected
som multiplayer måde på COM1. Set same baudrate på begge computere.

Desuden, kan der tilføjes yderligere parametreameters for at kontrollere opfør-
slen af nullmodem forbindelsen. Dette er alle parametrene:

 * port:         - TCP port nummer. Default: 23
 * rxdelay:      - hvor længe (millisekunder) de modtagne data skal forsinkes hvis
                   enheden ikke er klar. Forøg denne værdi hvis du oplever
                   overrun errors i DOSBox's Status vindue. Default: 100
 * txdelay:      - hvor længe der skal samles data før der sendes en pakke. 
                   Default: 12 (reducerer Netværk overhovede)
 * server:       - Dette nullmodem vil være en klient som tilslutter til den spe-
                   cificerede server. (ingen server argument: vær en server.)
 * transparent:1 - Sender kun de serielle data, ingen RTS/DTR handshake. Bruges
                   når der tilsluttes til alt andet end et nullmodem.
 * telnet:1      - Oversætter Telnet data fra et andet sted(tilsluttet). Gøres
                   automatisk gennemsigtigt.
 * usedtr:1      - Forbindelsen bliver ikke lavet før DTR bliver slået til af
                   DOS programmet. Bruges med modem terminaler.
                   Gøres automatisk gennemsigtigt.
 * inhsocket:1   - Brug en sokkel sendt til DOSBox ad kommandolinien. Gøres
                   automatisk gennemsigtigt. (Sockel Arv: Det bruges til at spille
                   gamle DOS door games på ny BBS software.)

Eksempel: Vær en server der lytter på TCP port 5000.
   serial1=nullmodem server:<IP eller navn på serveren> port:5000 rxdelay:1000



=======================================
9.Hvordan resource-krævende spil køres: 
=======================================

DOSBox emulerer CPUen, lyd- og grafik- kort , og andre dele af PCen, det hele
på samme tid. Hastigheden på den emulerede DOS applikation afhænger af hvor
mange instruktioner der kan emuleres, kan justeres(antal cycles).

CPU Cycles
  Default prøver DOSBox (cycles=auto) at detectere om et spil har brug for, at 
  blive kørt med så mange instruktioner emuleret per tids-interval som muligt.
  Man kan tvinge opførsel igennem ved at sætte cycles=max i DOSBox's config-fil. 
  DOSBox's vindue viser i så fald linien "Cpu Cyles: max", øverst. I denne tilstand 
  kan man mindske antallet af cycles på procent-basis (hit CTRL-F11), eller hæv 
  dem igen (CTRL-F12).
  
  Sometider giver det bedre resultat at tilpasse antallet af cycles, in DOSBox's
  config-fil skriv for eksempel cycles=30000. Når du kører et program/spil kan du 
  så hæve antallet af cycles med CTRL-F12 yderligere, men du er begrænset af hvor 
  meget ledig tid din rigtige CPU har. Du kan se hvor meget fri tid din CPU har,
  i Task manager i Windows 2000/XP og System Monitor i Windows 95/98/ME. Når
  Der er brugt 100% af din rigtige CPU tid, er der ikke yderligere muligheder for
  at hæve hastigheden på DOSBox, medmindre du reducerer den indlæsning som bliver 
  genereret af ikke-CPU delene af DOSBox. 

CPU Kerner(Cores)
  På x86 architecturer kan du prøve at tvinge brugen af "dynamisk genindsamlings 
  kerne" (sæt core=dynamic i DOSBox's konfigurations fil).
  Dette giver normalt bedre resultater, hvis auto genkendeklsen (core=auto) fejler.
  Indstillingen fungerer bedst sammen med cycles=max. Der kan dog være spil som 
  virker dårligere med "dynamisk genindsamlings kerne" indstillingen, eller slet ikke!

Grafik emulering
  VGA emulering er en meget krævende del af DOSBox's reelle CPU forbrug. Du kan 
  forstørre tabet af antal rammer/frames der skippes (forøges med tallet et) ved
  at nedtrykke tasterne CTRL-F8. Dit CPU forbrug skulle formindskes når du bruger
  en fast "cycles" indstilling.
  Gå et skridt tilbage og gentag dette indtil spillet kører hurtigt nok.
  Læg dog mærke til at dette er et kompromis : du mister tilsvarende kvalitet i 
  billede som du vinder hastighed.

Lyd emulering
  Du kan også prøve at slå lyden fra i spillets setup program for at reducere
  CPU forbruget yderligere. indstillingen nosound=true slår IKKE emuleringen af 
  lydenhederfra, det er kun lyd-outputet der bliver slået fra.

Prøv også at lukke alle andre programmer for at reservere så mange resourcer som
muligt til DOSBox.


Advanced cycles configuration:
Cycles=auto og cycles=max indstillingerne kan sættes med andre parametre 
for forskellige start defaults. Syntaksen er
  cycles=auto ["realmode default"] ["protected mode default"%] 
              [limit "cycle begrænsning"]
  cycles=max ["protected mode default"%] [limit "cycle begrænsning"]
Eksempel:
  cycles=auto 1000 80% limit 20000
  bruger cycles=1000 for real mode spil, 80% cpu effekt for 
  protected mode spil sammen med en hård cycle begrænsning på 20000



====================
10. Problemløsning:
====================

DOSBox dør lige efter start:
  - brug andre værdier i output= indstillingen i din DOSBox
    config-fil
  - prøv at opdatere grafikkort-driver og DirectX

Når du kører et bestemt spil lukker DOSBox, med en/flere besked(er) eller hænger:
  - se om det virker med default DOSBox installation
    (uændret config-fil)
  - prøv uden lyd (brug det lydindstillingsprogram som er med spillet, endvidere
    kan du prøve sbtype=none and gus=false)
  - lav om på nogle af indstillingerne i DOSBox's config-fil, prøv specielt :
      core=normal
      faste cycles (for eksempel cycles=10000)
      ems=false
      xms=false
    eller en kombination af ovenstående
  - brug loadfix før du starter spillet 

Spillet går tilbage til DOSBox's kommandoprompt med fejlmeddelelse:
  - læs fejlmeddelelsen koncentreret og prøv at lokalisere fejlen
  - prøv fiduserne i ovennævnte sektioner
  - monter anderledes da nogle spil er fintfølende med lokaliteterne,
    prøv for eksempel hvis du har monteret d d:\Gamlespil\spil"
    "mount c d:\Gamlespil\spil" istedet "mount c d:\Gamlespil"
  - hvis spillet kræver cdrom, vær sikker på at du skrev "-t cdrom" da du
    monterede og prøv forskellige andre parametre
  - Tjek filerne til spillet's tilladelser (fjern read-only attributter,
    tilføj skrivetilladelser og lgn.)
  - prøv at geninstallerre spillet i selve dosbox

=====================================
11. Config-filen (indstillingsfilen):
=====================================

Der kan genereres en config-fil med CONFIG.COM, som kan findes på det interne
dosbox Z: drev når hvor du starter dosbox. Se i sektionen om interne programmer
af denne readme hvordan du bruger CONFIG.COM.
Du kan tilrette den genererede config-fil til dit DOSBox behov.

Filen er inddelt i flere sektioner (der er [] om navnene). 
I nogle sektioner er der muligheder du kan indstille.
# og % indicate kommentar-linier. 
Den genererede config-fil indeholder de nuværende indstillinger. Du kan ændre 
dem og starte DOSBox med -conf switchen for at indlæse filen og bruge de 
ændrede indstillinger.

DOSBox bruger kigger først efter indstillingerne i ~/.dosboxrc (Linux),
~\dosbox.conf (Win32) eller "~/Library/Preferences/DOSBox Preferences"
(MACOSX). Derefter vil DOSBox gennemse alle config-filer specificeret med -conf 
switchen. Hvis der ingen cnfig-fil er specificeret med -conf switchen, ser
DOSBox i det/den nuværende directory/mappe/bibliotek efter dosbox.conf.



================
12. Sprog-filen:
================

Der kan genereres en Sprog-file med CONFIG.COM. 
Læs den, så forstår du forhåbentligt hvordan man ændrer den. 
Start med DOSBox -lang switchen og indlæs din sprog-fil.
Du kan alternativt indføre filenavnet i config-filen i [dosbox] Sektionen. 
Der er en language= indstilling der kan ændres med et filenavn.



=================================================
13. Hvordan du bygger din egen version af DOSBox:
=================================================

Download kildefilerne (source).
Læs INSTALL i  kilde-distributionen.



===================
14. Special thanks:
===================

Se the THANKS filen.


============
15. Kontakt:
============

See the site: 
http://dosbox.sourceforge.net
for an email address (The Crew-page).
