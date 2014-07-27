unit fmNormalNightUse;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, uGlobals, ExtCtrls;

type
  TfrmNormalNightUse = class(TForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Pop: TEdit;
    Active: TEdit;
    UnitUse: TEdit;
    GroupBox2: TGroupBox;
    UnmeteredGrid: TStringGrid;
    GroupBox3: TGroupBox;
    MeteredGrid: TStringGrid;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    ZoneLabel: TLabel;
    RefLabel: TLabel;
    Panel1: TPanel;
    CancelBtn: TButton;
    SaveBtn: TButton;
    DomNU: TLabel;
    Label7: TLabel;
    NonDomNUUnMet: TLabel;
    Label8: TLabel;
    NonDomNUMet: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    TotalNightUse: TLabel;
    Label6: TLabel;
    Panel2: TPanel;
    procedure CancelBtnClick(Sender: TObject);
    procedure CalculateTotal;
    procedure DomesticEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure UnmeteredGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MeteredGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UnmeteredGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MeteredGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    private
      procedure Initialise;
  end;

var
  frmNormalNightUse: TfrmNormalNightUse;
{------------------------------------------------------------------------------}
implementation
uses
  fmUnMeteredEditor, fmMeteredEditor;
{$R *.DFM}
{------------------------------------------------------------------------------}
{   Create, Show
{------------------------------------------------------------------------------}
procedure TfrmNormalNightUse.FormCreate(Sender: TObject);
begin
  UnMeteredGrid.Cells[0,0] := 'Description';
  UnMeteredGrid.Cells[1,0] := 'Num Off';
  UnMeteredGrid.Cells[2,0] := 'Unit Use (l/hr)';
  UnMeteredGrid.Cells[3,0] := 'Total Use (m³/hr)';
  MeteredGrid.Cells[0,0] := 'Description';
  MeteredGrid.Cells[1,0] := 'Metered Use (m³/hr)';
//  if (UnMeteredGrid.DefaultRowHeight * UnMeteredGrid.RowCount) > UnMeteredGrid.ClientHeight then
//    UnMeteredGrid.DefaultColWidth := (UnmeteredGrid.ClientWidth - 15 - (UnMeteredGrid.ColCount + 3)) div UnMeteredGrid.ColCount
//  else
//    UnMeteredGrid.DefaultColWidth := (UnmeteredGrid.ClientWidth - (UnMeteredGrid.ColCount + 3)) div UnMeteredGrid.ColCount;
//  MeteredGrid.DefaultColWidth := (meteredGrid.ClientWidth - (MeteredGrid.ColCount + 3)) div MeteredGrid.ColCount;;
end;

procedure TfrmNormalNightUse.FormShow(Sender: TObject);
begin
  Initialise;
end;
{------------------------------------------------------------------------------}
{   Initialise
{------------------------------------------------------------------------------}
procedure TfrmNormalNightUse.Initialise;
var
  SpareUnMetered : UnMeteredPointer;
  SpareMetered   : MeteredPointer;
  RowPos         : integer;
  total          : real;
  loop           : integer;
begin
  if CurrentZone <> nil then begin
    ZoneLabel.Caption := ZoneName;
    RefLabel.Caption := CurrentZone.NightFlowReference;

    Pop.Text := IntToStr(CurrentZone.Population);
    Active.Text := RealToStr(PopNightActive,2);
    UnitUse.Text := RealToStr(UnitNightUse,2);

    RowPos := 0;
    //make copy of current position in linked list
    SpareUnMetered := CurrentZone.UnMetered;
    //loop until the last node is found
    while SpareUnMetered <> nil do begin
      Inc(RowPos);
      UnMeteredGrid.RowCount := RowPos+1;
      UnMeteredGrid.Cells[0,RowPos] := SpareUnMetered.Description;
      UnMeteredGrid.Cells[1,RowPos] := IntToStr(SpareUnMetered.NumOff);
      UnMeteredGrid.Cells[2,RowPos] := RealToStr(SpareUnMetered.Use,3);
      UnMeteredGrid.Cells[3,RowPos] := RealToStr(StrToReal(UnMeteredGrid.Cells[1,RowPos])*
                                                 StrToReal(UnMeteredGrid.Cells[2,RowPos])/1000,3);
      SpareUnMetered := SpareUnMetered.Next;
    end;
    total := 0.0;
    for loop := 1 to (UnMeteredGrid.RowCount - 1) do
      total := total + StrToReal(UnMeteredGrid.Cells[3,loop]);
    NonDomNUUnMet.Caption := RealToStr(total,2);

    RowPos := 0;
    //make a copy of the metered position in the linked list
    SpareMetered := CurrentZone.Metered;
    //loop until last node found
    while SpareMetered <> nil do begin
      Inc(RowPos);
      MeteredGrid.RowCount := RowPos + 1;
      MeteredGrid.Cells[0,RowPos] := SpareMetered.Description;
      MeteredGrid.Cells[1,RowPos] := RealToStr(SpareMetered.Use,3);
      SpareMetered := SpareMetered.Next;
    end;
    total := 0.0;
    for loop := 1 to (MeteredGrid.RowCount - 1) do
      total := total + StrToReal(MeteredGrid.Cells[1,loop]);
    NonDomNUMet.Caption := RealToStr(total,2);

    CalculateTotal;
  end;
end;
{------------------------------------------------------------------------------}
{   Actions
{------------------------------------------------------------------------------}
procedure TfrmNormalNightUse.SaveBtnClick(Sender: TObject);
begin
  //store variables
  CurrentZone.Population := StrToInt(CheckText(Pop.Text));
  PopNightActive := StrToReal(Active.Text);
  UnitNightUse := StrToReal(UnitUse.Text);
  ChangesSaved := false;
  frmNormalNightUse.Close;
end;

procedure TfrmNormalNightUse.CancelBtnClick(Sender: TObject);
begin
  frmNormalNightUse.Close;
end;

procedure TfrmNormalNightUse.CalculateTotal;
//recalculate total when any value changes
begin
  TotalNightUse.Caption := RealToStr(StrToReal(DomNU.Caption)+
                                     StrToReal(NonDomNUMet.Caption)+
                                     StrToReal(NonDomNUUnMet.Caption),2);
end;

procedure TfrmNormalNightUse.DomesticEditChange(Sender: TObject);
//recalculate domestic night use when value changes
begin
  DomNU.Caption := RealToStr(StrToReal(Pop.Text)*
                   StrToReal(Active.Text)/100*
                   StrToReal(UnitUse.Text)/1000,2);
  CalculateTotal;
end;
{------------------------------------------------------------------------------}
{  Mouse down
{------------------------------------------------------------------------------}
procedure TfrmNormalNightUse.UnmeteredGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ThisRow,ThisCol : integer;
  loop            : integer;
begin
  if Button = mbRight then begin
    UnMeteredGrid.MouseToCell(X, Y,ThisCol,ThisRow);
    //if thisrow = -1 then add row
    if ThisRow <= 0 then begin
      ZoneUnMetered := CurrentZone.UnMetered;
      while ZoneUnMetered.Next <> nil do begin
        ZoneUnMetered := ZoneUnMetered.Next;
      end;//while
      new(ZoneUnMetered.Next);
      ZoneUnMetered := ZoneUnMetered.Next;
      ZoneUnMetered.Next := nil;
      ZoneUnMetered.Description := '';
      ZoneUnMetered.NumOff := 0;
      ZoneUnMetered.Use := 0.0;
      //if no data exists then create a node
      frmUnMeteredEditor.Show;
    end//if
    else if ThisRow > (UnMeteredGrid.FixedRows - 1) then begin
      UnMeteredGrid.Row := ThisRow;
      UnMeteredGrid.Col := ThisCol;
      //move pointer to correct node in list
      ZoneUnMetered := CurrentZone.UnMetered;
      for loop := (UnMeteredGrid.FixedRows) to (ThisRow - 1) do
      begin
        ZoneUnMetered := ZoneUnMetered.Next;
      end;
      frmUnMeteredEditor.Show;
    end;//if
  end;//if
end;

procedure TfrmNormalNightUse.MeteredGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ThisRow,ThisCol : integer;
  loop            : integer;
begin
  if Button = mbRight then begin
    MeteredGrid.MouseToCell(X, Y,ThisCol,ThisRow);
    //if thisrow = -1 then add row
    if ThisRow <= 0 then begin
      ZoneMetered := CurrentZone.Metered;
      while ZoneMetered.Next <> nil do
      begin
        ZoneMetered := ZoneMetered.Next;
      end;//while
      new(ZoneMetered.Next);
      ZoneMetered := ZoneMetered.Next;
      ZoneMetered.Next := nil;
      ZoneMetered.Description := '';
      ZoneMetered.Use := 0.0;
      frmMeteredEditor.Show;
    end//if
    else if ThisRow > (MeteredGrid.FixedRows - 1) then begin
      MeteredGrid.Row := ThisRow;
      MeteredGrid.Col := ThisCol;
      //move pointer to correct node in list
      ZoneMetered := CurrentZone.Metered;
      for loop := (MeteredGrid.FixedRows) to (ThisRow - 1) do begin
        ZoneMetered := ZoneMetered.Next;
      end;
      frmMeteredEditor.Show;
    end;//if
  end;//if}
end;
{------------------------------------------------------------------------------}
{  Key down
{------------------------------------------------------------------------------}
procedure TfrmNormalNightUse.UnmeteredGridKeyDown(Sender: TObject;
                                             var Key: Word; Shift: TShiftState);
var
  ThisRow : integer;
  loop    : integer;
  LastPtr : UnMeteredPointer;
begin
  LastPtr := nil;
  if (Key = 46) and (UnmeteredGrid.RowCount > (UnmeteredGrid.FixedRows+1)) then begin //delete
    ThisRow := UnMeteredGrid.Row;
    //move to item preceeding and delete relevant item
    ZoneUnMetered := CurrentZone.UnMetered;
    for loop := (UnmeteredGrid.FixedRows) to (ThisRow - 1) do begin
      LastPtr := ZoneUnMetered;
      ZoneUnMetered := ZoneUnMetered.Next;
    end;

    if (LastPtr = nil) then begin //at header node
      //move header pointer to second item
      CurrentZone.UnMetered := ZoneUnMetered.Next;
      Dispose(ZoneUnMetered);
    end
    else begin
      LastPtr.Next := ZoneUnMetered.Next;
      Dispose(ZoneUnMetered);
    end;

    UnmeteredGrid.RowCount := UnmeteredGrid.RowCount - 1;
  end;  //if
  Initialise; //refresh the grid
end;

procedure TfrmNormalNightUse.MeteredGridKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  ThisRow : integer;
  loop    : integer;
  LastPtr : MeteredPointer;
begin
  LastPtr := nil;
  if (Key = 46) and (MeteredGrid.RowCount > (MeteredGrid.FixedRows+1)) then begin //delete
    ThisRow := MeteredGrid.Row;
    //move to item preceeding and delete relevant item
    ZoneMetered := CurrentZone.Metered;
    for loop := (MeteredGrid.FixedRows) to (ThisRow - 1) do
    begin
      LastPtr := ZoneMetered;
      ZoneMetered := ZoneMetered.Next;
    end;

    if (LastPtr = nil) then begin //at header node
      //move header pointer to second item
      CurrentZone.Metered := ZoneMetered.Next;
      Dispose(ZoneMetered);
    end
    else begin
      LastPtr.Next := ZoneMetered.Next;
      Dispose(ZoneMetered);
    end;

    MeteredGrid.RowCount := MeteredGrid.RowCount - 1;
  end;//if
  Initialise; //refresh the grid
end;
{------------------------------------------------------------------------------}
end.
