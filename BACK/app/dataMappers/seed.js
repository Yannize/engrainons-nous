const client = require('../clients');
const { search } = require('../routers');
module.exports = {
    async getAll() {
        try {
            const queryPrepared = `select * from seedlist order by created_at DESC`;
            const result = await client.query(queryPrepared)
            return result.rows;
        } catch (error) {
            console.log(error)
        }
    },
    async allCat(){
        try {
            const queryPrepared = `SELECT * FROM category order by "name"`;
            result = await client.query(queryPrepared);
            
            return result.rows;
        } catch (error) {
            console.log(error)
        }
    },
    async oneCat(idcat) {
        try {
            const queryPrepared = {
                text: `SELECT * FROM "seedlist" WHERE  "category_id" = $1  `,
                values: [idcat]
            }
            const result = await client.query(queryPrepared)
            return result.rows;
        } catch (error) {
            console.log(error)
        }
    },
    async allVar() {
       try {
            const queryPrepared = `SELECT * FROM variety`;
            const result = await client.query(queryPrepared);
            return result.rows;
        } catch (error) {
            console.log(error)
        }
    },
    async oneVar(idvariety){
        const queryPrepared ={
            text: `SELECT * FROM "seedlist" WHERE "variety_id" = $1`,
            values: [idvariety]
        }
        const result = await client.query(queryPrepared);
        return result.rows
    },
    async oneSeed(idseed) {
        try {
            const queryPrepared = {
                text: `SELECT * FROM "seedlist" WHERE  "id" = $1  `,
                values: [idseed]
            }
            const result = await client.query(queryPrepared);
            return result.rows;
        } catch (error) {
            console.log(error)
        }
    },
    async create(seed){
        try {
            console.log("create seed")
            console.log(seed.userid);
            const queryPrepared = {
                text: `INSERT INTO "seed" ("user_id", "variety_id","description", "conseil") VALUES ($1,$2,$3,$4); `,
                values: [seed.userid,seed.varietyid,seed.description,seed.advice]
            }
            const result = await client.query(queryPrepared);
            return {
                message: "seed create"
            }
            
        } catch (error) {
            console.log(error);
        }
    },
    async varietyCheck(variety){
        try {
            const queryPrepared ={
                text: `SELECT * FROM "variety" WHERE "name" = $1`,
                values: [variety]
            }
            const result = await client.query(queryPrepared);
            return result.rows
            
        } catch (error) {
            console.log(error)
        }
    },
    async createVariety(variety){
        try {
            const queryPrepared ={
                text: `INSERT INTO "variety" ("name","category_id") VALUES ($1,$2) RETURNING *`,
                values: [variety.variety_name, variety.category_id]
            }
            const result = await client.query(queryPrepared);
            return result
        } catch (error) {
            console.log(error)
        }
    },
    async update(seed){
        const queryPrepared = {
            text: `UPDATE "seed" SET "variety_id"= $1, "description" = $2,  "conseil" = $3 WHERE "id" = $4`,
            values: [seed.varietyid,seed.description,seed.advice,seed.seedid]
        }
        const result = await client.query(queryPrepared);
        return result
    },
    async delete(idseed){
        try {
            const queryPrepared = {
                text: `DELETE FROM "seed" WHERE  "id" = $1  `,
                values: [idseed]
            }
            const result = await client.query(queryPrepared);
            return {
                message: "Seed Delete"
            }
        } catch (error) {
            console.log(error)
        }
    },
    async paginationSeed(offset){
        try {
            const queryPrepared = {
                text: `select * from seedlist order by created_at DESC LIMIT 12 OFFSET $1`,
                values:[offset]}
            
            const result = await client.query(queryPrepared)
            return result.rows;
        } catch (error) {
            console.log(error)
        }
        
    },
    async allSeedOneuser(id_user){
        try {
            const queryPrepared = {
                text: `select * from "seedlist"  where "user_id"=$1 order by created_at DESC`,
                values:[id_user]}
            
            const result = await client.query(queryPrepared);
            
            return result.rows;   
        } catch (error) {
            console.log(error)
        }
        
    },
    async search(search){
        try {
            
            const queryPrepared = {
                text: `SELECT * FROM "seedlist" WHERE "variety_name" ILIKE $1`,
                values:["%"+search.ilike+"%"]}
            
            const result = await client.query(queryPrepared);
            
            return result.rows;   
        } catch (error) {
            console.log(error)
        }
    },
    async searchPaginate(search){
        try {
            console.log("search datamapper")
            console.log("%"+search.ilike+"%");
            const queryPrepared = {
                text: `SELECT * FROM "seedlist" WHERE "variety_name" ILIKE $1 order by created_at DESC LIMIT 12 OFFSET $2 `,
                values:["%"+search.ilike+"%", search.offset]}
            
            const result = await client.query(queryPrepared);
            
            return result.rows;   
        } catch (error) {
            console.log(error)
        }
    },
    async paginationCat(search){
        try {
            console.log(search);
            const queryPrepared = {
                text: `SELECT * FROM "seedlist" WHERE  "category_id" = $1  order by created_at DESC LIMIT 12 OFFSET $2`,
                values: [search.idcategory,search.offset]
            }
            
            const result = await client.query(queryPrepared);
            return result.rows;
        } catch (error) {
            console.log(error)
        }
    },


}