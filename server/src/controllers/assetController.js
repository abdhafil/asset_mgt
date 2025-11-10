import {PrismaClient} from "@prisma/client";
const prisma=new PrismaClient();

export const viweAssets=async(req,res)=>{
    try {
        const assets=await prisma.asset.findMany({
            where:{isActive:true},
        });
        res.json(assets)
    } catch (error) {
        res.status(500).json({error:error.message});
    }
};

export const viweAsset=async(req,res)=>{
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

export const addAsset=async(req,res)=>{
    const {name,location,image,description,categoryId} = req.body;
    try {
        const existingAsset = await prisma.asset.findUnique({
            where: { name },
        });


        if (existingAsset) {
            return res.status(400).json({message:"Asset name already exists"});
        }
        const asset=await prisma.asset.create({
            data:{name,location,image,description,categoryId}
        });
    res.json(asset);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

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
