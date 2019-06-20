# Authentication

To configure Authentication is expect to set a fell env vars

    DEEP_THOUGHT__PROTOCOL = http
    DEEP_THOUGHT__PORT = 3000
    DEEP_THOUGHT__HOSTNAME = deepthought.localhost.com
    DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_ID = # this is required
    DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_SECRET = # this is required
    DEEP_THOUGHT__AUTH__JWT_SECRET_KEY = random # every application restart it will be change

Request authentication to:

    GET /auth/session/google_sign_in

If authentication Works fine It will be redirect to / with jwt as param.

   GET /?jwt=XXXX

If authentication not works well. It will be redirect to / with message and error code as param.

    GET /?error_code=123&message=This is example message

JWT should be save on **local storage** and should be used every request in header **Authentication**.

Example:

    GET /user
    Authentication: XXXX
