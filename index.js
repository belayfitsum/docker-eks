const express = require('express');

const app = express();

app.get('/', (req, res) => {
    res.send(process.env.APP_MESSAGE || 'Hello from Express!');
});

app.listen(8080, () => {
    console.log('Listening on port 8080');
});
