ARG BASE_IMAGE=icr.io/appcafe/open-liberty:kernel-slim-java8-openj9-ubi

FROM $BASE_IMAGE

# Config
COPY --chown=1001:0 src/main/liberty/config/server.xml /config/server.xml
COPY --chown=1001:0 src/main/liberty/config/server.env /config/server.env
COPY --chown=1001:0 src/main/liberty/config/jvm.options /config/jvm.options
COPY --chown=1001:0 src/main/liberty/config/bootstrap.properties /config/bootstrap.properties

# App
COPY --chown=1001:0 target/acmeair-bookingservice-java-6.0.war /config/apps/

User root

      
user 1001

# Setting for the verbose option
ARG VERBOSE=true
ARG FULL_IMAGE=false

# This script will add the requested XML snippets to enable Liberty features and grow image to be fit-for-purpose using featureUtility. 
# Only available in 'kernel-slim'. The 'full' tag already includes all features for convenience.

RUN if [ "$FULL_IMAGE" = "true" ] ; then echo "Skip running features.sh for full image" ; else features.sh ; fi


# Logging vars
ENV LOGGING_FORMAT=simple
ENV ACCESS_LOGGING_ENABLED=false
ENV TRACE_SPEC=*=info

# Build SCC?
ARG CREATE_OPENJ9_SCC=false
ARG SKIP_FEATURE_INSTALL=false
ENV OPENJ9_SCC=false
ARG VERBOSE=true
RUN configure.sh
