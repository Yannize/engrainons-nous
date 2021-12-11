const client = require('../clients.js');
const bcrypt = require('bcrypt');
const capitalize = require('../modules/capitalize');
const key = require('../modules/key');
module.exports = {
    async checkMail(body) {
        try {
            const queryPrepared = {
                text: `SELECT * FROM "userdata" WHERE  "email" = $1  `,
                values: [body.email.toLowerCase()]
            }
            const result = await client.query(queryPrepared);


            return result.rows[0];
            //check
        } catch (error) {
            console.log(error)
        }
    },
    async checkPseudo(body) {
        try {
            const queryPrepared = {
                text: `SELECT * FROM "userdata" WHERE  "pseudo" = $1  `,
                values: [body.pseudo]
            }
            const result = await client.query(queryPrepared);

            return result.rows[0];
        } catch (error) {

        }
    },
    async checkUser(id_user) {
        try {
            console.log(id_user)
            const queryPrepared = {
                text: `SELECT * FROM "userdata" WHERE  "id" = $1  `,
                values: [id_user]
            }
            const result = await client.query(queryPrepared);
            return result.rows;

        } catch (error) {

        }
    },
    async create(body) {

        try {


            const city = capitalize.upFirstLetter(body.city);

            const saltRounds = 5;
            const salt = bcrypt.genSaltSync(saltRounds);
            const hash = bcrypt.hashSync(body.password, saltRounds);


            const keyConfirm = key.generated();
            const queryPrepared = {
                text: `INSERT INTO "userdata" ("pseudo", "email","city", "mdp","keyconfirm") VALUES ($1,$2,$3,$4,$5) RETURNING * ;`,
                values: [body.pseudo, body.email.toLowerCase(), city, hash, keyConfirm]
            }
            const result = await client.query(queryPrepared);
            return {
                return : result.rows[0]
            };
        } catch (error) {
            console.log(error);
        }





    },
    async update(body) {


        try {
            const city = capitalize.upFirstLetter(body.city);

            console.log("update datamaper");
            console.log(body);
            if (body.password) {
                const saltRounds = 5;
                const hash = bcrypt.hashSync(body.password, saltRounds);
                console.log('passsword update datamapper');
                console.log(body);
                const queryPrepared = {
                    text: `UPDATE "userdata" SET "pseudo"= $1, "email"= $2, "city"=$3, "mdp"=$4 WHERE "id"= $5`,
                    values: [body.pseudo, body.email.toLowerCase(), city, hash, body.userid]
                }
                const result = await client.query(queryPrepared);
                return result
            } else {

                console.log('no passsword update datamapper')
                const queryPrepared = {
                    text: `UPDATE "userdata" SET "pseudo" = $1, "email" = $2, "city"=$3 WHERE "id"= $4`,
                    values: [body.pseudo, body.email.toLowerCase(), city, body.userid]
                }
                const result = await client.query(queryPrepared);
                return result
            }
        } catch (error) {
            console.log(error);
        }


    },
    async delete(user_id) {
        try {
            const queryPrepared = {
                text: `DELETE FROM "userdata" WHERE  "id" = $1  `,
                values: [user_id]
            }
            const result = await client.query(queryPrepared);
            console.log('user delete datamapper')
            return {
                message: 'user delete'
            }
        } catch (error) {
            console.log(error)
        }
    },
    async confirm(email){
        const queryPrepared = {
            text: `UPDATE "userdata" SET "statut"='confirm' WHERE  "email" = $1  `,
            values: [email.toLowerCase()]
        }
        const result = await client.query(queryPrepared);
        return{
            message :"user update"
        }
    },async updatePassword(body){
        try {
            const saltRounds = 5;
            const hash = bcrypt.hashSync(body.password, saltRounds);
            const queryPrepared = {
                text: `UPDATE "userdata" SET "mdp"=$1 WHERE "email"= $2`,
                values: [hash, body.email.toLowerCase()]               
            }
            const result = await client.query(queryPrepared);
            return result
        } catch (error) {
            console.log(error)
        }
    }

}