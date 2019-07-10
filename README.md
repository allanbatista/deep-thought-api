# Deep Thought

Deep Thought is a project to make easy to create queries between diff data sources and create a beautiful visualizations.

## ENV VARS

    TZ: UTC
    DEEP_THOUGHT__LOG_LEVEL: INFO # ERROR, WARNING, INFO, DEBUG
    DEEP_THOUGHT__RAILS_LOG_TO_STDOUT: true # true | false
    DEEP_THOUGHT__DB__URI: mongodb://localhost:27017/deep_thought
    DEEP_THOUGHT__PROTOCOL: http
    DEEP_THOUGHT__PORT: 3000
    DEEP_THOUGHT__HOSTNAME: localhost
    DEEP_THOUGHT__UI__DOMAIN_ORIGIN: localhost:8080
    DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_ID = # this is required
    DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_SECRET = # this is required
    DEEP_THOUGHT__AUTH__JWT_SECRET_KEY: random # every application restart it will be change
    DEEP_THOUGHT__AUTH__EMAIL_DOMAIN_PATTERN: .* # this permit configure only fell email pattern could login
    DEEP_THOUGHT__AUTH__CALLBACK_ENDPOINT: http://localhost:8080/
    DEEP_THOUGHT__JOB__RABBIT_URI: amqp://localhost:5672
    DEEP_THOUGHT__JOB__CONCURRENCY: 1
    DEEP_THOUGHT__JOB__QUEUE_NAME: deep_thought_default
    DEEP_THOUGHT__JOB__MAX_RETRIES: 1
    DEEP_THOUGHT__JOB__RETRY_TTL: 60000
    DEEP_THOUGHT__JOB__SLEEP_TIME: 0.2

## Run with Docker Compose

    docker-compose up

## Documentations

Documentation by resources:

* [Authentication](docs/authentication.md)
* [Namespaces](docs/namespaces.md)
* [Connections](docs/connections.md)
