const {
    allSeedOneuser
} = require('../dataMappers/seed');
const seedDatamapper = require('../dataMappers/seed');
module.exports = {
    //controller for all seed
    async getAll(request, response) {
        try {
            const result = await seedDatamapper.getAll();
            response.json(result)
        } catch (error) {
            console.log(error.message);
        }

    },
    // Controller for seed search
    async searchSeed(request, response) {
        try {
            const result = await "SearchSeed";
            response.json({
                result
            })
        } catch (error) {
            console.log(error.message);
        }

    },
    //constroller for update seed
    async seedUpdate(request, response) {
        try {
            const result = await "view User Seed List";
            response.json({
                result
            })
        } catch (error) {
            console.log(error.message);
        }

    },
    //controller fonr delete seed
    async deleteSeed(request, response) {
        try {
            const result = await "view User Seed List";
            response.json({
                result
            })
        } catch (error) {
            console.log(error.message);
        }

    },
    //controller for all category
    async getAllCat(request, response) {
        try {
            const result = await seedDatamapper.allCat();
            response.json({
                result
            })
        } catch (error) {
            console.log(error.message);
        }

    },
    //controller for all seed one category
    async getOneCat(request, response) {
        try {
            const result = await seedDatamapper.oneCat(request.params.idcategory);
            response.json({
                result
            })
        } catch (error) {
            console.log(error.message);
        }
    },
    // controller for all variety
    async getAllVar(request, response) {
        try {
            const result = await seedDatamapper.allVar();
            response.json({
                result
            })
        } catch (error) {
            console.log(error.message);
        }
    },
    //controller for check one variety
    async getOneVar(request, response) {
        try {
            //check if variety existe
            const checkVar = await seedDatamapper.oneVar(request.params.idvariety);
            if (checkVar) {
                response.json({
                    result: checkVar
                })
            } else {
                response.json({
                    error: "Variety not found"
                })
            }
        } catch (error) {
            console.log(error)
        }
    },
    //controller for find one seed
    async getOneSeed(request, response) {
        try {
            const result = await seedDatamapper.oneSeed(request.params.idseed);
            console.log(result);
            if (result.length > 0) {
                response.json({
                    result
                })
            } else {
                response.json({
                    result: "seed not found"
                })
            }

        } catch (error) {
            console.log(error.message);
        }
    },
    //controller for create a new seed
    async createdSeed(request, response) {
        try {
            console.log(request.body);
            //check if variety existe
            const checkVariety = await seedDatamapper.varietyCheck(request.body.variety_name);
            if (checkVariety.length === 0) {
                //create new variety
                const createVariety = await seedDatamapper.createVariety(request.body);
                const idNewVariety = createVariety.rows[0].id;


                //now created seed 

                const newSeed = {
                    userid: request.body.user_id,
                    varietyid: idNewVariety,
                    description: request.body.description,
                    advice: request.body.advice
                }

                const seedCreate = await seedDatamapper.create(newSeed);

                response.json({
                    message: "seed create"
                })
            } else {


                const newSeed = {
                    userid: request.body.user_id,
                    varietyid: checkVariety[0].id,
                    description: request.body.description,
                    advice: request.body.advice
                }
                const seedCreate = await seedDatamapper.create(newSeed);

                response.json({
                    message: "seed create"
                })
            }
            //const result = await seedDatamapper.create(seed);

        } catch (error) {
            console.log(error)
        }
    },
    //controller for update seed
    async updateSeed(request, response) {
        try {

            //check if variety existe
            const checkVariety = await seedDatamapper.varietyCheck(request.body.variety_name);
            if (checkVariety.length === 0) {
                //create new variety
                const createVariety = await seedDatamapper.createVariety(request.body);
                const idNewVariety = createVariety.rows[0].id;


                //now created seed 

                const newSeed = {
                    seedid: request.params.idseed,
                    varietyid: idNewVariety,
                    description: request.body.description,
                    advice: request.body.advice
                }

                const seedCreate = await seedDatamapper.update(newSeed);

                response.json({
                    message: "seed update"
                })
            } else {


                const newSeed = {
                    seedid: request.params.idseed,
                    varietyid: checkVariety[0].id,
                    description: request.body.description,
                    advice: request.body.advice
                }
                const seedCreate = await seedDatamapper.update(newSeed);

                response.json({
                    message: "Seed Update"
                })
            }
        } catch (error) {
            console.log(error)
        }
    },
    //controller for delete seed
    async deleteSeed(request, response) {
        //check if seed existe
        console.log("deleteSeed");
        const checkSeed = await seedDatamapper.oneSeed(request.params.idseed);
        console.log(checkSeed.length);
        if (checkSeed.length > 0) {
            result = await seedDatamapper.delete(request.params.idseed);
            console.log(result)
            response.json({
                error: "seed delete"
            })

        } else {
            console.log('seed not found');
            response.json({
                error: "seed not found"
            })
        }

    },
    //controller for paginate resulte all seed
    async paginateSeed(request, response) {
        try {

            console.log(request.params.offset);
            const seedNb = await seedDatamapper.getAll()
            const seedList = await seedDatamapper.paginationSeed(request.params.offset);
            response.json({
                nbSeed: seedNb.length,
                nbReturn: seedList.length,
                seed: seedList
            })
        } catch (error) {
            console.log(error)
        }

    },
    //controller for find all seed for one user
    async allSeedOneuser(request, response) {

        const result = await seedDatamapper.allSeedOneuser(request.params.iduser);

        response.json({
            seed: result
        })
    },
    //controller fonr search one variety seed
    async searchVar(request, response) {

        try {
                        const newSearch={
                ilike: request.params.search,
                offset:request.params.offset
            }
            const seedNb = await seedDatamapper.search(newSearch);
            const search = await seedDatamapper.searchPaginate(newSearch);
            response.json({
                nbSeed: seedNb.length,
                resul: search
            })
        } catch (error) {
            console.log(error)
        }
    },
    //controller for paginate all seed one category
    async paginateCategory(request, response){
        try {
            const search ={
                offset : request.params.offset,
                idcategory :request.params.idcategory
            }
            const seedNb = await seedDatamapper.oneCat(request.params.idcategory)
            const seedList = await seedDatamapper.paginationCat(search);
            response.json({
                nbSeed: seedNb.length,
                nbReturn: seedList.length,
                seed: seedList
            })
        } catch (error) {
            console.log(error)
        }
    }

}