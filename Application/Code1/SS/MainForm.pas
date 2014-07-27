{------------------------------------------------------------------------------}
unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, Grids, Globals, ComCtrls, Math, Buttons,
  ToolWin, TeeProcs, TeEngine, Chart, jpeg, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, XPMan, ActnCtrls;

type
  TMainFm = class(TForm)
    MainGrid: TStringGrid;
    StatusBar: TStatusBar;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Tools1: TMenuItem;
    Help1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ZoneConstants1: TMenuItem;
    N2: TMenuItem;
    ZoneVariables1: TMenuItem;
    NormalNightUse1: TMenuItem;
    BackgroundLosses1: TMenuItem;
    Graphs1: TMenuItem;
    SensitvityAnalysis1: TMenuItem;
    Reports1: TMenuItem;
    Contents1: TMenuItem;
    N3: TMenuItem;
    About1: TMenuItem;
    ActionManager1: TActionManager;
    actOpen: TAction;
    actNew: TAction;
    actSave: TAction;
    actExit: TAction;
    actZoneConstants: TAction;
    actZoneVariables: TAction;
    actNormalNightUse: TAction;
    actBackgroundLosses: TAction;
    actReports: TAction;
    actGraphs: TAction;
    actSensitivity: TAction;
    actHelpContents: TAction;
    actHelpAbout: TAction;
    actNewLine: TAction;
    XPManifest1: TXPManifest;
    ActionToolBar1: TActionToolBar;
    procedure MainGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure MainGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure MainGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actItemExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure NewFile;
    procedure FileOpen;
    procedure FileSave;
    procedure LoadDataFile(AFilename : string);
    procedure SaveDataFile(AFilename : string);
    procedure LoadData(AFilename : string);
    procedure CreateNewLine;
    procedure GridInitialise;
    procedure GridUpdate;
    procedure UpdateScreen;
    procedure CalculateValues;
    procedure ShowVariablesForm;
    procedure ShowNormalForm;
    procedure ShowBackgroundForm;
    procedure ShowReportForm;
    procedure ShowSensitvityForm;
    procedure ShowBackgroundLosses;
    procedure ShowNormalNightUse;
  end;

