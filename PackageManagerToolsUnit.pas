unit PackageManagerToolsUnit;
interface

uses Windows, Classes, Menus, ComCtrls, PackageDBUnit, ChecksumScanner,
     PackageDBCacheUnit, GameDBUnit;

{Games and AutoSetups TListView}

Function GetPackageManagerToolTip(const DownloadAutoSetupData : TDownloadAutoSetupData) : String;

Type TFilterKey=(fkNoFilter,fkName,fkLicense,fkGenre,fkDeveloper,fkPublisher,fkYear,fkLanguage);

Type TFilter=record
  Key : TFilterKey;
  UpperValue : String;
end;

Procedure InitPackageManagerListView(const AListView : TListView; const AutoSetups : Boolean);
Procedure InitPackageManagerIconsListView(const AListView : TListView);
Procedure InitPackageManagerIconSetsListView(const AListView : TListView);
Procedure LoadListView(const AListView : TListView; const PackageDB : TPackageDB; const Filter : TFilter; const AutoSetupChecksumScanner : TChecksumScanner; const AutoSetups : Boolean; const GameDB, AutoSetupDB : TGameDB; const HideIfAlreadyInstalled : Boolean);
Procedure LoadIconsListView(const AListView : TListView; const PackageDB : TPackageDB; const IconChecksumScanner : TChecksumScanner; const HideIfAlreadyInstalled : Boolean);
Procedure LoadIconSetsListView(const AListView : TListView; const PackageDB : TPackageDB; HideIfAlreadyInstalled : Boolean);

Var FilterSelectLicense : TStringList = nil;
    FilterSelectGenre : TStringList = nil;
    FilterSelectDeveloper : TStringList = nil;
    FilterSelectPublisher : TStringList = nil;
    FilterSelectYear : TStringList = nil;
    FilterSelectLanguage : TStringList = nil;

procedure OpenFilterPopup(const OpenPos : TPoint; const AutoSetups : Boolean; const PopupMenu : TPopupMenu; const PackageDB : TPackageDB; const OnClick : TNotifyEvent);

{ExePackages info memo}

Function ExePackageInfo(const AObject : TObject; const PackageDBCache : TPackageDBCache) : TStringList;

implementation

uses SysUtils, IniFiles, PackageDBLanguage, PackageDBToolsUnit, CommonTools,
     LanguageSetupUnit, PrgSetupUnit, PrgConsts;

Function GetPackageManagerToolTip2(const DownloadAutoSetupData : TDownloadAutoSetupData) : String;
begin
  {Had to split this otherwise the compiler says "the return value is may not defined"}
  result:=#13+LanguageSetup.GameName+': '+GetCustomGenreName(DownloadAutoSetupData.Genre)
    +#13+LanguageSetup.GameDeveloper+': '+DownloadAutoSetupData.Developer
    +#13+LanguageSetup.GamePublisher+': '+DownloadAutoSetupData.Publisher
    +#13+LanguageSetup.GameYear+': '+DownloadAutoSetupData.Year
    +#13+LanguageSetup.GameLanguage+': '+GetCustomLanguageName(DownloadAutoSetupData.Language)
    +#13+LANG_ListDownloadSize+': '+GetNiceFileSize(DownloadAutoSetupData.Size);
end;

Function GetPackageManagerToolTip(const DownloadAutoSetupData : TDownloadAutoSetupData) : String;
begin
  result:=DownloadAutoSetupData.Name;
  If DownloadAutoSetupData is TDownloadZipData then result:=result+#13+LANG_ListLicense+': '+TDownloadZipData(DownloadAutoSetupData).License;
  result:=result+GetPackageManagerToolTip2(DownloadAutoSetupData);
end;

Procedure InitPackageManagerListView(const AListView : TListView; const AutoSetups : Boolean);
Var C : TListColumn;
begin
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameName;
  if not AutoSetups then begin C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LANG_ListLicense; end;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameGenre;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LANG_ListDownloadSize;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameDeveloper;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GamePublisher;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameYear;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameLanguage;
end;

Procedure InitPackageManagerIconsListView(const AListView : TListView);
Var C : TListColumn;
begin
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameName;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LANG_ListDownloadSize;
end;

Procedure InitPackageManagerIconSetsListView(const AListView : TListView);
Var C : TListColumn;
begin
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LanguageSetup.GameName;
  C:=AListView.Columns.Add; C.Width:=-1; C.Caption:=LANG_ListDownloadSize;
end;

