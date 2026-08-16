const express = require('express');

const app = express();

app.get('/', (req, res) => {
    res.send('Build and Deploy to EKS Project- Flux deploying');
});

app.listen(8080, () => {
    console.log('Listening on port 8080');
});
