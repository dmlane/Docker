from alpine:latest 
RUN apk update && apk add \
	bash\
	ca-certificates \
	python3 \
	&& python3 -m ensurepip \
	&& pip3 install greg stagger
ENV BUILD_DATE 20190318
COPY greg.conf /tmp/
COPY greg.sh /tmp/
COPY wget.sh /tmp/
COPY greg_extract.awk /tmp/
COPY greg_process.sh /tmp/
RUN mv /tmp/greg.conf $(find /usr/lib -name greg.conf)
ENTRYPOINT ["/tmp/greg_process.sh"]
CMD [""]

