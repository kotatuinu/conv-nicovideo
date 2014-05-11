set-variable -name FFMPEG_PATH -value "D:\tools\ffmpeg-20140228-git-669043d-win64-shared\bin" -option constant
set-variable -name FFMPEG -value "ffmpeg.exe" -option constant
set-variable -name NICOVIDEO_API -value "http://ext.nicovideo.jp/api/getthumbinfo/" -option constant


# Usage
$Usages = @(
	"Niconicovideo's Movie Number Named files(mp4,flv,swf) convert MP3, and MP3 File(Movie Number Named) set MP3 TAG ID.";
	"Output MP3 File Name <Title>_<MovieNumber>.mp3.";
	" Usage : $MyInvocation.MyCommand.Name  -i <InputPath> -o <OutputPath>";
	"  OPTIONS";
	"  -i : InputFiles Directory.";
	"  -o : Output Directory.";
)

function Output-Usage {
	$Usages
}


$ArgMap = @{ "-i" = ""; "-o" = ""}

#Argument Get & Check
function Get-Argument($ArgList) {
	if($ArgList.Count -lt $ArgMap.Count*2) {
		return $false
	}

	$ArgKey=""
	$ArgList | ForEach-Object {
		if($ArgKey -eq "") {
			if($ArgMap.ContainsKey($_)) {
				$ArgKey=$_
			} else {
				return $false
			}
		} else {
			$ArgMap[$ArgKey]=$_
			$ArgKey=""
		}
	}
	return $true
}


#“®‰æ”Ô†‚©‚ç“®‰æî•ñiXMLj‚ðŽæ“¾
function Get-NicoInfo($movie_no) {
	$uri="$NICOVIDEO_API$movie_no"
	$encode_utf8 = [Text.Encoding]::GetEncoding("utf-8")
	$wc = New-Object System.Net.WebClient
	$wc.Encoding=$encode_utf8

	#
	return [xml]$wc.DownloadString($uri)
}


if(-not(Get-Argument($Args))){
	[Console]::WriteLine("ERROR: Invalid Arguments.")
	Output-Usage
	exit
}

if(-not(Test-Path -LiteralPath $ArgMap["-i"] -PathType Container)) {
	[Console]::WriteLine("ERROR: Not Exist InputDirectory.")
	Out-Usage
	exit
}
if(-not(Test-Path -LiteralPath $ArgMap["-o"] -PathType Container)) {
	[Console]::WriteLine("ERROR: Not Exist OutputDirectory.")
	Out-Usage
	exit
}

if($ArgMap["-i"].LastIndexOf("\")+1 -eq $ArgMap["-i"].Length) {
	$ArgMap["-i"].Remove($ArgMap["-i"].LastIndexOf("\"), 1)
}
if($ArgMap["-o"].LastIndexOf("\")+1 -eq $ArgMap["-o"].Length) {
	$ArgMap["-o"].Remove($ArgMap["-o"].LastIndexOf("\"), 1)
}

$inPath = $ArgMap["-i"]
$outPath = $ArgMap["-o"]

Get-ChildItem $ArgMap["-i"] | Where-Object { $_.Name -match '((.+)\.(mp3|mp4|swf|flv))'} | ForEach-Object {

	$file_name = $Matches[0];
	$name = $Matches[2];
	$ext = $Matches[3];

	if($file_name -match '(((sm|nm)\d+)(|_low)\.(mp3|mp4|swf|flv))') {

		# Get Movie Info by movie no.
		$movie_no = $Matches[2];

		$xmldata = Get-NicoInfo($movie_no)

		if($xmldata.nicovideo_thumb_response.status -eq "ok") {

			$title = $xmldata.nicovideo_thumb_response.thumb.title -replace "[/?:*`"><|\\]", ""
			$user_nickname = $xmldata.nicovideo_thumb_response.thumb.user_nickname
			$year = Get-Date $xmldata.nicovideo_thumb_response.thumb.first_retrieve -Format "yyyy"

			$id_tag = "-metadata title=`"${title}`" -metadata year=`"${year}`" -metadata creator=`"${user_nickname}`" -metadata album=`"VOCALOID`" -id3v2_version 3"
			$output_file = "${movie_no}_${title}.mp3"

		} else {

			Write-Output "Movie[${movie_no}] deleted. FileName = ${filename}"
			$id_tag = "-metadata title=`"${name}`" -metadata album=`"VOCALOID`" -id3v2_version 3"
			$output_file = "${movie_no}.mp3"
		}

	} else {
		$id_tag = "-metadata title=`"${name}`" -metadata album=`"VOCALOID`" -id3v2_version 3"
		if($file_name -match '(.+?)\.(mp3|mp4|swf|flv)') {
			$output_file = $Matches[1] + ".mp3"
		} else {
			continue
		}
	}

	if($ext -ne "mp3") {
		# When not mp3 file, convert mp3.
		$mp3_cnv = "-ar 48000 -ab 128k -f mp3"
	} else {
		$mp3_cnv = ""
	}

	$command = "${FFMPEG_PATH}\${FFMPEG} -y -i `"${inPath}\${file_name}`" ${id_tag} ${mp3_cnv} `"${outPath}\${output_file}`""

	Write-Output $command
	Invoke-Expression $command

}
