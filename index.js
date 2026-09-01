const express = require('express');

const app = express();

app.get('/', (req, res) => {
    res.send(process.env.APP_MESSAGE || 'Hello from simpleweb v1.0.1!');
});

app.listen(8080, () => {
    console.log('Listening on port 8080');
});
