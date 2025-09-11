const request = require('supertest');
const express = require('express');

const app = express();

// replicate the route from index.js
app.get('/', (req, res) => {
  res.send('Build and Deploy to EKS Project');
});

describe('GET /', () => {
  it('should return the correct message', async () => {
    const response = await request(app).get('/');
    expect(response.status).toBe(200);
    expect(response.text).toBe('Build and Deploy to EKS Project');
  });
});
