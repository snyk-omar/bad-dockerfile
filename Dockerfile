FROM centos:centos7.2.1511
LABEL maintainer=adrianp@stindustries.net

# If you need to use a proxy to get to the internet, build with:
#   docker build --build-arg CURL_OPTIONS="..."
#
# The default is empty (no special options).
#
ARG CURL_OPTIONS=""

# Prep environment
#
RUN yum -y install deltarpm && yum -y update

# Install build utils
#
RUN touch /var/lib/rpm/* && \
    yum -y install bison gnutls-devel gcc libidn-devel gcc-c++ bzip2 java-1.8.0-openjdk-devel wget  && \
    yum clean all

# drupal - PHP application (manual install)
#
# http://www.cvedetails.com/vulnerability-list/vendor_id-1367/product_id-2387/version_id-192973/Drupal-Drupal-7.42.html
#
RUN curl -LO ${CURL_OPTIONS} \
      https://ftp.drupal.org/files/projects/drupal-7.42.tar.gz && \
    tar zxf drupal-7.42.tar.gz && \
    mkdir /opt/drupal && \
    cd drupal-7.42 && \
    cp -R . /opt/drupal && \
    cd - && \
    rm -rf drupal-7.42 && \
    rm -f *.tar.gz

# tomcat - Java application (RPM install)
#
# CVE-2013-4590, CVE-2014-0119, CVE-2014-0099, CVE-2014-0096, CVE-2014-0075
#
RUN curl -LO ${CURL_OPTIONS} \
      http://vault.centos.org/7.0.1406/os/x86_64/Packages/tomcat-7.0.42-4.el7.noarch.rpm && \
    curl -LO ${CURL_OPTIONS} \
      http://vault.centos.org/7.0.1406/os/x86_64/Packages/tomcat-el-2.2-api-7.0.42-4.el7.noarch.rpm && \
    curl -LO ${CURL_OPTIONS} \
      http://vault.centos.org/7.0.1406/os/x86_64/Packages/tomcat-jsp-2.2-api-7.0.42-4.el7.noarch.rpm && \
    curl -LO ${CURL_OPTIONS} \
      http://vault.centos.org/7.0.1406/os/x86_64/Packages/tomcat-lib-7.0.42-4.el7.noarch.rpm && \
    curl -LO ${CURL_OPTIONS} \
      http://vault.centos.org/7.0.1406/os/x86_64/Packages/tomcat-servlet-3.0-api-7.0.42-4.el7.noarch.rpm && \
    touch /var/lib/rpm/* && \
    yum -y install yum install tomcat-7.0.42-4.el7.noarch.rpm tomcat-lib-7.0.42-4.el7.noarch.rpm tomcat-servlet-3.0-api-7.0.42-4.el7.noarch.rpm tomcat-el-2.2-api-7.0.42-4.el7.noarch.rpm tomcat-jsp-2.2-api-7.0.42-4.el7.noarch.rpm && \
    rm -f *.rpm

# Precautionary failure with messages
#
CMD echo 'Vulnerable image' && /bin/false

# Basic labels.
# http://label-schema.org/
#
LABEL \
    org.label-schema.name="bad-dockerfile" \
    org.label-schema.description="Reference Dockerfile containing software with known vulnerabilities." \
    org.label-schema.url="http://www.stindustries.net/docker/bad-dockerfile/" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/ianmiell/bad-dockerfile" \
    org.label-schema.docker.dockerfile="/Dockerfile"
