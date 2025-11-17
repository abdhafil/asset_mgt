import {PrismaClient} from "@prisma/client";
const prisma=new PrismaClient();


export const viweActiveCategory=async(req,res)=>{
    try {
        const categorys=await prisma.category.findMany({
            where:{isActive:true},
        });
        res.json(categorys)
    } catch (error) {
        res.status(500).json({error:error.message});
    }
};

export const viweAllCategory=async(req,res)=>{
    try {
        const categorys=await prisma.category.findMany({
        });
        res.json(categorys)
    } catch (error) {
        res.status(500).json({error:error.message});
    }
};

export const categoryToggle=async(req,res)=>{
    const {id}=req.params;
    try {
        console.log(id);
        const category=await prisma.category.findUnique({
            where:{id:Number(id)},
        });

        if (!category) {
            return res.status(404).json({ message: "Category not found" });
        }
        
        const newStatus=!category.isActive
        const updateStatus=await prisma.category.update({
            where:{id:Number(id)},
            data:{isActive:newStatus}
        })
        res.json({
            message:newStatus
            ?"Category Reactivated"
            :"Category Deactivated",
            updateStatus,
        });

    } catch (error) {
        res.status(500).json({error:error.message});
    }
};


// export const addcategory=async(req,res)=>{
//     const {name} = req.body;
//     try {
//         const existingCategory=await prisma.category.findUnique({
//             where:{name:name},
//         });

//         if (existingCategory) {
//             return res.status(400).json({message:"Category name already exists"});
//         }

//         const newCategory=await prisma.category.create({
//             data:{name}
//         });
//         return res.status(201).json({ message: "Category added successfully", newCategory });
//     } catch (error) {
//         res.status(500).json({ error: error.message });
//     }
// }

export const addcategory = async (req, res) => {
  try {
    console.log("Incoming headers:", req.headers);
    console.log("Incoming body:", req.body)
    
    const body = req.body ?? {};
    const name = body.name ?? body.category_name ?? body.categoryName;

    if (!name || typeof name !== "string" || name.trim() === "") {
      return res.status(400).json({ error: "Missing or invalid 'name' in request body" });
    }

    const newCategory = await prisma.category.create({
      data: { name: name.trim() },
    });

    return res.status(201).json(newCategory);
  } catch (err) {
    console.error("addcategory error:", err);
    return res.status(500).json({ error: err.message || "Internal server error" });
  }
};


export const deleteCategory=async(req,res)=>{
    const {id} = req.params;
    try {
        const deletedCategory=await prisma.category.delete({
            where:{id:Number(id)},
            // data:{isActive:false},
        });
    res.json({message:"Category deleted successfully",deletedCategory});
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}
