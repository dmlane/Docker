all: .target

.target: Dockerfile files/video_import.sh
	docker build . -t davelux/syno-ffmpeg:latest
	docker push davelux/syno-ffmpeg:latest
	@touch .target