Function GameAlreadyInstalled(const Data : TDownloadAutoSetupData; const GameDB : TGameDB) : Boolean;
Var I : Integer;
    S : String;
begin
  result:=True;
  S:=ExtUpperCase(Data.Name);
  For I:=0 to GameDB.Count-1 do If ExtUpperCase(GameDB[I].CacheName)=S then begin
    If (Data.GameExeChecksum<>'') and (GameDB[I].GameExeMD5<>'') then begin
      If Data.GameExeChecksum=GameDB[I].GameExeMD5 then exit;
    end else begin
      exit;
    end;
  end;
  result:=False;
end;

Procedure LoadListView(const AListView : TListView; const PackageDB : TPackageDB; const Filter : TFilter; const AutoSetupChecksumScanner : TChecksumScanner; const AutoSetups : Boolean; const GameDB, AutoSetupDB : TGameDB; const HideIfAlreadyInstalled : Boolean);
Var I,J,K : Integer;
    St : TStringList;
    Item : TListItem;
    Data : TDownloadAutoSetupData;
    S : String;
    Selected : TStringList;
begin
  Selected:=TStringList.Create;
  try
    For I:=0 to AListView.Items.Count-1 do If AListView.Items[I].Checked then Selected.Add(AListView.Items[I].Caption);

    AListView.Items.BeginUpdate;
    try
      AListView.Items.Clear;

      St:=TStringList.Create;
      try
        For I:=0 to PackageDB.Count-1 do begin
          If AutoSetups then K:=PackageDB[I].AutoSetupCount else K:=PackageDB[I].GamesCount;
          For J:=0 to K-1 do begin
            If AutoSetups then Data:=PackageDB[I].AutoSetup[J] else Data:=PackageDB[I].Game[J];
            {Already installed ?}
            If HideIfAlreadyInstalled then begin
              If AutoSetups then begin
                If AutoSetupChecksumScanner.GetChecksum(ExtractFileNameFromURL(Data.URL))=Data.PackageChecksum then continue;
                If GameAlreadyInstalled(Data,AutoSetupDB) then continue;
              end else begin
                If GameAlreadyInstalled(Data,GameDB) then continue;
              end;
            end;
            {Filter}
            Case Filter.Key of
              fkName : S:=Data.Name;
              fkLicense : S:=TDownloadZipData(Data).License;
              fkGenre : S:=Data.Genre;
              fkPublisher : S:=Data.Publisher;
              fkDeveloper : S:=Data.Developer;
              fkYear : S:=Data.Year;
              fkLanguage : S:=Data.Language;
              else S:='';
            End;
            If (Filter.Key<>fkNoFilter) and (S<>'') and (Pos(Filter.UpperValue,ExtUpperCase(S))=0) then continue;
            {Add to string list}
            If AutoSetups
              then St.AddObject(PackageDB[I].AutoSetup[J].Name,TObject(I*65536+J))
              else St.AddObject(PackageDB[I].Game[J].Name,TObject(I*65536+J));
          end;
        end;
        St.Sort;

        {Add to listview}
        For I:=0 to St.Count-1 do begin
          Item:=AListView.Items.Add;
          Item.Caption:=St[I];
          J:=Integer(St.Objects[I]) div 65536;
          K:=Integer(St.Objects[I]) mod 65536;

          If AutoSetups then begin
            Data:=PackageDB[J].AutoSetup[K];
          end else begin
            Data:=PackageDB[J].Game[K];
            Item.SubItems.Add(PackageDB[J].Game[K].License);
          end;

          Item.SubItems.Add(GetCustomGenreName(Data.Genre));
          Item.SubItems.Add(GetNiceFileSize(Data.Size));
          Item.SubItems.Add(Data.Developer);
          Item.SubItems.Add(Data.Publisher);
          Item.SubItems.Add(Data.Year);
          Item.SubItems.Add(GetCustomLanguageName(Data.Language));

          Item.Data:=Data;
        end;
      finally
        St.Free;
      end;
    finally
      AListView.Items.EndUpdate;
    end;

    for I:=0 to AListView.Items.Count-1 do AListView.Items[I].Checked:=(Selected.IndexOf(AListView.Items[I].Caption)>=0);
  finally
    Selected.Free;
  end;

  For I:=0 to AListView.Columns.Count-1 do If AListView.Items.Count>0 then begin
    AListView.Column[I].Width:=-2;
    AListView.Column[I].Width:=-1;
  end else begin
    AListView.Column[I].Width:=-2;
  end;
