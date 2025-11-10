import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import assetRoutes from "./routes/assetRoutes.js";
import categoryRoutes from "./routes/categoryRoutes.js"
import maintenaceRoutes from "./routes/maintenaceRoutes.js"

dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());

app.use("/asset", assetRoutes);
app.use("/category",categoryRoutes);
app.use("/maintenance",maintenaceRoutes);


const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

export default app;
