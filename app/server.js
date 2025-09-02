const http = require('http');
const port = process.env.PORT || 3000;

const requestHandler = (request, response) => {
  response.setHeader('Content-Type', 'application/json');
  response.end(JSON.stringify({
    message: 'Hello World from ECS Fargate!',
    path: request.url,
    timestamp: new Date().toISOString()
  }));
};

const server = http.createServer(requestHandler);
server.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
