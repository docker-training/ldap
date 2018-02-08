FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y -q slapd ldap-utils phpldapadmin
RUN apt-get install -y curl

RUN curl -sSL https://gist.githubusercontent.com/BillMills/7a6e87d66f72d221d5b420351f3cb6f6/raw/158ea7b190219f6f3af6c8ef62e731fd277e46e9/docker-ldap-demo.sh | sh

RUN chown root:www-data /etc/phpldapadmin/config.php && \
    rm -r /var/lib/ldap/* && \
    rm -r /etc/ldap/slapd.d/* 
RUN slapadd -F /etc/ldap/slapd.d -b cn=config -l /tmp/config.ldif && \
    slapadd -l /tmp/data.ldif
RUN chown -R openldap:openldap /etc/ldap/slapd.d && \
    chown -R openldap:openldap /var/lib/ldap

ADD entrypoint.sh .

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]