var
  MainFm: TMainFm;
{------------------------------------------------------------------------------}
implementation
uses
  AboutForm, ZoneConstantsForm, ZoneVariablesForm, BackgroundLossesForm,
  NormalNightUseForm, GraphForm, ReportForm, StatsForm;
{$R *.DFM}
{------------------------------------------------------------------------------}
{   Create, show, close
{------------------------------------------------------------------------------}
procedure TMainFm.FormCreate(Sender: TObject);
begin
  actNew.Execute;  //create new empty data file at start-up
  GridInitialise;
  MainFm.ActiveControl := nil;
  width  := 935;
  height := 465;
end;

procedure TMainFm.FormActivate(Sender: TObject);
begin
  UpdateScreen;
end;

procedure TMainFm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Response : integer;
begin
  if NOT(ChangesSaved) then begin
    Response := MessageDlg('Save Changes ?',mtConfirmation,mbYesNoCancel,0);
    if Response = mrYes then begin
      if SaveDialog1.Execute then SaveDataFile(SaveDialog1.FileName)
                             else Action := caNone;
    end
    else if Response = mrCancel then
      Action := caNone;//do not close the form
  end;
end;
{------------------------------------------------------------------------------}
{   File: Open, Save
{------------------------------------------------------------------------------}
procedure TMainFm.FileOpen;
var
  Response : integer;
begin
  if NOT(ChangesSaved) then begin
    Response := MessageDlg('Save Changes ?',mtConfirmation,mbYesNoCancel,0);
    if (Response = mrYes) then begin
      if SaveDialog1.Execute then begin
        SaveDataFile(SaveDialog1.FileName);
        if OpenDialog1.Execute then begin
          //need a proper clearup procedure
          ZoneHeadPtr := nil;
          LoadData(OpenDialog1.FileName);
        end;
      end
    end
    else if (Response = mrNo) then begin
      if OpenDialog1.Execute then begin
        //need a proper clearup procedure
        ZoneHeadPtr := nil;
        LoadData(OpenDialog1.FileName);
      end;
    end
  end
  else begin
    if OpenDialog1.Execute then begin
      //need a proper clearup procedure
      ZoneHeadPtr := nil;
      LoadData(OpenDialog1.FileName);
    end;
  end;
end;

procedure TMainFm.FileSave;
begin
  if SaveDialog1.Execute then
    SaveDataFile(SaveDialog1.FileName);
end;
{------------------------------------------------------------------------------}
{   Data Load, Save, New
{------------------------------------------------------------------------------}
procedure TMainFm.LoadData(AFilename : string);
var
  r : integer;
begin
  LoadDataFile(AFilename);

  // ensures correct number of rows available
  CurrentZone := ZoneHeadPtr;
  MainGrid.FixedRows := 2;
  r := MainGrid.FixedRows;
  while CurrentZone <> nil do begin
    MainGrid.RowCount := r + 1;
    inc(r);
    CurrentZone := CurrentZone.Next;
  end;
  UpdateScreen;
end;

procedure TMainFm.LoadDataFile(AFilename : string);
var
  f : textfile;
  SpareZone : ZonePointer;
  CurrentMetered: MeteredPointer;
  CurrentUnMetered: UnMeteredPointer;
  s : string;
begin
  //Constant portion of data file
  AssignFile(f,AFilename);
  Reset(f);
  readln(f,s);
  readln(f,s);  ZoneName := GetPortion(s);
  readln(f,s);  BackMainLoss := StrToReal(GetPortion(s));
  readln(f,s);  BackConnLoss := StrToReal(GetPortion(s));
  readln(f,s);  BackPropLoss := StrToReal(GetPortion(s));
  readln(f,s);  PopNightActive := StrToReal(GetPortion(s));
  readln(f,s);  UnitNightUse := StrToReal(GetPortion(s));
  readln(f,s);  BackPCF := StrToReal(GetPortion(s));
  readln(f,s);  BurstPCF := StrToReal(GetPortion(s));
  readln(f,s);  UnitESPB := StrToReal(GetPortion(s));

  readln(f,s);
  readln(f,s);
  while NOT(EOF(f)) do begin
    if ZoneHeadPtr = nil then begin
      //no data structure exists, create new header node
      New(ZoneHeadPtr);
      ZoneHeadPtr.Next := nil;
      ZoneHeadPtr.Prev := nil;
      ZoneHeadPtr.Metered := nil;
      ZoneHeadPtr.UnMetered := nil;
      CurrentZone := ZoneHeadPtr;
    end
    else begin
      //create new node in list
      New(SpareZone);
      SpareZone.Next := nil;
      SpareZone.Metered := nil;
      SpareZone.UnMetered := nil;
      CurrentZone.Next := SpareZone;
      SpareZone.Prev := CurrentZone;
      CurrentZone := SpareZone;
    end;

    //General variable portion of data
    if s <> '[Non-Domestic unmetered night use]' then begin
      //load items into "constant" portion of data structure
      CurrentZone.NightFlowReference := GetPortion(s);
      readln(f,s);  CurrentZone.MeasureDate := GetPortion(s);
      readln(f,s);  CurrentZone.AZNP := StrToReal(GetPortion(s));
      readln(f,s);  CurrentZone.MeasuredMinNF := StrToReal(GetPortion(s));
      readln(f,s);  CurrentZone.MainsLength := StrToReal(GetPortion(s));
      readln(f,s);  CurrentZone.NumConnections := StrToInt(GetPortion(s));
      readln(f,s);  CurrentZone.NumProperties := StrToInt(GetPortion(s));
      readln(f,s);  CurrentZone.Population := StrToInt(GetPortion(s));
      readln(f,s); //this should contain the header
    end;

    //Non-domestic unmetered portion of data
    readln(f,s);
    //create pointer to the unmetered values
    new(CurrentUnMetered);
    while s <> '[Non-Domestic metered night use]' do begin
      if CurrentZone.UnMetered = nil then begin
        //no header node exists, create a new one
        New(CurrentZone.UnMetered);
        CurrentZone.UnMetered.Next := nil;
        CurrentUnMetered := CurrentZone.UnMetered;
      end
      else begin
        //create new node in list
        New(CurrentUnMetered.Next);
        CurrentUnMetered := CurrentUnMetered.Next;
        CurrentUnMetered.Next := nil;
      end;
      CurrentUnMetered.Description := GetPortion(s);
      readln(f,s); CurrentUnMetered.NumOff := StrToInt(GetPortion(s));
      readln(f,s); CurrentUnMetered.Use := StrToReal(GetPortion(s));
      readln(f,s);
    end;

    //Non-domestic metered portion of data
    //create pointer to the metered values
    new(CurrentMetered);
    readln(f,s);
    while (s <> '[Zone Variables]') and NOT(EOF(f)) do begin
      if CurrentZone.Metered = nil then begin
        //no header node exists, create a new one
        New(CurrentZone.Metered);
        CurrentZone.Metered.Next := nil;
        CurrentMetered := CurrentZone.Metered;
      end
      else begin
        //create a new node in the list
        New(CurrentMetered.Next);
        CurrentMetered := CurrentMetered.Next;
        CurrentMetered.Next := nil;
      end;
      CurrentMetered.Description := Globals.GetPortion(s);
      readln(f,s); CurrentMetered.Use := StrToReal(Globals.GetPortion(s));
      readln(f,s);
    end;

    readln(f,s);
    //if data exists then create new node and move to it.
  end;
  CloseFile(f);
  CurrentZone := ZoneHeadPtr;
  ChangesSaved := true;
end;

procedure TMainFm.NewFile;
begin
  // CreateTheFile & data structure
  if ZoneHeadPtr <> nil then
    Dispose(ZoneHeadPtr);
  ZoneName := '';
  BackMainLoss := 40;
  BackConnLoss := 3;
  BackPropLoss := 1;
  PopNightActive := 6;
  UnitNightUse := 10;
  BackPCF := 1.5;
  BurstPCF := 0.5;
  UnitESPB := 1.6;
  New(ZoneHeadPtr);
  CurrentZone := ZoneHeadPtr;
  CurrentZone.MainsLength := 0;
  CurrentZone.NumConnections := 0;
  CurrentZone.NumProperties := 0;
  CurrentZone.Population := 0;
  CurrentZone.NightFlowReference := '';
  CurrentZone.MeasureDate := '';
  CurrentZone.AZNP := 0;
  CurrentZone.MeasuredMinNF := 0;
  CurrentZone.CalcBackLoss := 0;
  CurrentZone.NormNightUse := 0;
  CurrentZone.ExpectNF := 0;
  CurrentZone.ExcessNF := 0;
  CurrentZone.ESPB := 0;
  New(CurrentZone.UnMetered);
  CurrentZone.UnMetered.Description := '';
  CurrentZone.UnMetered.NumOff := 0;
  CurrentZone.UnMetered.Use := 0;
  CurrentZone.UnMetered.Next := nil;
  New(CurrentZone.Metered);
  CurrentZone.Metered.Description := '';
  CurrentZone.Metered.Use := 0;
  CurrentZone.Metered.Next := nil;
  CurrentZone.Next := nil;
  CurrentZone.Prev := nil;
  MainGrid.RowCount := 3;

  ChangesSaved := true;
  UpdateScreen;
end;

procedure TMainFm.CreateNewLine;
var
  CurrentUnMetered,PrevUnMetered : UnMeteredPointer;
  CurrentMetered,PrevMetered     : MeteredPointer;
begin
   CurrentZone := ZoneHeadPtr;
   while CurrentZone.Next <> nil do
     CurrentZone := CurrentZone.Next;
   new(CurrentZone.Next);
   CurrentZone.Next.Prev := CurrentZone;//hows that for confusing !!
   CurrentZone := CurrentZone.Next;

   CurrentZone.MainsLength := CurrentZone.Prev.MainsLength;
   CurrentZone.NumConnections := CurrentZone.Prev.NumConnections;
   CurrentZone.NumProperties := CurrentZone.Prev.NumProperties;
   CurrentZone.Population := CurrentZone.Prev.Population;
   CurrentZone.NightFlowReference := '';
   CurrentZone.MeasureDate := CurrentZone.Prev.MeasureDate;
   CurrentZone.AZNP := CurrentZone.Prev.AZNP;
   CurrentZone.MeasuredMinNF := CurrentZone.Prev.MeasuredMinNF;
   CurrentZone.CalcBackLoss := CurrentZone.Prev.CalcBackLoss;
   CurrentZone.NormNightUse := CurrentZone.Prev.NormNightUse;
   CurrentZone.ExpectNF := CurrentZone.Prev.ExpectNF;
   CurrentZone.ExcessNF := CurrentZone.Prev.ExcessNF;
   CurrentZone.ESPB := CurrentZone.Prev.ESPB;

   //Copy all the metered and unmetered values forward to this entry also
   CurrentUnMetered := nil;
   PrevUnMetered := CurrentZone.Prev.UnMetered;
   while PrevUnMetered <> nil do begin
     if CurrentUnMetered = nil then begin
       New(CurrentUnMetered);
       CurrentZone.UnMetered := CurrentUnMetered;
     end
     else begin
       New(CurrentUnMetered.Next);
       CurrentUnMetered := CurrentUnMetered.Next;
     end;
     CurrentUnMetered.Description := PrevUnMetered.Description;
     CurrentUnMetered.NumOff := PrevUnMetered.NumOff;
     CurrentUnMetered.Use := PrevUnMetered.Use;
     CurrentUnMetered.Next := nil;
     PrevUnMetered := PrevUnMetered.Next
   end;

   CurrentMetered := nil;
   PrevMetered := CurrentZone.Prev.Metered;
   while PrevMetered <> nil do begin
     if CurrentMetered = nil then begin
       New(CurrentMetered);
       CurrentZone.Metered := CurrentMetered;
     end
     else begin
       New(CurrentMetered.Next);
       CurrentMetered := CurrentMetered.Next;
     end;
     CurrentMetered.Description := PrevMetered.Description;
     CurrentMetered.Use := PrevMetered.Use;
     CurrentMetered.Next := nil;
     PrevMetered := PrevMetered.Next
   end;

   CurrentZone.Next := nil;
   MainGrid.RowCount := MainGrid.RowCount + 1;
   UpdateScreen;
end;
{------------------------------------------------------------------------------}
procedure TMainFm.SaveDataFile(AFilename : string);
var
  f : textfile;
begin
  CurrentZone := ZoneHeadPtr;
  assignfile(f,AFilename);
  rewrite(f);
  //Zonal constants
  writeln(f,'[Zone Constants]');
  writeln(f,'Zone Name = ' + ZoneName);
  writeln(f,'MainsLosses = ' + RealToStr(BackMainLoss,3));
  writeln(f,'ConnectionLosses = ' + RealToStr(BackConnLoss,3));
  writeln(f,'PropertyLosses = ' + RealToStr(BackPropLoss,3));
  writeln(f,'ActivePopulation = ' + RealToStr(PopNightActive,3));
  writeln(f,'UnitNightUse = ' + RealToStr(UnitNightUse,3));
  writeln(f,'BackgroundPCF = ' + RealToStr(BackPCF,3));
  writeln(f,'BurstPCF = ' + RealToStr(BurstPCF,3));
  writeln(f,'UnitESPB = ' + RealToStr(UnitESPB,3));
  //Zonal Variables
  while CurrentZone <> nil do begin
    writeln(f,'[Zone Variables]');
    writeln(f,'NightFlowReference = ' + CurrentZone.NightFlowReference);
    writeln(f,'MeasurementDate = ' + CurrentZone.MeasureDate);
    writeln(f,'MeasuredAZNP = ' + RealToStr(CurrentZone.AZNP,3));
    writeln(f,'MeasuredMinimumNightFlow = ' + RealToStr(CurrentZone.MeasuredMinNF,3));
    writeln(f,'MainsLength = ' + RealToStr(CurrentZone.MainsLength,3));
    writeln(f,'NumberOfConnections = ' + IntToStr(CurrentZone.NumConnections));
    writeln(f,'NumberOfProperties = ' + IntToStr(CurrentZone.NumProperties));
    writeln(f,'Population = ' + IntToStr(CurrentZone.Population));
    ZoneUnMetered := CurrentZone.UnMetered;
    writeln(f,'[Non-Domestic unmetered night use]');
    while ZoneUnMetered <> nil do begin
      writeln(f,'Description = ' + ZoneUnMetered.Description);
      writeln(f,'NumberOff = ' + IntToStr(ZoneUnMetered.NumOff));
      writeln(f,'Use = ' + RealToStr(ZoneUnMetered.Use,3));
      ZoneUnMetered := ZoneUnMetered.Next;
    end;//while CurrentZone.Unmetered
    ZoneMetered := CurrentZone.Metered;
    writeln(f,'[Non-Domestic metered night use]');
    while ZoneMetered <> nil do begin
      writeln(f,'Description = ' + ZoneMetered.Description);
      writeln(f,'Use = ' + RealToStr(ZoneMetered.Use,3));
      ZoneMetered := ZoneMetered.Next;
    end;//while CurrentZone.Metered
    CurrentZone := CurrentZone.Next;
  end;//while CurrentZone
  closefile(f);
  ChangesSaved := true;
end;
{------------------------------------------------------------------------------}
{   Grid
{------------------------------------------------------------------------------}
procedure TMainFm.GridInitialise;
begin
  MainGrid.Cells[0,0] := ' Reference';//initialise grid headings
  MainGrid.Cells[1,0] := ' Date';
  MainGrid.Cells[2,0] := ' AZNP (m)';
  MainGrid.Cells[3,0] := ' Measured Min.';
  MainGrid.Cells[3,1] := ' Night Flow (m³/hr)';
  MainGrid.Cells[4,0] := ' Background';
  MainGrid.Cells[4,1] := ' Losses (m³/hr)';
  MainGrid.Cells[5,0] := ' Normal Night';
  MainGrid.Cells[5,1] := ' Use (m³/hr)';
  MainGrid.Cells[6,0] := ' Expected Min.';
  MainGrid.Cells[6,1] := ' Night Flow (m³/hr)';
  MainGrid.Cells[7,0] := ' Excess Night';
  MainGrid.Cells[7,1] := ' Flow (m³/hr)';
  MainGrid.Cells[8,0] := ' Equivalent Service';
  MainGrid.Cells[8,1] := ' Pipe Bursts';
  MainGrid.DefaultColWidth := MainGrid.Width div 9;
end;

procedure TMainFm.GridUpdate;
var
  r : integer;
begin
  CurrentZone := ZoneHeadPtr;
  for r := (MainGrid.FixedRows) to (MainGrid.RowCount - 1) do begin
    CalculateValues;
    MainGrid.Cells[0,r] := CurrentZone.NightFlowReference;
    MainGrid.Cells[1,r] := CurrentZone.MeasureDate;
    MainGrid.Cells[2,r] := RealToStr(CurrentZone.AZNP,2);
    MainGrid.Cells[3,r] := RealToStr(CurrentZone.MeasuredMinNF,2);
    MainGrid.Cells[4,r] := RealToStr(CurrentZone.CalcBackLoss,2);
    MainGrid.Cells[5,r] := RealToStr(CurrentZone.NormNightUse,2);
    MainGrid.Cells[6,r] := RealToStr(CurrentZone.ExpectNF,2);
    MainGrid.Cells[7,r] := RealToStr(CurrentZone.ExcessNF,2);
    MainGrid.Cells[8,r] := RealToStr(CurrentZone.ESPB,1);
    CurrentZone := CurrentZone.Next;
  end;
end;
{------------------------------------------------------------------------------}
{   Update screen, Calculate values
{------------------------------------------------------------------------------}
procedure TMainFm.UpdateScreen;
begin
  MainFm.Caption := 'South African Night Flow Analysis - '+ZoneName;
  GridUpdate;
end;

procedure TMainFm.CalculateValues;
var
  MeteredUse,UnMeteredUse : real;
  MeteredSpare : MeteredPointer;
  UnMeteredSpare : UnMeteredPointer;
begin
  //Calculate all relevant values
  CurrentZone.CalcBackLoss := (CurrentZone.MainsLength*BackMainLoss/1000+
                              CurrentZone.NumConnections*BackConnLoss/1000+
                              CurrentZone.NumProperties*BackPropLoss/1000)*
                              power((CurrentZone.AZNP)/50,BackPCF);
  MeteredUse := 0.0;
  MeteredSpare := CurrentZone.Metered;
  while MeteredSpare <> nil do begin
    MeteredUse := MeteredUse + MeteredSpare.Use;
    MeteredSpare := MeteredSpare.Next;
  end;

  UnMeteredUse := 0.0;
  UnMeteredSpare := CurrentZone.UnMetered;
  while UnMeteredSpare <> nil do begin
    UnMeteredUse := UnMeteredUse + UnMeteredSpare.Use/1000*
                                   UnMeteredSpare.NumOff;
    UnMeteredSpare := UnMeteredSpare.Next;
  end;

  CurrentZone.NormNightUse := CurrentZone.Population*
                              PopNightActive/100*
                              UnitNightUse/1000+
                              MeteredUse+UnMeteredUse;
  CurrentZone.ExpectNF := CurrentZone.NormNightUse + CurrentZone.CalcBackLoss;
  CurrentZone.ExcessNF := CurrentZone.MeasuredMinNF - CurrentZone.ExpectNF;
  if (CurrentZone.AZNP > 0) and (UnitESPB > 0) then
    CurrentZone.ESPB := CurrentZone.ExcessNF/(UnitESPB*power((CurrentZone.AZNP/50),BurstPCF))
  else
    CurrentZone.ESPB := 0.0;
end;
{------------------------------------------------------------------------------}
{   Events
{------------------------------------------------------------------------------}
{ Form }
procedure TMainFm.FormResize(Sender: TObject);
begin
  MainGrid.DefaultColWidth := (MainGrid.ClientWidth - (MainGrid.ColCount + 3)) div MainGrid.ColCount;
end;

{ Grid }
procedure TMainFm.MainGridMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  col, row : integer;
begin
  MainGrid.MouseToCell(X, Y, col, row);
  case col of
    0 : StatusBar.Panels[0].Text := 'Measurement reference number';
    1 : StatusBar.Panels[0].Text := 'Measurement date';
    2 : StatusBar.Panels[0].Text := 'Average night zone pressure';
    3 : StatusBar.Panels[0].Text := 'Measured minimum night flow';
    4 : StatusBar.Panels[0].Text := 'Background losses';
    5 : StatusBar.Panels[0].Text := 'Normal night use';
    6 : StatusBar.Panels[0].Text := 'Expected minimum night flow';
    7 : StatusBar.Panels[0].Text := 'Excess night flow';
    8 : StatusBar.Panels[0].Text := 'Equivalent service pipe bursts';
  end;
end;

procedure TMainFm.MainGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  r : integer;
begin
  //delete
  if (Key = 46) and (MainGrid.RowCount > 3) then begin
    CurrentZone := ZoneHeadPtr;
    for r := (MainGrid.FixedRows) to (MainGrid.Row - 1) do
      CurrentZone := CurrentZone.Next;
    if CurrentZone = ZoneHeadPtr then begin
      CurrentZone.Next.Prev := nil;
      ZoneHeadPtr := CurrentZone.Next;
      CurrentZone := ZoneHeadPtr;
    end
    else begin
      CurrentZone.Prev.Next := CurrentZone.Next;
      if CurrentZone.Next <> nil then
        CurrentZone.Next.Prev := CurrentZone.Prev;
      CurrentZone := ZoneHeadPtr;
    end;
    MainGrid.RowCount := MainGrid.RowCount - 1;
    UpdateScreen;
  end;
end;

procedure TMainFm.MainGridMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  col, row, r : integer;
begin
  if Button = mbRight then begin
    MainGrid.MouseToCell(X, Y, col, row);
    if row <= (MainGrid.FixedRows-1) then begin
      CreateNewLine; //Create a new node, at the end;
    end
    //create new row
    else if row > (MainGrid.FixedRows - 1) then begin
      MainGrid.Row := row;
      MainGrid.Col := col;
      //move pointer to correct node in list
      CurrentZone := ZoneHeadPtr;
      for r := (MainGrid.FixedRows) to (row - 1) do
        CurrentZone := CurrentZone.Next;
      case col of
        4 : BackgroundLossesFm.Show;
        5 : NormalNightUseFm.Show;
        else
          ZoneVariablesFm.Show;
      end;//case
    end;//if
  end;//if
end;
{------------------------------------------------------------------------------}
{   Actions
{------------------------------------------------------------------------------}
procedure TMainFm.actItemExecute(Sender: TObject);
begin
  { File }
  if sender = actNew  then NewFile;
  if sender = actOpen then FileOpen;
  if sender = actSave then FileSave;
  if sender = actExit then Close;
  { Edit }
  if sender = actZoneConstants    then ZoneConstantsFm.Show;
  if sender = actZoneVariables    then ShowVariablesForm;
  if sender = actNormalNightUse   then ShowNormalForm;
  if sender = actBackgroundLosses then ShowBackgroundForm;
  if sender = actNewLine          then CreateNewLine;
  { Tools }
  if sender = actReports          then ShowReportForm;
  if sender = actGraphs           then GraphFm.Show;
  if sender = actSensitivity      then ShowSensitvityForm;
  { Help }
  if sender = actHelpAbout        then AboutFm.Show;
  if sender = actHelpContents     then Application.HelpContext(1);
end;

procedure TMainFm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if      key = #14 then actNew.Execute   //Ctrl+N
  else if key = #15 then actOpen.Execute  //Ctrl+0
  else if key = #19 then actSave.Execute  //Ctrl-S
  else if key = #24 then actExit.Execute; //Ctrl-S
end;
{------------------------------------------------------------------------------}
{   Show dialog forms
{------------------------------------------------------------------------------}
procedure TMainFm.ShowBackgroundLosses;
var
  r : integer;
begin
  CurrentZone := ZoneHeadPtr;
  for r := (MainGrid.FixedRows) to (MainGrid.Row-1) do
    CurrentZone := CurrentZone.Next;
  BackgroundLossesFm.Show;
end;

procedure TMainFm.ShowNormalNightUse;
var
  r : integer;
begin
  CurrentZone := ZoneHeadPtr;
  for r := (MainGrid.FixedRows) to (MainGrid.Row-1) do
    CurrentZone := CurrentZone.Next;
  NormalNightUseFm.Show;
end;

procedure TMainFm.ShowNormalForm;
var
  r : integer;
begin
  CurrentZone := ZoneHeadPtr;
  for r := (MainGrid.FixedRows) to (MainGrid.Row-1) do
    CurrentZone := CurrentZone.Next;
  NormalNightUseFm.Show;
end;

procedure TMainFm.ShowBackgroundForm;
var
  r : integer;
begin
  CurrentZone := ZoneHeadPtr;
  for r := (MainGrid.FixedRows) to (MainGrid.Row-1) do
    CurrentZone := CurrentZone.Next;
  BackgroundLossesFm.Show;
end;

procedure TMainFm.ShowSensitvityForm;
var
  r : integer;
begin
  CurrentZone := ZoneHeadPtr;
  for r := (MainGrid.FixedRows) to (MainGrid.Row-1) do
    CurrentZone := CurrentZone.Next;
  StatsFm.Show;
end;

procedure TMainFm.ShowReportForm;
begin
  ReportFm.Start := MainGrid.Selection.Top - MainGrid.FixedRows;
  ReportFm.Finish := MainGrid.Selection.Bottom - MainGrid.FixedRows;
  ReportFm.Show;
end;

procedure TMainFm.ShowVariablesForm;
var
  r : integer;
begin
  CurrentZone := ZoneHeadPtr;
  for r := (MainGrid.FixedRows) to (MainGrid.Row-1) do
    CurrentZone := CurrentZone.Next;
  ZoneVariablesFm.Show;
end;
{------------------------------------------------------------------------------}
end.
