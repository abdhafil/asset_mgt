import express from "express";
import { upload } from "../middleware/multerConfig.js";
import { addAsset,deleteAsset, updateAsset, savedAssets, savedAssetToggle, viewAsset, viewAssets } from "../controllers/assetController.js";

const router = express.Router();

router.get("/",viewAssets);
router.get("/saved_assets",savedAssets);
router.get("/:id",viewAsset);
router.post("/add", upload.single("image") ,addAsset);
router.put("/update/:id",updateAsset);
router.put("/delete/:id",deleteAsset);
router.put("/toggle/isSaved/:id",savedAssetToggle)

export default router;