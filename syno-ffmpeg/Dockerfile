from jrottenberg/ffmpeg:latest
COPY files/ /usr/local/bin
RUN chmod 755 /usr/local/bin/*.sh
ENTRYPOINT ["/usr/local/bin/video_import.sh"]
