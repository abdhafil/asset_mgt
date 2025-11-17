import express from "express";
import { addcategory, deleteCategory, viweAllCategory, categoryToggle, viweActiveCategory } from "../controllers/categoryController.js";

const router=express.Router();

router.get("/view_active",viweActiveCategory);
router.get("/view/all",viweAllCategory);
router.put("/toggle/isActive/:id",categoryToggle);
router.post("/add",addcategory);
router.delete("/delete/:id",deleteCategory);

export default router;