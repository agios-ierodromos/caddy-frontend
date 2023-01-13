FROM caddy:2.6.2-builder-alpine AS cache

ENV CADDY_VERSION v2.6.2 

# github.com/crewjam/saml replacement needed as a hotfix,
# see https://github.com/greenpau/caddy-security/issues/196#issuecomment-1367649033
RUN export XCADDY_SKIP_CLEANUP=1 && \
    export XCADDY_SKIP_BUILD=1 && \
    xcaddy build \
        --with github.com/caddyserver/transform-encoder \
        --with github.com/WingLim/caddy-webhook \
        --with github.com/greenpau/caddy-security@v1.1.17 \
        --with github.com/crewjam/saml@v0.4.10=github.com/greenpau/origin_crewjam_saml@v0.4.11-0.20221229165346-936eba92623a

FROM cache AS builder

# github.com/crewjam/saml replacement needed as a hotfix,
# see https://github.com/greenpau/caddy-security/issues/196#issuecomment-1367649033
RUN xcaddy build \
        --with github.com/caddyserver/transform-encoder \
        --with github.com/WingLim/caddy-webhook \
        --with github.com/greenpau/caddy-security@v1.1.17 \
        --with github.com/crewjam/saml@v0.4.10=github.com/greenpau/origin_crewjam_saml@v0.4.11-0.20221229165346-936eba92623a

FROM caddy:2.6.2-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
