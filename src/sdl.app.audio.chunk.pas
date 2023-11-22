{
  Stimulus Control
  Copyright (C) 2014-2023 Carlos Rafael Fernandes Picanço, Universidade Federal do Pará.

  The present file is distributed under the terms of the GNU General Public License (GPL v3.0).

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}
unit sdl.app.audio.chunk;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ctypes, sdl2_mixer, sdl.app.audio.contract;

type

  { TChunk }

  TChunk = class(TInterfacedObject, ISound)
  private
    FFilename : string;
    FChannel: cint;
    FOnStart: TNotifyEvent;
    FOnStop : TNotifyEvent;
    FChunk : PMix_Chunk;
    procedure DoOnStop;
    procedure SetOnStart(AValue: TNotifyEvent);
    procedure SetOnStop(AValue: TNotifyEvent);
  public
    constructor Create;
    destructor Destroy; override;
    function Duration : cuint32;
    function Playing : Boolean;
    function ShortName : string;
    //function ShortPath : string;
    function AsInterface : ISound;
    procedure LoadFromFile(AFilename : string);
    procedure Play;
    procedure Stop;
    property OnStart : TNotifyEvent read FOnStart write SetOnStart;
    property OnStop : TNotifyEvent read FOnStop write SetOnStop;
    property Channel : cint read FChannel write FChannel;
  end;

implementation

uses FileUtil, LazFileUtils, session.pool, sdl.app.audio;

{ TChunk }

procedure TChunk.DoOnStop;
begin
  if Assigned(OnStop) then
    OnStop(Self);
end;

procedure TChunk.SetOnStart(AValue: TNotifyEvent);
begin
  if FOnStart = AValue then Exit;
  FOnStart := AValue;
end;

procedure TChunk.SetOnStop(AValue: TNotifyEvent);
begin
  if FOnStop = AValue then Exit;
  FOnStop := AValue;
end;

constructor TChunk.Create;
begin
  FOnStart := nil;
  FOnStop := nil;
end;

destructor TChunk.Destroy;
begin
  Mix_FreeChunk(FChunk);
  inherited Destroy;
end;

function TChunk.Duration: cuint32;
begin
  Result := FChunk^.alen;
end;

function TChunk.Playing: Boolean;
begin
  Result := Mix_Playing(Channel) <> 0;
end;

function TChunk.ShortName: string;
begin
  Result := ExtractFileNameWithoutExt(ExtractFileNameOnly(FFilename));
end;

function TChunk.AsInterface: ISound;
begin
  Result := Self as ISound;
end;

procedure TChunk.LoadFromFile(AFilename: string);
var
  Media : PAnsiChar;
begin
  Media := PAnsiChar(Pool.RootMedia+AFilename);
  FChunk := Mix_LoadWAV(Media);
  if FChunk <> nil then begin
    FFilename := Pool.RootMedia+AFilename;
  end;
end;

procedure TChunk.Play;
begin
  if Assigned(OnStart) then OnStart(Self);
  Mix_PlayChannel(FChannel, FChunk, 0);
end;

procedure TChunk.Stop;
begin
  Mix_HaltChannel(FChannel);
end;

end.


