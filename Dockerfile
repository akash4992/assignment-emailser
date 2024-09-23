# Use Ubuntu as the base image
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    postfix \
    dovecot-core \
    dovecot-imapd \
    dovecot-lmtpd \
    supervisor \
    mailutils \
    libcap2-bin \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Configure Postfix
RUN postconf -e "inet_interfaces = all" && \
    postconf -e "inet_protocols = all" && \
    postconf -e "mydestination = \$myhostname, localhost.\$mydomain, localhost" && \
    postconf -e "mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128" && \
    postconf -e "smtpd_use_tls = no" && \
    postconf -e "smtp_use_tls = no"

# Configure Dovecot
RUN sed -i 's/#disable_plaintext_auth = yes/disable_plaintext_auth = no/' /etc/dovecot/conf.d/10-auth.conf && \
    sed -i 's/auth_mechanisms = plain/auth_mechanisms = plain login/' /etc/dovecot/conf.d/10-auth.conf

# Create testuser
RUN useradd -m testuser && \
    echo "testuser:password" | chpasswd

# Create a new user with root-like privileges
RUN useradd -m adminuser && \
    echo "adminuser:password" | chpasswd && \
    usermod -aG sudo adminuser

# Grant adminuser passwordless sudo access
RUN echo "adminuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up mail directory
RUN mkdir -p /var/mail/testuser && \
    chown -R testuser:testuser /var/mail/testuser && \
    chmod -R 700 /var/mail/testuser

# Change ownership and permissions for supervisor logs
RUN mkdir -p /var/log/supervisor && \
    chown -R adminuser:adminuser /var/log/supervisor && \
    chmod -R 755 /var/log/supervisor

# Copy supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN sudo setcap cap_net_bind_service=eip /usr/bin/supervisord
# Expose ports
EXPOSE 25 143

CMD ["/usr/bin/supervisord", "-n"]
