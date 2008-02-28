unit SimpleXMLUnit;
interface

uses Classes;

Type TSimpleXMLFileStyle=(sxfsDOG, sxfsDBGL);

Function WriteProfilesToXML(const GamesList : TList; const FileName : String; const FileStyle : TSimpleXMLFileStyle) : Boolean;

implementation

uses SysUtils, Math, GameDBUnit, CommonTools, PrgSetupUnit, DOSBoxUnit;

Procedure WriteProfilesToDOGXML(const St : TStringList; const GamesList : TList);
Var I,J,K : Integer;
    G : TGame;
    St2 : TStringList;
    S : String;
begin
  St.Add('<Document>');
  St.Add('<Export>');
  St.Add('<Version>1.0</Version>');
  St.Add('<Generator>D.O.G.</Generator>');
  St.Add('<RealGenerator>D-Fend Reloaded '+GetNormalFileVersionAsString+'</RealGenerator>');
  St.Add('</Export>');

  For I:=0 to GamesList.Count-1 do begin
    G:=TGame(GamesList[I]);

    St.Add('');
    St.Add('<Profile>');

    St.Add('  <Emulator>');
    St.Add('    <Type>DOSBox</Type>');
    St.Add('    <Version>0.72</Version>');
    If G.CustomDOSBoxDir='' then begin
      St.Add('    <Path>'+IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.DosBoxDir,PrgSetup.BaseDir))+'DOSBox.exe</Path>');
      St.Add('    <Name>DOSBox 0.72</Name>');
    end else begin
      St.Add('    <Path>'+IncludeTrailingPathDelimiter(MakeAbsPath(G.CustomDOSBoxDir,PrgSetup.BaseDir))+'DOSBox.exe</Path>');
      St.Add('    <Name>DOSBox 0.72 (Custom build)</Name>');
    end;
    St.Add('    <Configuration>');

    St.Add('      <Glide>0</Glide>');
    St.Add('      <Innovation>0</Innovation>');
    St.Add('      <MT32SoundQuality>0</MT32SoundQuality>');
    St.Add('      <OverScan>0</OverScan>');
    St.Add('      <VGAChipSet>0</VGAChipSet>');
    St.Add('      <VSync>0</VSync>');
    St.Add('      <Printer>0</Printer>');
    St.Add('      <Pixelshader>0</Pixelshader>');
    St.Add('      <Scalers>');
    St.Add('       <Display>"No Scaler","Normal 2x","Normal 3x","Advanced MAME 2x","Advanced MAME 3x","High-Quality 2x Magnification","High-Quality 3x Magnification","Scale and Interpolation 2x","Super Scale and Interpolation 2x","Super Eagle",'+'"Advanced Interpolation 2x","Advanced Interpolation 3x","TV Interlacing 2x","TV Interlacing 3x","RGB 2x","RGB 3x","Scan 2x","Scan 3x"</Display>');
    St.Add('       <Values>none,normal2x,normal3x,advmame2x,advmame3x,hq2x,hq3x,sai2x,super2xsai,supereagle,advinterp2x,advinterp3x,tv2x,tv3x,rgb2x,rgb3x,scan2x,scan3x</Values>');
    St.Add('      </Scalers>');
    St.Add('      <OutputDevices>');
    St.Add('       <Display>Surface,Overlay,OpenGL,"OpenGL NB","Direct Draw"</Display>');
    St.Add('       <Values>surface,overlay,opengl,openglnb,ddraw</Values>');
    St.Add('      </OutputDevices>');
    St.Add('      <Machines>');
    St.Add('       <Display>Hercules,CGA,Tandy,"IBM PCjr",VGA</Display>');
    St.Add('       <Values>hercules,cga,tandy,pcjr,vga</Values>');
    St.Add('      </Machines>');
    St.Add('      <Memory>');
    St.Add('       <Display>1MB,2MB,4MB,8MB,16MB,24MB,32MB,63MB</Display>');
    St.Add('       <Values>1,2,4,8,16,24,32,63</Values>');
    St.Add('      </Memory>');
    St.Add('      <Core>');
    St.Add('       <Display>Auto,Normal,Full,Dynamic</Display>');
    St.Add('       <Values>auto,normal,full,dynamic</Values>');
    St.Add('      </Core>');
    St.Add('      <JoystickType>');
    St.Add('       <Display>None,"2 axis","4 axis",Thrustmaster,Flightstick,Auto</Display>');
    St.Add('       <Values>none,2axis,4axis,fcs,ch,auto</Values>');
    St.Add('      </JoystickType>');
    St.Add('      <SoundQuality>');
    St.Add('       <Display>"8000 Hz","11025 Hz","22050 Hz","32000 Hz","44100 Hz"</Display>');
    St.Add('       <Values>8000,11025,22050,32000,44100</Values>');
    St.Add('      </SoundQuality>');
    St.Add('      <VGAChipset>');
    St.Add('       <Display>None,"Paradise PVGA1A","Tseng Labs ET3000","New Tseng Labs ET4000","Tseng Labs ET4000",S3</Display>');
    St.Add('       <Values>none,pvga1a,et3000,et4000new,et4000,s3</Values>');
    St.Add('      </VGAChipset>');
    St.Add('      <Pixelshader>');
    St.Add('       <Display>None,"Point Shader","Bilinear Shader","Scale 2x Shader","Sai 2x Shader"</Display>');
    St.Add('       <Values>none,point.fx,bilinear.fx,scale2x.fx,2xsai.fx</Values>');
    St.Add('      </Pixelshader>');
    St.Add('      <VSyncMode>');
    St.Add('       <Display>Off,On,Force,Host</Display>');
    St.Add('       <Values>off,on,force,host</Values>');
    St.Add('      </VSyncMode>');
    St.Add('      <VSyncRate>');
    St.Add('       <Display>60,65,70,75,80</Display>');
    St.Add('       <Values>60,65,70,75,80</Values>');
    St.Add('      </VSyncRate>');
    St.Add('      <PrintOutput>');
    St.Add('       <Display>"Bitmap Image","PNG Image","Postscript Document",Printer</Display>');
    St.Add('       <Values>bmp,png,ps,printer</Values>');
    St.Add('      </PrintOutput>');
    St.Add('      <PrinterDPIList>');
    St.Add('       <Display>300,360,600,800,1200,2400</Display>');
    St.Add('       <Values>300,300,600,800,1200,2400</Values>');
    St.Add('      </PrinterDPIList>');
    St.Add('      <InnovationQuality>');
    St.Add('       <Display>"Very Low",Low,Medium,High</Display>');
    St.Add('       <Values>0,1,2,3</Values>');
    St.Add('      </InnovationQuality>');
    St.Add('      <FullResolutions>');
    St.Add('       <Display>"Original Resolution",320x200,320x240,400x300,512x384,640x400,640x480,800x480,800x600,1024x480,1024x600,1024x768,1152x864,1280x600,1280x768,1280x1024,1400x1050,1600x1200,1792x1344,1800x1440,1920x1080,1920x1200,1920x1440,2048x1536</Display>');
    St.Add('       <Values>original,320x200,320x240,400x300,512x384,640x400,640x480,800x480,800x600,1024x480,1024x600,1024x768,1152x864,1280x600,1280x768,1280x1024,1400x1050,1600x1200,1792x1344,1800x1440,1920x1080,1920x1200,1920x1440,2048x1536</Values>');
    St.Add('      </FullResolutions>');
    St.Add('      <WindowResolutions>');
    St.Add('       <Display>"Original Resolution",320x200,320x240,400x300,512x384,640x400,640x480,800x480,800x600,1024x480,1024x600,1024x768,1152x864,1280x600,1280x768,1280x1024,1400x1050,1600x1200,1792x1344,1800x1440,1920x1080,1920x1200,1920x1440,2048x1536</Display>');
    St.Add('       <Values>original,320x200,320x240,400x300,512x384,640x400,640x480,800x480,800x600,1024x480,1024x600,1024x768,1152x864,1280x600,1280x768,1280x1024,1400x1050,1600x1200,1792x1344,1800x1440,1920x1080,1920x1200,1920x1440,2048x1536</Values>');
    St.Add('      </WindowResolutions>}');
    St.Add('    </Configuration>');
    St.Add('  </Emulator>');
    St.Add('  <Configuration>');
    St.Add('    <Information>');
    St.Add('      <Name>'+G.Name+'</Name>');
    S:=Trim(G.GameExe); If Copy(S,1,2)='.\' then S:='&lt;DOGDRIVE&gt;'+Copy(S,3,MaxInt);
    St.Add('      <ExeFilename>'+S+'</ExeFilename>');
    S:=Trim(G.SetupExe); If Copy(S,1,2)='.\' then S:='&lt;DOGDRIVE&gt;'+Copy(S,3,MaxInt);
    St.Add('      <SetupFilename>'+S+'</SetupFilename>');
    St.Add('      <EXECommandLine>'+G.GameParameters+'</EXECommandLine>');
    St.Add('      <SetupCommandLine>'+G.SetupParameters+'</SetupCommandLine>');
    St.Add('      <ExeStartDrive>Z</ExeStartDrive>');
    St.Add('      <SetupStartDrive>Z</SetupStartDrive>');
    St.Add('      <Develloper>'+G.Developer+'</Develloper>');
    St.Add('      <Developer>'+G.Developer+'</Developer>');
    St.Add('      <Publisher>'+G.Publisher+'</Publisher>');
    St.Add('      <Genre>'+G.Genre+'</Genre>');
    St.Add('      <Year>'+G.Year+'</Year>');
    St.Add('      <Working>1</Working>');
    St.Add('      <ConfFile>&lt;DOGHOME&gt;confs\'+ExtractFileName(G.SetupFile)+'</ConfFile>');
    St.Add('      <ProfileFile></ProfileFile>');
    St.Add('      <Language>'+G.Language+'</Language>');
    St.Add('      <Icon>'+G.Icon+'</Icon>');
    St.Add('      <Note>');
    St2:=StringToStringList(G.Notes);
    try If St2.Count>0 then begin St2[0]:='      <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('      </Note>');
    St.Add('      <CustomInformation>');
    St2:=StringToStringList(G.UserInfo);
    try
      For J:=0 to St2.Count-1 do begin
        S:=St2[J]; K:=Pos('=',S);
        If K=0 then begin
          St.Add('<Title'+IntToStr(K)+'></Title'+IntToStr(K)+'>');
          St.Add('<Custom0'+IntToStr(K)+'>'+S+'</Custom0'+IntToStr(K)+'>');
        end else begin
          St.Add('<Title'+IntToStr(K)+'>'+Copy(S,1,K-1)+'</Title'+IntToStr(K)+'>');
          St.Add('<Custom0'+IntToStr(K)+'>'+Copy(S,K+1,MaxInt)+'</Custom0'+IntToStr(K)+'>');
        end;
      end;
    finally
      St2.Free;
    end;
    St.Add('      </CustomInformation>');
    St.Add('      <LinkedFiles>');
    If Trim(G.WWW)<>'' then begin
       St.Add('        <Title0>WWW</Title0>');
       St.Add('      <Link0>'+G.WWW+'</Link0>');
    end;
    St.Add('      </LinkedFiles>');
    St.Add('    </Information>');
    St.Add('    <Settings>');
    St.Add('      <Full-Configuration>');
    St2:=BuildConfFile(G,False,False);
    try If St2.Count>0 then begin St2[0]:='      <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('      </Full-Configuration>');
    St.Add('      <Manual-Configuration>');
    St2:=StringToStringList(G.CustomSettings);
    try If St2.Count>0 then begin St2[0]:='      <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('      </Manual-Configuration>');
    St.Add('      <Manual-AutoExec>');
    St.Add('      <![CDATA[#INITIALIZATION');
    St2:=StringToStringList(G.Notes);
    try St.AddStrings(St2); finally St2.Free; end;
    St.Add('#FINALIZATION]]>');
    St.Add('      </Manual-AutoExec>');
    St.Add('      <Addons>');
    St.Add('        <DOS32A>');
    If G.UseDOS32A then St.Add('          <Used>1</Used>') else St.Add('          <Used>0</Used>');
    St.Add('        </DOS32A>');
    St.Add('        <i4DOS>');
    If G.Use4DOS then St.Add('          <Used>1</Used>') else St.Add('          <Used>0</Used>');
    St.Add('        </i4DOS>');
    St.Add('        <CWSDPMI>');
    St.Add('          <Used>0</Used>');
    St.Add('          <SwapFile>0</SwapFile>');
    St.Add('          <DPMI10>0</DPMI10>');
    St.Add('        </CWSDPMI>');
    St.Add('        <Mouse>');
    If G.AutoLockMouse then St.Add('          <AutoLock>1</AutoLock>') else St.Add('          <AutoLock>0</AutoLock>');
    St.Add('        </Mouse>');
    St.Add('        <Screen>');
    St.Add('          <RenderFix>0</RenderFix>');
    St.Add('        </Screen>');
    St.Add('      </Addons>');
    St.Add('    </Settings>');
    St.Add('    <AttachedFiles/>');
    St.Add('    <DataFiles/>');
    St.Add('  </Configuration>');
    St.Add('</Profile>');
  end;

  St.Add('</Document>');
end;

Procedure WriteProfilesToDBGLXML(const St : TStringList; const GamesList : TList);
Var I,J : Integer;
    G : TGame;
    S : String;
    St2 : TStringList;
begin
  St.Add('<profiles>');
  St.Add('<export>');
  St.Add('<format-version>1.0</format-version>');
  St.Add('<title>D-Fend exported games</title>');
  If GamesList.Count>0 then S:=TGame(GamesList[0]).Name;
  For I:=1 to GamesList.Count-1 do S:=S+', '+TGame(GamesList[I]).Name;
  St.Add('<notes><![CDATA['+S+']]></notes>');
  St.Add('<generator-title>DOSBox Game Launcher</generator-title>');
  St.Add('<generator-version>0.62</generator-version>');
  St.Add('<RealGenerator>D-Fend Reloaded '+GetNormalFileVersionAsString+'</RealGenerator>');
  St.Add('<captures-available>false</captures-available>');
  St.Add('<gamedata-available>false</gamedata-available>');
  St.Add('</export>');

  For I:=0 to GamesList.Count-1 do begin
    G:=TGame(GamesList[I]);

    St.Add('');
    St.Add('<Profile>');
    St.Add('  <title>'+G.Name+'</title>');
    St.Add('  <meta-info>');

    St.Add('    <developer>'+G.Developer+'</developer>');
    St.Add('    <publisher>'+G.Publisher+'</publisher>');
    St.Add('    <year>'+G.Year+'</year>');
    St.Add('    <genre>'+G.Genre+'</genre>');
    St.Add('    <status></status>');
    St.Add('    <ConfFile>&lt;DOGHOME&gt;confs\'+ExtractFileName(G.SetupFile)+'</ConfFile>');
    St.Add('      <ProfileFile></ProfileFile>');
    St.Add('      <Language>'+G.Language+'</Language>');
    St.Add('      <notes>');
    St2:=StringToStringList(G.Notes);
    try If St2.Count>0 then begin St2[0]:='      <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('      </notes>');
    St2:=StringToStringList(G.UserInfo);
    try
      For J:=0 to Min(St2.Count,10)-1 do
        St.Add('      <custom'+IntToStr(J)+'>'+St2[J]+'</custom'+IntToStr(J)+'>');
    finally
      St2.Free;
    end;
    St.Add('    <link1>'+G.WWW+'</link1>');
    St.Add('    <link2></link2>');
    St.Add('    <link3></link3>');
    St.Add('    <link4></link4>');
    St.Add('  </meta-info>');
    St.Add('  <full-configuration>');
    St2:=BuildConfFile(G,False,False);
    try If St2.Count>0 then begin St2[0]:='    <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('  </full-configuration>');
    St.Add('  <incremental-configuration>');
    St2:=BuildConfFile(G,False,False);
    try If St2.Count>0 then begin St2[0]:='    <![CDATA['+St2[0]; St2.Add(']]>'); end; St.AddStrings(St2); finally St2.Free; end;
    St.Add('  </incremental-configuration>');
    St.Add('  <dosbox>');
    St.Add('    <title>DOSBox v0.72</title>');
    St.Add('    <version>0.72</version>');
    St.Add('    <captures>'+G.CaptureFolder+'</captures>');
    St.Add('    <setup></setup>');
    St.Add('    <setup-parameters></setup-parameters>');
    If G.GameExe='' then S:='' else begin
      S:=MakeRelPath(ExtractFilePath(MakeAbsPath(G.GameExe,PrgSetup.BaseDir)),PrgSetup.BaseDir);
      If Copy(S,1,2)='.\' then S:='&lt;DOGDRIVE&gt;'+Copy(S,3,MaxInt);
    end;
    St.Add('    <game-dir>'+S+'</game-dir>');
    St.Add('  </dosbox>');
    St.Add('</profile>');
  end;
  St.Add('</profiles>');
end;

Function WriteProfilesToXML(const GamesList : TList; const FileName : String; const FileStyle : TSimpleXMLFileStyle) : Boolean;
Var St : TStringList;
begin
  St:=TStringList.Create;
  try
    St.Add('<?xml version="1.0" encoding="UTF-8"?>');
    St.Add('');
    Case FileStyle of
      sxfsDOG  : WriteProfilesToDOGXML(St,GamesList);
      sxfsDBGL : WriteProfilesToDBGLXML(St,GamesList);
      else result:=false; exit;
    end;
    result:=True;
    try St.SaveToFile(FileName); except result:=False; end;
  finally
    St.Free;
  end;
end;

end.
