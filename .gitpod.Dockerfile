FROM gitpod/workspace-full

USER root

SHELL [ "/bin/bash", "-c" ]

# Install shellcheck
RUN set -eux; \
  wget https://storage.googleapis.com/shellcheck/shellcheck-stable.linux.x86_64.tar.xz; \
  tar xf shellcheck-stable.linux.x86_64.tar.xz; \
  mv shellcheck-stable/shellcheck /usr/local/bin; \
  rm -rf shellcheck-stable*

# More information: https://www.gitpod.io/docs/42_config_docker/
