# Authentication

Authentication is required to perform anything with server. If not authenticated correct, expired or other thing. Is expected to receive 401 (or 403).

**To configure Authentication is expect to set a fell env vars**

    DEEP_THOUGHT__PROTOCOL = http
    DEEP_THOUGHT__PORT = 3000
    DEEP_THOUGHT__HOSTNAME = deepthought.localhost.com
    DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_ID = # this is required
    DEEP_THOUGHT__AUTH__GOOGLE_CLIENT_SECRET = # this is required
    DEEP_THOUGHT__AUTH__JWT_SECRET_KEY = random # every application restart it will be change
    DEEP_THOUGHT__AUTH__EMAIL_DOMAIN_PATTERN = .*

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

    status: 200
    {
        "id": "xxx",
        "name": "xxx",
        "email": "asasda",
        "picture": "https://...",
        "verified_email": true,
        "created_at": "2019-06-22T22:31:11+00:00",
        "updated_at": "2019-06-22T22:31:12+00:00"
    }
