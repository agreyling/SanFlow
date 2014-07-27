unit uGlobals;

interface

//global variables consist of a linked list containing the current data

{----- pointers to data blocks }

// Unmetered consumptions (linked list)
type
  UnMeteredPointer = ^UnmeteredRec;
  UnmeteredRec = record
    Description : string;
    NumOff      : integer;
    Use         : real;
    Next        : UnMeteredPointer;
  end;

// Metered consumptions (linked list)
type
  MeteredPointer = ^MeteredRec;
  MeteredRec = record
    Description : string;
    Use : real;
    Next : MeteredPointer;
  end;

//Zone: can vary between measurements
type
  ZonePointer = ^ZoneRec;
  ZoneRec = record
    MainsLength                                   : real;
    NumConnections, NumProperties,Population      : integer;
    NightFlowReference, MeasureDate               : string;
    AZNP, MeasuredMinNF, CalcBackLoss,NormNightUse,
    ExpectNF, ExcessNF, ESPB                       : real;
    UnMetered                                     : UnMeteredPointer;
    Metered                                       : MeteredPointer;
    Next,Prev                                     : ZonePointer; //bi-directional
  end;

// Constants for a zone.
var
  ZoneName         : string;
  BackMainLoss, BackConnLoss, BackPropLoss,
  PopNightActive, UnitNightUse,
  BackPCF, BurstPCF,
  UnitESPB         : real;

  ZoneHeadPtr, CurrentZone : ZonePointer;
  ZoneUnMetered            : UnMeteredPointer;
  ZoneMetered              : MeteredPointer;
//
  ChangesSaved : boolean;

{ Utils }

  function StrToReal(InString : string) : real;
  function RealToStr(InReal: real;Width : integer) : string;
  function CheckText(InString : string) : string;
  function GetPortion(SpareString : string) : string;

{------------------------------------------------------------------------------}
implementation
{------------------------------------------------------------------------------}
{   Utils
{------------------------------------------------------------------------------}
function StrToReal(InString : string) : real;
var
  code : integer;
begin
  val(CheckText(InString),Result,Code);
end;

function RealToStr(InReal: real;Width : integer) : string;
begin
  str(InReal:0:Width,Result);
end;

function CheckText(InString : string) : string;
//return zero if empty; important for some math fn's
begin
  if InString = '' then Result := '0'
                   else Result := InString;
end;

function GetPortion(SpareString : string) : string;
//remove all chars preceeding the = char
begin
  Result:= copy(sparestring,pos('=',sparestring)+2,length(sparestring));
end;
{------------------------------------------------------------------------------}
end.
