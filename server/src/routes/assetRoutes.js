import express from "express";
import { viweAssets,addAsset,deleteAsset, updateAsset, viweAsset } from "../controllers/assetController.js";

const router = express.Router();

router.get("/",viweAssets);
router.get("/:id",viweAsset);
router.post("/add",addAsset);
router.put("/update/:id",updateAsset);
router.put("/delete/:id",deleteAsset);

export default router;