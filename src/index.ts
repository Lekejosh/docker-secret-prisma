import { Server } from "./bin/app";
const server = new Server();
server.listen((port: number) => {
  console.log('db connected')
  console.log(`Server is listening on port: ${port} 🚀`);
});
