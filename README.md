# ffmepg���g�p���ē���t�@�C������MP3�t�@�C���𐶐�����PowerShell�X�N���v�g
 ��ȖړI�́A�j�R�j�R���悩��_�E�����[�h��������t�@�C���i�t�@�C�����F<����ԍ�>.mp4�j���A����ԍ����瓮������擾���āAMP3�t�@�C���ɕϊ��{MP3�^�OID��ݒ肷��B

##�g����
�ϊ��Ώۂ̓���t�@�C���Amp3�t�@�C�����i�[���Ă���f�B���N�g�����w�肵�āA�o�͐�f�B���N�g���ɏo�͂��܂��B
�g���q��mp3,mp4,swf,flv�̃t�@�C����ffmpeg�ŕϊ����܂��B
(�g���q���܂܂Ȃ�)�t�@�C�������Anm,sm�Ŏn�܂�Ƃ��A�j�R�j�R����API�̓�����擾���g�p���āA�^�C�g���␻��Җ����擾�BMP3�^�OID�ɐݒ肵�܂��Balbum���́hVOCALOID�h�Œ�B

ffmpeg�̃f�B���N�g���́A�X�N���v�g�̈ȉ��ɖ��ߍ���ł���̂ŁA�K�X�A���������Ă��������B

set-variable -name FFMPEG_PATH -value "D:\tools\ffmpeg-20140228-git-669043d-win64-shared\bin" -option constant


PS > get-nicovideo.ps1 -u <UserID> -p <Password> -o <Output Directory> -movie_no <Movie No>[,<Movie No>...]
-- -i : �ϊ��Ώۂ̓���t�@�C���Amp3�t�@�C�����i�[���Ă���f�B���N�g��
-- -o : �o�͐�f�B���N�g��
-- -movie_no : �_�E�����[�h����������ԍ��B�J���}�ŋ�؂邱�Ƃŕ����w��\



