unit session.csv.trials.base;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, session.csv;

type

  {

  TCSVTrialsBase

  Base class for polimorphism inside unit experiments.base.
  }

  TCSVTrialsBase = class(TCSVRows)
    private
      FTrialID : integer;
      FCursor : integer;
      FLimitedHold : integer;
      FInterTrialInterval : integer;
      FConsequenceInterval : integer;
      FRepeatTrial : integer;
      FTrialCount : integer;
      FHasConsequence : Boolean;
    protected
      FKind : string;
      procedure AfterLoadingParameters(Sender: TObject); virtual;
    public
      constructor Create; override;
      property TrialID : integer read FTrialID;
      property TrialCount : integer read FTrialCount;
      property Values[const AKey: string]: string read GetValue write SetValue;
  end;

implementation

uses session.constants.trials, session.parameters.global;

{ TCSVTrialsBase }

procedure TCSVTrialsBase.AfterLoadingParameters(Sender: TObject);
begin

end;

constructor TCSVTrialsBase.Create;
begin
  inherited Create;
  OnAfterLoadingParameters := @AfterLoadingParameters;
  FTrialID := 0;
  FKind := '';
  FRepeatTrial := 1;
  FTrialCount := 1;
  FCursor := GlobalTrialParameters.Cursor;
  FLimitedHold := GlobalTrialParameters.LimitedHold;
  FInterTrialInterval := GlobalTrialParameters.InterTrialInterval;
  FConsequenceInterval := GlobalTrialParameters.TimeOutInterval;
  FHasConsequence := True;

  with ParserTrialsBase do begin
    RegisterParameter(IDKey,
      @FTrialID, FTrialID);
    RegisterParameter(KindKey,
      @FKind, FKind);
    RegisterParameter(RepeatTrialKey,
      @FRepeatTrial, FRepeatTrial);
    RegisterParameter(TrialCountKey,
      @FTrialCount, FTrialCount);
    RegisterParameter(CursorKey,
      @FCursor, FCursor);
    RegisterParameter(LimitedHoldKey,
      @FLimitedHold, FLimitedHold);
    RegisterParameter(InterTrialIntervalKey,
      @FInterTrialInterval, FInterTrialInterval);
    RegisterParameter(ConsequenceIntervalKey,
      @FConsequenceInterval, FConsequenceInterval);
    RegisterParameter(HasConsequenceKey,
      @FHasConsequence, FHasConsequence);
  end;
end;

end.


