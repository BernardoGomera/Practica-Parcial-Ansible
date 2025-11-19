FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apache2 \
        openssh-server \
        python3 \
        python3-apt \
        curl \
        vim-tiny \
        logrotate \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd /opt/bootstrap

RUN useradd -ms /bin/bash ops && \
    echo "ops:opsadmin" | chpasswd && \
    echo "root:OrbitPass!2025" | chpasswd

RUN sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN printf 'Managed by Ansible on %%s\n' $(date -u +%Y-%m-%d) > /var/www/html/index.html && \
    printf 'export COLORFGBG=default; printf "\nBienvenido a la granja edge administrada por Ansible.\n"\n' > /etc/profile.d/welcome.sh && \
    chmod +x /etc/profile.d/welcome.sh

RUN printf "OK\n" > /var/www/html/healthz

RUN printf '#!/bin/bash\nset -euo pipefail\nservice apache2 start\nexec /usr/sbin/sshd -D\n' > /usr/local/bin/boot.sh && \
    chmod +x /usr/local/bin/boot.sh

EXPOSE 22 80

CMD ["/usr/local/bin/boot.sh"]

