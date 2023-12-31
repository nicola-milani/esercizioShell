# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

FROM --platform=linux/arm64 ubuntu:jammy AS installer-env

    ARG PS_VERSION=7.3.8
    ENV PS_PACKAGE=powershell-${PS_VERSION}-linux-arm64.tar.gz
    ENV PS_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/${PS_PACKAGE}
    ARG PS_INSTALL_VERSION=7
    
    # define the folder we will be installing PowerShell to
    ENV PS_INSTALL_FOLDER=/opt/microsoft/powershell/$PS_INSTALL_VERSION

    # Create the install folder
    RUN mkdir -p ${PS_INSTALL_FOLDER}

    ARG PS_PACKAGE_URL_BASE64

    RUN apt-get update \
        && apt-get install --no-install-recommends ca-certificates wget --yes

    RUN echo 'in task' \
        && if [ -n "${PS_PACKAGE_URL_BASE64}" ]; then \
            echo 'using base64' \
            && export url=$(echo "${PS_PACKAGE_URL_BASE64}" | base64 --decode -);\
        else \
            echo 'using unencoded' \
            && export url="${PS_PACKAGE_URL}"; \
        fi \
        && echo "url: $url" \
        && wget -O /tmp/powershell.tar.gz "$url" \
        && echo 'task done'

    RUN ls -l /tmp/powershell.tar.gz

        # Unzip the Linux tar.gz
    RUN tar zxf /tmp/powershell.tar.gz -C ${PS_INSTALL_FOLDER}

FROM --platform=linux/arm64 ubuntu:jammy AS final-image

    # Define Args and Env needed to create links
    ARG PS_INSTALL_VERSION=7
    ARG PS_VERSION=7.2.4
    RUN apt update && apt install -y locales
    RUN locale-gen --purge it_IT.UTF-8
    ENV PS_INSTALL_FOLDER=/opt/microsoft/powershell/$PS_INSTALL_VERSION \
        \
        # Define ENVs for Localization/Globalization
        DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
        LC_ALL=it_IT.UTF-8 \
        LANG=it_IT.UTF-8 \
        LANGUAGE=it_IT.UTF-8 \
        LC_CTYPE=it_IT.UTF-8 \
        # set a fixed location for the Module analysis cache
        PSModuleAnalysisCachePath=/var/cache/microsoft/powershell/PSModuleAnalysisCache/ModuleAnalysisCache \
        POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-arm64v7-Ubuntu-22.04

    # Copy only the files we need from the previous stage
    COPY --from=installer-env ["/opt/microsoft/powershell", "/opt/microsoft/powershell"]


    RUN \
    apt-get update \
    && apt-get install --no-install-recommends sudo ca-certificates libunwind8 libssl3 libicu70 less --yes

        # Give all user execute permissions and remove write permissions for others
    RUN chmod a+x,o-w ${PS_INSTALL_FOLDER}/pwsh \
        # Create the pwsh symbolic link that points to powershell
        && ln -s ${PS_INSTALL_FOLDER}/pwsh /usr/bin/pwsh
    # Create user and setup permissions on /etc/sudoers
    ARG USER=scripter
    ARG UID=1010
    ARG GID=110
    RUN useradd -m -s /opt/microsoft/powershell -N -u $UID $USER && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    chmod g+w /etc/passwd 
    USER scripter
    # Use PowerShell as the default shell
    # Use array to avoid Docker prepending /bin/sh -c
    CMD [ "bash" ]