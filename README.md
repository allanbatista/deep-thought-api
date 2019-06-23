## ENV VARS

    DEEP_THOUGHT__LOG_LEVEL = INFO # ERROR, WARNING, INFO, DEBUG
    DEEP_THOUGHT__RAILS_LOG_TO_STDOUT = true # true | false
    DEEP_THOUGHT__DB_URI = mongodb://localhost:27017/deep_tought
    DEEP_THOUGHT__PROTOCOL = http
    DEEP_THOUGHT__PORT = 3000
    DEEP_THOUGHT__HOSTNAME = deepthought.localhost.com
    DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_ID = # this is required
    DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_SECRET = # this is required
    DEEP_THOUGHT__AUTH__JWT_SECRET_KEY = random # every application restart it will be change
    DEEP_THOUGHT__AUTH__EMAIL_DOMAIN_PATTERN = .* # this permit configure only fell email pattern could login