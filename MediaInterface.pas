// Copyright(C) Lord Dr. Andrei J. Sagura II von Orechov. All rights reserved.

unit MediaInterface;

interface

uses Windows, Messages;

{$EXTERNALSYM aboutMediaPlayer}
function aboutMediaPlayer : shortString; stdcall;

{$EXTERNALSYM loadMediaFile}
function loadMediaFile(FileName : shortString; aHandle : THandle) : shortString; stdcall;

{$EXTERNALSYM MediaStreamAvailable}
function MediaStreamAvailable : boolean; stdcall;

{$EXTERNALSYM VideoAvailable}
function VideoAvailable : boolean; stdcall;

{$EXTERNALSYM MediaStreamPlayed}
function MediaStreamPlayed : boolean; stdcall;

{$EXTERNALSYM getCoupledVideoHeight}
function getCoupledVideoHeight(Width : integer) : integer; stdcall;

{$EXTERNALSYM getVideoWidth}
function getVideoWidth : integer; stdcall;

{$EXTERNALSYM getVideoHeight}
function getVideoHeight : integer; stdcall;

{$EXTERNALSYM getMediaStreamDuration}
function getMediaStreamDuration : int64; stdcall;

{$EXTERNALSYM setVideoPos}
function setVideoPos(aLeft, aTop, aWidth, aHeight : integer) : BOOL; stdcall;

{$EXTERNALSYM playMediaStream}
function playMediaStream : BOOL; stdcall;

{$EXTERNALSYM pauseMediaStream}
function pauseMediaStream : BOOL; stdcall;

{$EXTERNALSYM stopMediaStream}
function stopMediaStream : BOOL; stdcall;

{$EXTERNALSYM setMediaStreamPos}
function setMediaStreamPos(pos : int64) : BOOL; stdcall;

{$EXTERNALSYM getMediaStreamPos}
function getMediaStreamPos : int64; stdcall;

{$EXTERNALSYM freeMediaStream}
function freeMediaStream : BOOL; stdcall;

{$EXTERNALSYM freeMediaStream}
function resetMediaStream : BOOL; stdcall;

{$EXTERNALSYM setFullScreenVideo}
function setFullScreenVideo(Full : BOOL) : BOOL; stdcall;

{$EXTERNALSYM getFullScreenVideo}
function getFullScreenVideo : BOOL; stdcall;

{$EXTERNALSYM registerFileType}
procedure registerFileType(aFileType, key, desc, icon, aApplication : shortString); stdcall;

{$EXTERNALSYM deregisterFileType}
procedure deregisterFileType(aFileType : shortString); stdcall;

{$EXTERNALSYM getSpecialFolderName}
function getSpecialFolderName(aHandle : THandle; nFolder : integer) : shortString; stdcall;

{$EXTERNALSYM SoundChipAvailable}
function SoundChipAvailable : boolean; stdcall;

{$EXTERNALSYM getWaveOutVolume}
function getWaveOutVolume : integer; stdcall;

{$EXTERNALSYM setWaveOutVolume}
procedure setWaveOutVolume(Volume : cardinal); stdcall;

{$EXTERNALSYM lnVolume}
function lnVolume(aVolume : integer; aDecades : integer = 1) : integer; stdcall;

{$EXTERNALSYM expVolume}
function expVolume(aVolume : integer; aDecades : integer = 1) : integer; stdcall;

{$EXTERNALSYM NotifyOwnerMessage}
function NotifyOwnerMessage(aHandle : THandle; aMsg : TMessage): HResult; stdcall;

const
  mplayer = 'mediaplr.dll';

implementation

function aboutMediaPlayer; external mplayer;
function loadMediaFile; external mplayer;
function MediaStreamAvailable; external mplayer;
function VideoAvailable; external mplayer;
function MediaStreamPlayed; external mplayer;
function getCoupledVideoHeight; external mplayer;
function getVideoWidth; external mplayer;
function getVideoHeight; external mplayer;
function getMediaStreamDuration; external mplayer;
function setVideoPos; external mplayer;
function playMediaStream; external mplayer;
function pauseMediaStream; external mplayer;
function stopMediaStream; external mplayer;
function setMediaStreamPos; external mplayer;
function getMediaStreamPos; external mplayer;
function setFullScreenVideo; external mplayer;
function getFullScreenVideo; external mplayer;
function freeMediaStream; external mplayer;
function resetMediaStream; external mplayer;
function NotifyOwnerMessage; external mplayer;

procedure registerFileType; external mplayer;
procedure deregisterFileType; external mplayer;
function getSpecialFolderName; external mplayer;

function SoundChipAvailable; external mplayer;
function getWaveOutVolume; external mplayer;
procedure setWaveOutVolume; external mplayer;
function lnVolume; external mplayer;
function expVolume; external mplayer;

end.

