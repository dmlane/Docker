FROM percona/percona-server:5.6 as percona-server

# The standard image is great, but we want stadard uid and gids for consistency
USER root
ARG USER_ID=27
ARG GROUP_ID=27
RUN /bin/find /  -mount -user mysql -exec chown ${USER_ID} {} \; \
	&& /bin/find /  -mount -group mysql -exec chgrp ${GROUP_ID} {} \; \
	&& usermod -u ${USER_ID}  mysql \
	&& groupmod -g ${GROUP_ID} mysql
#USER mysql
