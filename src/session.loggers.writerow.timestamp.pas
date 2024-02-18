unit session.loggers.writerow.timestamp;

{$mode ObjFPC}{$H+}

interface

uses
  session.loggers.types;

function TimestampedEvent : TTimestampedEvent;
procedure InitializeBaseHeader;
procedure Timestamp(AEvent : string); overload;
procedure Timestamp(AEvent : string; AAnnotation : string); overload;
procedure Timestamp(AEvent : TTimestampedEvent); overload;
procedure Timestamp(ATimestamp, ATrial, ABlock, ACode, AAnnotation : string); overload;

var
  SaveData : TDataProcedure;

implementation

uses SysUtils, session.pool, timestamps, timestamps.methods, session.loggers;

function TimestampedEvent: TTimestampedEvent;
begin
  Result.Timestamp := ClockMonotonic;
  Result.Trial := Pool.Session.Trial.UID + 1;
  Result.Block := Pool.Session.Block.UID + 1;
end;

procedure InitializeBaseHeader;
begin
 SaveData(TLogger.Row([
    'Timestamp',
    'Session.Trial.UID',
    'Session.Block.UID',
    'Event',
    'Event.Annotation']));
end;

procedure Timestamp(AEvent: string; AAnnotation: string);
begin
  SaveData(TLogger.Row([
    ClockMonotonic.ToString,
    (Pool.Session.Trial.UID + 1).ToString,
    (Pool.Session.Block.UID + 1).ToString,
    AEvent,
    AAnnotation]));
end;

procedure Timestamp(AEvent : string);
begin
  SaveData(TLogger.Row([
    ClockMonotonic.ToString,
    (Pool.Session.Trial.UID + 1).ToString,
    (Pool.Session.Block.UID + 1).ToString,
    AEvent]));
end;

procedure Timestamp(AEvent: TTimestampedEvent);
begin
  SaveData(TLogger.Row([
    AEvent.Timestamp.ToString,
    AEvent.Trial.ToString,
    AEvent.Block.ToString,
    AEvent.Code,
    AEvent.Annotation]));
end;

procedure Timestamp(ATimestamp, ATrial, ABlock, ACode, AAnnotation: string);
begin
  SaveData(TLogger.Row([
    ATimestamp,
    ATrial,
    ABlock,
    ACode,
    AAnnotation]));
end;


end.

