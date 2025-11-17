import multer from "multer";
import path from "path";

// storage config
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/"); 
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

// file filter (optional)
// const fileFilter = (req, file, cb) => {
//     const allowedTypes = [
//         "image/jpeg",
//         "image/jpg",
//         "image/png",
//         "image/webp",
//         "image/heic",
//         "image/heif"
//     ];

//     if (allowedTypes.includes(file.mimetype)) {
//         cb(null, true);
//     } else {
//         cb(new Error("Invalid file type"), false);
//     }
// };


// upload middleware
export const upload = multer({
  storage,
//   fileFilter,
});
