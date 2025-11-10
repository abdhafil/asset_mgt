import {PrismaClient} from "@prisma/client";
const prisma=new PrismaClient();

export const viweMaintenaces=async(req,res)=>{
    const {id}=req.params;
    try {
        const maintenances=await prisma.maintenance.findMany({
            where:{isActive:true},
        });
        res.json(maintenances)
    } catch (error) {
        res.status(500).json({error:error.message});
    }
};

export const addMaintenance=async(req,res)=>{
    const {maintenance_type,date,performed_by,notes,assetId} = req.body;
    try {
        const maintenance=await prisma.maintenance.create({
            data:{maintenance_type,date,performed_by,notes,assetId}
        });
    res.json(maintenance);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

export const deleteMaintenace=async(req,res)=>{
    const {id} = req.params;
    try {
        const deletedMaintenace=await prisma.maintenance.update({
            where:{id:Number(id)},
            data:{isActive:false},
        });
    res.json({message:"Maintenace deleted successfully",deletedMaintenace});
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

export const updateMaintenace=async(req,res)=>{
    const{id}=req.params;
    const {date,performed_by,notes,assetId} = req.body;
    try {
        const maintenance=await prisma.maintenance.findUnique({
            where:{id:Number(id)},
        });
        if (!maintenance) {
            return res.status(404).json({message:"Maintenance not found"});
        } 

        if(!maintenance.isActive) {
            return res.status(400).json({message:"Maintenance is not active and cannot be updated"});
        }

        const updatedMaintenace=await prisma.maintenance.update({
            where:{id:Number(id)},
            data:{date,performed_by,notes,assetId}
        });
        
        res.json({message:"Maintenace updated successfully",updatedMaintenace});
    
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}
