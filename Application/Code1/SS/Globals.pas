unit Globals;

interface
type

//global variables consist of a linked list which holds the current
//data in memory to facilitate reasonable access times and flexibility

  //linked list to hold the unmetered consumptions
  UnMeteredPointer = ^UnmeteredRec;
  UnmeteredRec = record
    Description : string;
    NumOff      : integer;
    Use         : real;
    Next        : UnMeteredPointer;
  end;

  //lineked list to hold the metered consumptions
  MeteredPointer = ^MeteredRec;
  MeteredRec = record
    Description : string;
    Use : real;
    Next : MeteredPointer;
  end;

//These items can vary between measurements.
  ZonePointer = ^ZoneRec;
  ZoneRec = record
    MainsLength                                   : real;
    NumConnections,NumProperties,Population       : integer;
    NightFlowReference,MeasureDate                : string;
    AZNP,MeasuredMinNF,CalcBackLoss,NormNightUse,
    ExpectNF,ExcessNF,ESPB                        : real;
    UnMetered                                     : UnMeteredPointer;
    Metered                                       : MeteredPointer;
    //this list is doubly-linked to ensure bi-directional movement
    Next,Prev                                     : ZonePointer;
  end;//record

var
//These items are constant across a zone.
  ZoneName         : string;
  BackMainLoss,BackConnLoss,BackPropLoss,
  PopNightActive,UnitNightUse,
  BackPCF,BurstPCF,
  UnitESPB         : real;

  ZoneHeadPtr,CurrentZone : ZonePointer;
  ZoneUnMetered        : UnMeteredPointer;
  ZoneMetered          : MeteredPointer;

  ChangesSaved : boolean;

  //some common string and text editing functions
  function StrToReal(InString : string) : real;
  function RealToStr(InReal: real;Width : integer) : string;
  function CheckText(InString : string) : string;
  function GetPortion(SpareString : string) : string;

implementation

function StrToReal(InString : string) : real;
//string containing real value passed in
//corresponding real value returned
var
  code : integer;
begin
  val(CheckText(InString),Result,Code);
end;

function RealToStr(InReal: real;Width : integer) : string;
//converts a real to a string with a specified number of decimals
begin
  str(InReal:0:Width,Result);
end;

function CheckText(InString : string) : string;
//ensures that if the string is empty a string containing a zero
//is returned, important for some math fn's
begin
  if InString = '' then
    Result := '0'
  else
    Result := InString;
end;

function GetPortion(SpareString : string) : string;
//used to parse the input file to remove all items preceeding the
//equals sign
begin
  Result:= copy(sparestring,pos('=',sparestring)+2,length(sparestring));
end;


end.
