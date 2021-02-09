FROM registry.access.redhat.com/ubi8:8.3 AS reposubi

FROM quay.io/openshift/origin-jenkins-agent-base:4.8

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
			org.label-schema.name="ocp-utils" \
			org.label-schema.description="Generates table of contents for markdown files inside local git repository." \
			org.label-schema.url="http://andradaprieto.es" \
			org.label-schema.vcs-ref=$VCS_REF \
			org.label-schema.vcs-url="https://github.com/jandradap/ocp-utils" \
			org.label-schema.vendor="Jorge Andrada Prieto" \
			org.label-schema.version=$VERSION \
			org.label-schema.schema-version="1.0" \
			maintainer="Jorge Andrada Prieto <jandradap@gmail.com>"

USER root

RUN rm -rf /etc/yum.repos.d/* \
  && dnf clean all 

COPY --from=reposubi /etc/yum.repos.d/ubi.repo /etc/yum.repos.d/ubi.repo

ENV JAVA_HOME="/usr/lib/jvm/jre-11-openjdk" \
  PATH=${PATH}:/usr/lib/jvm/jre-11-openjdk/bin/ \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8

RUN dnf install -y glibc-langpack-en \
  && echo -e "LC_ALL=en_US.UTF-8\nLC_CTYPE=en_US.UTF-8\nLANGUAGE=en_US.UTF-8" > /etc/environment

RUN dnf install -y \
      curl \
      wget \
      git \
      openssl \
      bash \
      ca-certificates \
  && dnf -y clean all \
  && rm -rf /var/cache/yum

USER 1001
