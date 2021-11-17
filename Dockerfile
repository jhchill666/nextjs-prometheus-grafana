FROM node:14-alpine3.12 as builder
ARG NPMRC
WORKDIR /app
COPY package.json yarn.lock .npmrc ./
RUN echo "${NPMRC}" >> .npmrc
RUN yarn install --non-interactive --frozen-lockfile
COPY . .
# RUN yarn lint
# RUN yarn check-types
# audit's exit code is affected by level, 8 and above means high and/or critical vulnerabilities exist
# https://yarnpkg.com/lang/en/docs/cli/audit/
# RUN yarn audit --groups dependencies --level high; [[ "$?" -ge 8 ]] && exit 1 || exit 0;
ARG BEAUTYPIE_BRANCH_NAME
ENV BEAUTYPIE_BRANCH_NAME=${BEAUTYPIE_BRANCH_NAME}
ARG NEXT_PUBLIC_BPAPI_BACKEND
ENV NEXT_PUBLIC_BPAPI_BACKEND=${NEXT_PUBLIC_BPAPI_BACKEND}
# RUN yarn test
ARG CONTENTFUL_SPACE_ID
ARG CONTENTFUL_DELIVERY_API_KEY
ARG CONTENTFUL_MANAGEMENT_API_KEY
# RUN yarn migrate

ARG NEXT_PUBLIC_BPAPI_URI
ENV NEXT_PUBLIC_BPAPI_URI=${NEXT_PUBLIC_BPAPI_URI}

ARG NEXT_PUBLIC_API_URI_INTERNAL
ENV NEXT_PUBLIC_API_URI_INTERNAL=${NEXT_PUBLIC_API_URI_INTERNAL}

ENV NEXT_PUBLIC_ENABLE_PROMETHEUS=true

ARG NEXT_PUBLIC_LD_CLIENT_ID
ENV NEXT_PUBLIC_LD_CLIENT_ID=${NEXT_PUBLIC_LD_CLIENT_ID}

# ENV NODE_OPTIONS --max-old-space-size=4000
RUN yarn prodbuild
# RUN [ "${BEAUTYPIE_BRANCH_NAME}" != "main" ] && LOG_LEVEL=3 node contentful/scripts/delete-environment.js || true
RUN yarn install --production --non-interactive --frozen-lockfile
# RUN yarn install --production --non-interactive
RUN yarn patch

FROM node:14-alpine3.12
ARG NPMRC
WORKDIR /app
ENV NODE_ENV production
# 3072mb - 400mb for other processes
# ENV NODE_OPTIONS --max-old-space-size=2672
RUN addgroup -S beautypie && adduser -S beautypie -G beautypie
USER beautypie
COPY --from=builder --chown=beautypie:beautypie /app .

# ARG ROBOTS_FILE_OVERRIDE
# RUN [ ! -z "${ROBOTS_FILE_OVERRIDE}" ] && echo -e "${ROBOTS_FILE_OVERRIDE}" > public/robots.txt || true

ARG BEAUTYPIE_BRANCH_NAME
ENV BEAUTYPIE_BRANCH_NAME=${BEAUTYPIE_BRANCH_NAME}

ARG GIT_COMMIT_SHA
ENV GIT_COMMIT_SHA=${GIT_COMMIT_SHA}

EXPOSE 3000
EXPOSE 9229

CMD ["yarn", "start"]