end;

Procedure LoadIconsListView(const AListView : TListView; const PackageDB : TPackageDB; const IconChecksumScanner : TChecksumScanner; const HideIfAlreadyInstalled : Boolean);
Var I,J,K : Integer;
    Selected,St : TStringList;
    Item : TListItem;
    Data : TDownloadIconData;
begin
  Selected:=TStringList.Create;
  try
    For I:=0 to AListView.Items.Count-1 do If AListView.Items[I].Checked then Selected.Add(AListView.Items[I].Caption);

    AListView.Items.BeginUpdate;
    try
      AListView.Items.Clear;

      St:=TStringList.Create;
      try
        For I:=0 to PackageDB.Count-1 do For J:=0 to PackageDB[I].IconCount-1 do begin
          Data:=PackageDB[I].Icon[J];
          {Already installed ?}
          If HideIfAlreadyInstalled then begin
            If IconChecksumScanner.GetChecksum(ExtractFileNameFromURL(Data.URL))=Data.PackageChecksum then continue;
          end;
          {Add to string list}
          St.AddObject(Data.Name,TObject(I*65536+J))
        end;
        St.Sort;

        {Add to listview}
        For I:=0 to St.Count-1 do begin
          Item:=AListView.Items.Add;
          Item.Caption:=St[I];
          J:=Integer(St.Objects[I]) div 65536;
          K:=Integer(St.Objects[I]) mod 65536;
          Data:=PackageDB[J].Icon[K];
          Item.SubItems.Add(GetNiceFileSize(Data.Size));
          Item.Data:=Data;
        end;
      finally
        St.Free;
      end;

    finally
      AListView.Items.EndUpdate;
    end;

    for I:=0 to AListView.Items.Count-1 do AListView.Items[I].Checked:=(Selected.IndexOf(AListView.Items[I].Caption)>=0);
  finally
    Selected.Free;
  end;

  For I:=0 to AListView.Columns.Count-1 do If AListView.Items.Count>0 then begin
    AListView.Column[I].Width:=-2;
    AListView.Column[I].Width:=-1;
  end else begin
    AListView.Column[I].Width:=-2;
  end;
end;

Function IconSetAlreadyInstalled(const Name, Version : String) : Boolean;
Var Rec : TSearchRec;
    I : Integer;
    Ini : TIniFile;
    S1,S2 : String;
