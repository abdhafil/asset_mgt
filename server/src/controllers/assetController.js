import {PrismaClient} from "@prisma/client";
const prisma=new PrismaClient();

export const viewAssets=async(req,res)=>{
    try {
        const assets=await prisma.asset.findMany({
            where:{isActive:true},
        });
        res.json(assets)
    } catch (error) {
        res.status(500).json({error:error.message});
    }
};

export const savedAssets=async(req,res)=>{
    try {
        const assets=await prisma.asset.findMany({
            where:{isSaved:false,isActive:true},
        });
        res.json(assets)
    } catch (error) {
        res.status(500).json({error:error.message});
    }
};


export const savedAssetToggle=async(req,res)=>{
    const {id}=req.params;
    try {
        const asset=await prisma.asset.findFirst({
            where:{id:Number(id),isActive:true},
        });
        if (!asset) {
            return res.status(404).json({ message: "Asset not Active or not found"});
        }
        
        const newStatus=!asset.isSaved
        const sevedAssetStatus=await prisma.asset.update({
            where:{id:Number(id)},
            data:{isSaved:newStatus}
        })
        // console.log(newStatus);
        res.json({
            message:newStatus
            ?"Asset Sved"
            :"Asset Unsaved",
            sevedAssetStatus,
        });

    } catch (error) {
        res.status(500).json({error:error.message});
    }
};


export const viewAsset=async(req,res)=>{
    const {id} = req.params;
    try {
        const asset=await prisma.asset.findUnique({
            where:{id:Number(id)}
        });
        
        if (!asset) {
            return res.status(404).json({message:"Asset not found"});
        }
        if (!asset.isActive) {
            return res.status(400).json({message:"Asset is not Acive and Cannot fetch"});
        }
        else{
            res.json(asset)
        }
    } catch (error) {
        res.status(500).json({error:error.message});
    }
}


export const addAsset = async (req, res) => {
  try {
    const { name, location, description, categoryId } = req.body;

    if (!req.file) {
      return res.status(400).json({ error: "Image is required" });
    }

    const imageUrl = `/uploads/${req.file.filename}`;

    const asset = await prisma.asset.create({
      data: {
        name,
        location,
        description,
        categoryId: Number(categoryId),
        imageUrl,
      },
    });

    res.json({ message: "Asset added", data: asset });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};


export const deleteAsset=async(req,res)=>{
    const {id} = req.params;
    try {
        const deleteAsset=await prisma.asset.update({
            where:{id:Number(id)},
            data:{isActive:false},
        });
    res.json({message:"asset deleted successfully",deleteAsset});
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

export const updateAsset=async(req,res)=>{
    const{id}=req.params;
    const {name,location,image,description,categoryId} = req.body;
    try {
        const asset=await prisma.asset.findUnique({
            where:{id:Number(id)},
        });

        if (!asset) {
            return res.status(404).json({message:"Asset not found"});
        } 

        if(!asset.isActive) {
            return res.status(400).json({message:"Asset is not active and cannot be updated"});
        }

        const updatedasset=await prisma.asset.update({
            where:{id:Number(id)},
            data:{name,location,image,description,categoryId}
        });
        
        res.json({message:"Aseet updated successfully",updatedasset});

    
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}
