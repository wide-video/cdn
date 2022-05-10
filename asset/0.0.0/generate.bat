echo invalid media > invalid.txt

ffmpeg -hide_banner -filter_complex "smptehdbars=size=1280x720:rate=30000/1001,drawtext=fontfile=c\\:/Windows/Fonts/arial.ttf:timecode=00\\:00\\:00.00:rate=30000/1001:fontsize=72:fontcolor=white:x=(w-tw)/2:y=10*h/100:box=1:boxcolor=0x00000000@1[vout];sine=frequency=440:sample_rate=48000:beep_factor=2[aout]" -map [vout] -map [aout] -t 00:01:00.000 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y "bars_h264_1280x720_30fps_aac_stereo_60s_1MB.mp4"

ffmpeg -hide_banner -filter_complex "sine=frequency=440:sample_rate=48000:beep_factor=2" -t 00:01:00.000 -c:a aac -ac 2 "beep_aac_stereo_60s_0MB.aac"

ffmpeg -f lavfi -i color=color=ff0000:size=512x512:rate=240 -f lavfi -i color=color=00000000:size=512x512:rate=240 -filter_complex "[1]drawbox=x=0:y=(ih-60)/2:width=iw:height=60:color=00ff00:thickness=60,rotate=n/240*PI[r];[0][r]overlay" -f lavfi -i sine=frequency=440:sample_rate=48000:beep_factor=2 -t 00:01:00.000 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y  rotator_h264_512x512_240fps_aac_stereo_60s_6MB.mp4 -y

ffmpeg -f lavfi -i color=color=ffffff:size=500x500:rate=10:duration=3 -filter_complex "[0]rotate=n/60*PI,split[a][b];[a][b]alphamerge,split[a][b];[a]palettegen=reserve_transparent=on[p];[b][p]paletteuse" rotator_gif_500x500_0MB.gif -y

ffmpeg -i rotator_gif_500x500_0MB.gif -c libvpx -pix_fmt yuva420p -auto-alt-ref 0 rotator_vp8_500x500_0MB.webm -y

curl https://files.freemusicarchive.org/storage-freemusicarchive-org/music/Creative_Commons/Sean_Fournier/Sean_Fournier_-_Singles/Sean_Fournier_-_06_-_Falling_For_You_Piano_Version.mp3 --output sf_mp3_stereo_203s_4MB.mp3

REM .aac does not exist https://trac.ffmpeg.org/ticket/9708
REM ffmpeg -i sf_mp3_stereo_203s_4MB.mp3 -vn -acodec aac sf_aac_stereo_218s_3MB.aac

ffmpeg -i sf_mp3_stereo_203s_4MB.mp3 -vn -acodec aac sf_aac_stereo_203s_3MB.m4a

curl http://ftp.nluug.nl/pub/graphics/blender/demo/movies/BBB/bbb_sunflower_1080p_60fps_normal.mp4 --output bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=30,scale=1280x720" -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_h264_1280x720_30fps_aac_stereo_30s_4MB.mp4

ffmpeg -ss 306 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "scale=960x540" -t 20 -c:v libx264 -pix_fmt:v yuv420p -preset:v veryslow -c:a copy -ac 2 -f mp4 -movflags +faststart -y bbb_h264_960x540_60fps_mp3_stereo_20s_4MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=10" -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_h264_1920x1080_10fps_aac_stereo_30s_7MB.mp4

REM do not modify, used for performance test!
ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v medium -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_h264_1920x1080_60fps_aac_stereo_30s_11MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=25,scale=1280x720" -t 30 -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 6 -f mp4 -movflags +faststart -y bbb_h264_1280x720_25fps_aac_51_30s_5MB.mp4

ffmpeg -ss 45 -i bbb_h264_1920x1080_60fps_mp3_stereo_ac3_51_634s_355MB.mp4 -vf "fps=25,scale=640x360" -t 5 -c:v libaom-av1 -c:a aac -ac 2 -f mp4 -movflags +faststart -y bbb_av1_640x360_25fps_aac_stereo_5s_0MB.mp4

curl http://ftp.nluug.nl/pub/graphics/blender/demo/movies/Sintel.2010.1080p.mkv --output sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -t 30 -y sintel_h264_1920x818_24fps_aac_stereo_30s_6MB.mp4

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v libx264 -pix_fmt:v yuv420p -crf:v 23 -profile:v high -preset:v veryslow -c:a ac3 -ac 2 -f mp4 -movflags +faststart -t 30 -y sintel_h264_1920x818_24fps_ac3_stereo_30s_6MB.mp4

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -vn -c:a ac3 -ac 2 -t 30 -y sintel_ac3_stereo_30s_1MB.ac3

ffmpeg -i sintel_h264_1920x818_24fps_aac_stereo_30s_7MB.mp4 -c copy -an sintel_h264_1920x818_24fps_30s_7MB.mp4

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v libx265 -crf:v 26 -preset:v veryslow -bf 0 -c:a aac -ac 2 -f mp4 -movflags +faststart -t 30 -y sintel_h265_1920x818_24fps_aac_stereo_30s_4MB.mp4

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v libvpx -c:a libvorbis -ac 2 -t 30 -y sintel_vp8_1920x818_24fps_vorbis_stereo_30s_1MB.webm

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v libvpx-vp9 -crf 30 -c:a libopus -ac 2 -t 30 -y sintel_vp9_1920x818_24fps_opus_stereo_30s_5MB.webm

ffmpeg -ss 120 -i sintel_h264_1920x818_24fps_ac3_51_888s_1172MB.mkv -c:v mpeg1video -c:a mp2 -ac 2 -t 30 -y sintel_mpeg1_1920x818_24fps_mp2_stereo_30s_5MB.mpg

curl http://ftp.nluug.nl/pub/graphics/blender/demo/movies/ToS/tears_of_steel_1080p.mov --output tos_h264_1920x800_24fps_mp3_stereo_734s_583MB.mov

ffmpeg -ss 555 -i tos_h264_1920x800_24fps_mp3_stereo_734s_583MB.mov -vf "scale=1280:-2" -t 10 -c:v libx264 -pix_fmt:v yuv420p -preset:v veryslow -c:a aac -ac 2 -f mp4 -movflags +faststart -y tos_h264_1280x534_24fps_aac_stereo_10s_5MB.mp4

REM wrong name
REM ffmpeg -i tos_h264_1920x800_24fps_mp3_stereo_734s_583MB.mov -vf "scale=640:-2" -c:v libx265 -b:v 120k -pix_fmt:v yuv420p -c:a aac -ac 2 -f mp4 -y tos_h264_640x266_aac_stereo_734s_23MB.mp4

ffmpeg -i tos_h264_1920x800_24fps_mp3_stereo_734s_583MB.mov -vf "scale=640:-2" -c:v libx265 -b:v 120k -pix_fmt:v yuv420p -c:a aac -ac 2 -f mp4 -y tos_h265_640x266_aac_stereo_734s_23MB.mp4

curl https://download.blender.org/demo/movies/ToS/subtitles/TOS-en.srt --output tos_en_0MB.srt

curl http://ftp.nluug.nl/pub/graphics/blender/demo/movies/BBB/bbb_sunflower_2160p_60fps_normal.mp4 --output bbb_h264_3840x2160_60fps_mp3_stereo_ac3_51_634s_673MB.mp4