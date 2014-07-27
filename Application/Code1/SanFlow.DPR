program SanFlow;

uses
  Forms,
  fmMain in 'fmMain.pas' {frmMain},
  fmAbout in 'fmAbout.pas' {frmAbout},
  fmZoneConstants in 'fmZoneConstants.pas' {frmZoneConstants},
  fmZoneVariables in 'fmZoneVariables.pas' {frmZoneVariables},
  fmBackgroundLosses in 'fmBackgroundLosses.pas' {frmBackgroundLosses},
  fmNormalNightUse in 'fmNormalNightUse.pas' {frmNormalNightUse},
  uGlobals in 'uGlobals.pas',
  fmSplash in 'fmSplash.pas' {frmSplash},
  fmMeteredEditor in 'fmMeteredEditor.pas' {MeteredEditorFm},
  fmUnMeteredEditor in 'fmUnMeteredEditor.pas' {frmUnMeteredEditor},
  fmGraph in 'fmGraph.pas' {frmGraph},
  fmReport in 'fmReport.pas' {frmReport},
  fmStats in 'fmStats.pas' {frmStats},
  uVersion in 'uVersion.pas';

{$R *.RES}

begin
  Application.Initialize;
  frmSplash := TfrmSplash.Create(Application);
  frmSplash.Show;
  frmSplash.Update;

  Application.HelpFile := 'sanflow';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmZoneConstants, frmZoneConstants);
  Application.CreateForm(TfrmZoneVariables, frmZoneVariables);
  //need to create so can move !!(see WMMove)
  Application.CreateForm(TfrmZoneVariables, frmZoneVariables);
  Application.CreateForm(TfrmBackgroundLosses, frmBackgroundLosses);
  Application.CreateForm(TfrmNormalNightUse, frmNormalNightUse);
  Application.CreateForm(TMeteredEditorFm, frmMeteredEditor);
  Application.CreateForm(TfrmUnMeteredEditor, frmUnMeteredEditor);
  Application.CreateForm(TfrmGraph, frmGraph);
  Application.CreateForm(TfrmReport, frmReport);
  Application.CreateForm(TfrmStats, frmStats);
  Application.Run;
end.
