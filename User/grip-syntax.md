# Make Flask app publicly visible
It's safe because grip runs with debug mode = off so it can't execute arbitrary python code

 * https://stackoverflow.com/questions/30554702/cant-connect-to-flask-web-service-connection-refused

```bash
# To allow public visitors to your app
grip README.md 0.0.0.0
```


# Run Flask in development mode
This avoids a warning about not using this in a production environment.

Development mode has no concurrency and only serves 1 request at a time,
which is fine for testing.

 *  https://stackoverflow.com/questions/50284753/warning-message-while-running-flask

```bash
# To allow public visitors to your app
FLASK_ENV="development" grip README.md 0.0.0.0

# For local testing on custom port 8090
FLASK_ENV="development" grip README.md 8090
```
