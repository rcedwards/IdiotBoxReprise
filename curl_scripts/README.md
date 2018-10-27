# API Testing Scripts

## Create a Local Environment File

In your file configure your API key, user details, and later a session token after authenticating:

```bash
API_KEY="YOUR_API_KEY"
USER_KEY="YOUR_USER_KEY"
USER_NAME="YOUR_USER_NAME"
```

## Getting an Authentication Token

Run: `./authenticate.sh` you should see a response like the following:

```json
{
    "token": "asdf1234wootwoot!"
}
```

Place this in your `.env` file
