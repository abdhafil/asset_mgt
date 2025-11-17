import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import os from "os";

import assetRoutes from "./routes/assetRoutes.js";
import categoryRoutes from "./routes/categoryRoutes.js"
import maintenaceRoutes from "./routes/maintenaceRoutes.js"

dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/asset", assetRoutes);
app.use("/category",categoryRoutes);
app.use("/maintenance",maintenaceRoutes);
app.use("/uploads", express.static("uploads"));



const PORT = process.env.PORT || 5000;

function getLocalIP() {
  const nets = os.networkInterfaces();
  for (const name of Object.keys(nets)) {
    for (const net of nets[name]) {
      if (net.family === 'IPv4' && !net.internal) {
        return net.address;
      }
    }
  }
  return 'localhost';
}

app.listen(PORT, '0.0.0.0', () => {
  const localIP = getLocalIP();
  // console.log(`🚀 Server running locally on: http://localhost:${PORT}`);
  // console.log(`📱 Access from your phone using: http://${localIP}:${PORT}`);
});


export default app;