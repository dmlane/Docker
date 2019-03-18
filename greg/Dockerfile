from alpine:latest 
RUN apk update && apk add \
	bash\
	ca-certificates \
	python3 \
	&& python3 -m ensurepip \
	&& pip3 install greg stagger
COPY greg.conf /tmp/
COPY greg.sh /tmp/
COPY greg_extract.awk /tmp/
COPY greg_process.sh /tmp/
RUN mv /tmp/greg.conf $(find /usr/lib -name greg.conf)
ENTRYPOINT ["/tmp/greg_process.sh"]
CMD [""]

