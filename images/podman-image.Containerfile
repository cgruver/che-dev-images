FROM registry.access.redhat.com/ubi9/ubi-minimal

ARG USER_HOME_DIR="/home/user"
ARG WORK_DIR="/projects"

ENV HOME=${USER_HOME_DIR}
ENV BUILDAH_ISOLATION=chroot
COPY --chown=0:0 entrypoint.sh /
# Note: compat-openssl11 & libbrotli are needed for che-code (Che build of VS Code)

RUN microdnf --disableplugin=subscription-manager install -y openssl compat-openssl11 libbrotli git tar which shadow-utils bash zsh wget jq podman buildah skopeo; \
    microdnf update -y ; \
    microdnf clean all ; \
    mkdir -p ${USER_HOME_DIR} ; \
    mkdir -p ${WORK_DIR} ; \
    chgrp -R 0 /home ; \
    mkdir -p ${HOME}/.config/containers ; \
    mkdir ${HOME}/proc ; \
    (echo "[containers]";echo "netns=\"private\"";echo "volumes=[";echo "  \"${HOME}/proc:/proc:rw\"";echo "]";echo "default_sysctls = []";echo "[engine]";echo "network_cmd_options=[";echo "  \"enable_ipv6=false\"";echo "]") > ${HOME}/.config/containers/containers.conf ; \
    setcap cap_setuid+ep /usr/bin/newuidmap ; \
    setcap cap_setgid+ep /usr/bin/newgidmap ; \
    touch /etc/subgid /etc/subuid ; \
    chmod -R g=u /etc/passwd /etc/group /etc/subuid /etc/subgid /home ${WORK_DIR}

WORKDIR ${WORK_DIR}
ENTRYPOINT [ "/entrypoint.sh" ]