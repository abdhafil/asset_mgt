import express from "express";
import { addMaintenance, deleteMaintenace, updateMaintenace, viweMaintenaces } from "../controllers/maintenaceController.js";

const router = express.Router();

router.get("/view",viweMaintenaces);
router.post("/add",addMaintenance);
router.put("/update/:id",updateMaintenace);
router.put("/delete/:id",deleteMaintenace);

export default router;