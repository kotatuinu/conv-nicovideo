# ffmepgを使用して動画ファイルからMP3ファイルを生成するPowerShellスクリプト  
 主な目的は、ニコニコ動画からダウンロードした動画ファイル（ファイル名：<動画番号>.mp4）を、動画番号から動画情報を取得して、MP3ファイルに変換＋MP3タグIDを設定する。  
  
##使い方  
変換対象の動画ファイル、mp3ファイルを格納しているディレクトリを指定して、出力先ディレクトリに出力します。  
拡張子がmp3,mp4,swf,flvのファイルをffmpegで変換します。  
(拡張子を含まない)ファイル名が、nm,smで始まるとき、ニコニコ動画APIの動画情報取得を使用して、タイトルや製作者名を取得。MP3タグIDに設定します。album名は”VOCALOID”固定。  
  
ffmpegのディレクトリは、スクリプトの以下に埋め込んであるので、適宜、書き換えてください。  
  
`set-variable -name FFMPEG_PATH -value "D:\tools\ffmpeg-20140228-git-669043d-win64-shared\bin" -option constant`  
  
  
`PS > get-nicovideo.ps1 -u <UserID> -p <Password> -o <Output Directory> -movie_no <Movie No>[,<Movie No>...]`  
-- -i : 変換対象の動画ファイル、mp3ファイルを格納しているディレクトリ  
-- -o : 出力先ディレクトリ  
-- -movie_no : ダウンロードしたい動画番号。カンマで区切ることで複数指定可能  