begin
  result:=False;

  S1:=Trim(ExtUpperCase(Name));
  S2:=Trim(ExtUpperCase(Version));

  I:=FindFirst(PrgDataDir+IconSetsFolder+'\*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        Ini:=TIniFile.Create(PrgDataDir+IconSetsFolder+'\'+Rec.Name+'\'+IconsConfFile);
        try
          If (S1=Trim(ExtUpperCase(Ini.ReadString('Information','Name','')))) and (S2=Trim(ExtUpperCase(Ini.ReadString('Information','Version','')))) then begin
            result:=True; exit;
          end;
        finally
          Ini.Free;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure LoadIconSetsListView(const AListView : TListView; const PackageDB : TPackageDB; HideIfAlreadyInstalled : Boolean);
Var I,J,K : Integer;
    Selected : TStringList;
    St : TStringList;
    Data : TDownloadIconSetData;
    Item : TListItem;
begin
  Selected:=TStringList.Create;
  try
    For I:=0 to AListView.Items.Count-1 do If AListView.Items[I].Checked then Selected.Add(AListView.Items[I].Caption);

    AListView.Items.BeginUpdate;
    try
      AListView.Items.Clear;

      St:=TStringList.Create;
      try
        For I:=0 to PackageDB.Count-1 do For J:=0 to PackageDB[I].IconSetCount-1 do begin
          Data:=PackageDB[I].IconSet[J];
          If Data.Version<>GetNormalFileVersionAsString then continue;
          {Already installed ?}
          If HideIfAlreadyInstalled then begin
            If IconSetAlreadyInstalled(Data.Name,Data.Version) then continue;
          end;
          {Add to string list}
          St.AddObject(Data.Name,TObject(I*65536+J));
        end;
        St.Sort;

        {Add to listview}
        For I:=0 to St.Count-1 do begin
          Item:=AListView.Items.Add;
          Item.Caption:=St[I];
          J:=Integer(St.Objects[I]) div 65536;
          K:=Integer(St.Objects[I]) mod 65536;
          Data:=PackageDB[J].IconSet[K];
          Item.SubItems.Add(GetNiceFileSize(Data.Size));
          Item.Data:=Data;
        end;
      finally
        St.Free;
      end;

    finally
      AListView.Items.EndUpdate;
    end;

    for I:=0 to AListView.Items.Count-1 do AListView.Items[I].Checked:=(Selected.IndexOf(AListView.Items[I].Caption)>=0);
  finally
    Selected.Free;
  end;

  For I:=0 to AListView.Columns.Count-1 do If AListView.Items.Count>0 then begin
    AListView.Column[I].Width:=-2;
    AListView.Column[I].Width:=-1;
  end else begin
    AListView.Column[I].Width:=-2;
  end;
end;

Procedure AddSubMenuItems(const PopupMenu : TPopupMenu; const Parent : TMenuItem; const St : TStringList; const OnClick : TNotifyEvent);
Var M : TMenuItem;
    I : Integer;
begin
  For I:=0 to St.Count-1 do begin
    M:=TMenuItem.Create(PopupMenu);
    Parent.Add(M);
    M.Tag:=I;
    M.OnClick:=OnClick;
    M.Caption:=St[I];
  end;
end;

procedure OpenFilterPopup(const OpenPos : TPoint; const AutoSetups : Boolean; const PopupMenu : TPopupMenu; const PackageDB : TPackageDB; const OnClick : TNotifyEvent);
Procedure CheckAndAdd(const S : String; const ListUpper, List : TStringList); begin If ListUpper.IndexOf(ExtUpperCase(S))<0 then begin List.Add(S); ListUpper.Add(ExtUpperCase(S)); end; end;
Var I,J,K : Integer;
    FilterSelectLicenseUpper, FilterSelectGenreUpper, FilterSelectDeveloperUpper, FilterSelectPublisherUpper, FilterSelectYearUpper, FilterSelectLanguageUpper : TStringList;
    FilterSelectGenreTranslated, FilterSelectLanguageTranslated : TStringList;
    Data : TDownloadAutoSetupData;
    M : TMenuItem;
begin
  PopupMenu.Items.Clear;

  If Assigned(FilterSelectLicense) then FilterSelectLicense.Clear else FilterSelectLicense:=TStringList.Create;
  If Assigned(FilterSelectGenre) then FilterSelectGenre.Clear else FilterSelectGenre:=TStringList.Create;
  If Assigned(FilterSelectDeveloper) then FilterSelectDeveloper.Clear else FilterSelectDeveloper:=TStringList.Create;
  If Assigned(FilterSelectPublisher) then FilterSelectPublisher.Clear else FilterSelectPublisher:=TStringList.Create;
  If Assigned(FilterSelectYear) then FilterSelectYear.Clear else FilterSelectYear:=TStringList.Create;
  If Assigned(FilterSelectLanguage) then FilterSelectLanguage.Clear else FilterSelectLanguage:=TStringList.Create;

  FilterSelectLicenseUpper:=TStringList.Create;
  FilterSelectGenreUpper:=TStringList.Create;
  FilterSelectDeveloperUpper:=TStringList.Create;
  FilterSelectPublisherUpper:=TStringList.Create;
  FilterSelectYearUpper:=TStringList.Create;
  FilterSelectLanguageUpper:=TStringList.Create;
  try
    For I:=0 to PackageDB.Count-1 do begin
      If AutoSetups then K:=PackageDB[I].AutoSetupCount else K:=PackageDB[I].GamesCount;
      For J:=0 to K-1 do begin
        If AutoSetups then Data:=PackageDB[I].AutoSetup[J] else Data:=PackageDB[I].Game[J];
        If not AutoSetups then CheckAndAdd(TDownloadZipData(Data).License,FilterSelectLicenseUpper,FilterSelectLicense);
        CheckAndAdd(Data.Genre,FilterSelectGenreUpper,FilterSelectGenre);
        CheckAndAdd(Data.Developer,FilterSelectDeveloperUpper,FilterSelectDeveloper);
        CheckAndAdd(Data.Publisher,FilterSelectPublisherUpper,FilterSelectPublisher);
        CheckAndAdd(Data.Year,FilterSelectYearUpper,FilterSelectYear);
        CheckAndAdd(Data.Language,FilterSelectLanguageUpper,FilterSelectLanguage);
      end;
    end;

    FilterSelectGenreTranslated:=TStringList.Create;
    FilterSelectLanguageTranslated:=TStringList.Create;
    try

      For I:=0 to FilterSelectGenre.Count-1 do FilterSelectGenreTranslated.Add(GetCustomGenreName(FilterSelectGenre[I]));
      For I:=0 to FilterSelectLanguage.Count-1 do FilterSelectLanguageTranslated.Add(GetCustomLanguageName(FilterSelectLanguage[I]));

      If AutoSetups then PopupMenu.Tag:=1 else PopupMenu.Tag:=0;

      M:=TMenuItem.Create(PopupMenu);
      PopupMenu.Items.Add(M);
      M.Caption:=LANG_NoFilter;
      M.Tag:=-1;
      M.OnClick:=OnClick;

      M:=TMenuItem.Create(PopupMenu);
      PopupMenu.Items.Add(M);
      M.Caption:='-';

      If (not AutoSetups) and (FilterSelectLicense.Count>1) then begin
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=1;
        M.Caption:=LANG_ListLicense;
        AddSubMenuItems(PopupMenu,M,FilterSelectLicense,OnClick);
      end;

      If FilterSelectGenre.Count>1 then begin
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=2;
        M.Caption:=LanguageSetup.GameGenre;
        AddSubMenuItems(PopupMenu,M,FilterSelectGenre,OnClick);
      end;

      If FilterSelectDeveloper.Count>1 then begin
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=3;
        M.Caption:=LanguageSetup.GameDeveloper;
        AddSubMenuItems(PopupMenu,M,FilterSelectDeveloper,OnClick);
      end;

      If FilterSelectPublisher.Count>1 then begin
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=4;
        M.Caption:=LanguageSetup.GamePublisher;
        AddSubMenuItems(PopupMenu,M,FilterSelectPublisher,OnClick);
      end;

      If FilterSelectYear.Count>1 then begin
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=5;
        M.Caption:=LanguageSetup.GameYear;
        AddSubMenuItems(PopupMenu,M,FilterSelectYear,OnClick);
      end;

      If FilterSelectLanguage.Count>1 then begin
        M:=TMenuItem.Create(PopupMenu); PopupMenu.Items.Add(M); M.Tag:=6;
        M.Caption:=LanguageSetup.GameLanguage;
        AddSubMenuItems(PopupMenu,M,FilterSelectLanguage,OnClick);
      end;
    finally
      FilterSelectGenreTranslated.Free;
      FilterSelectLanguageTranslated.Free;
    end;
  finally
    FilterSelectLicenseUpper.Free;
    FilterSelectGenreUpper.Free;
    FilterSelectDeveloperUpper.Free;
    FilterSelectPublisherUpper.Free;
    FilterSelectYearUpper.Free;
    FilterSelectLanguageUpper.Free;
  end;

  PopupMenu.Popup(OpenPos.X+5,OpenPos.Y+5);
end;

Function ExePackageInfo(const AObject : TObject; const PackageDBCache : TPackageDBCache) : TStringList;
Var DownloadExeData : TDownloadExeData;
    CachedPackage : TCachedPackage;
    S : String;
begin
  result:=TStringList.Create;

  If AObject is TDownloadExeData then begin
    DownloadExeData:=TDownloadExeData(AObject);
    result.Text:=ReplaceBRs(DownloadExeData.Description);
    result.Add('');
    result.Add(LANG_DownloadSize+' '+GetNiceFileSize(DownloadExeData.Size));
    S:=PackageDBCache.FindChecksum(DownloadExeData.Name);
    If S<>'' then begin
      result.Add('');
      If S=DownloadExeData.PackageChecksum then begin
        result.Add(LANG_PackageAlreadyDownloaded);
      end else begin
        result.Add(LANG_OldPackageAlreadyDownloaded);
      end;
    end;
  end else begin
    CachedPackage:=TCachedPackage(AObject);
    result.Text:=ReplaceBRs(CachedPackage.Description);
    result.Add('');
    result.Add(LANG_DownloadSize+' '+GetNiceFileSize(CachedPackage.Size));
    result.Add('');
    result.Add(LANG_PackageOnlyInCache);
  end;
end;

initialization
finalization
  If Assigned(FilterSelectLicense) then FilterSelectLicense.Free;
  If Assigned(FilterSelectGenre) then FilterSelectGenre.Free;
  If Assigned(FilterSelectDeveloper) then FilterSelectDeveloper.Free;
  If Assigned(FilterSelectPublisher) then FilterSelectPublisher.Free;
  If Assigned(FilterSelectYear) then FilterSelectYear.Free;
  If Assigned(FilterSelectLanguage) then FilterSelectLanguage.Free;
end.
