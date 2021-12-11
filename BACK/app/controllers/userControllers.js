const userDatamapper = require('../dataMappers/user');
const bcrypt = require('bcrypt');
const mailModule = require('../modules/mail');
const token = require('../modules/jwttoken');
const passGen = require('../modules/password');
module.exports = {
    //Controller for sign in
    async signIn(request, response) {
        try {
            /*const test = bcrypt.compareSync(request.body.password, hash);
            console.log(test);*/
            if (request.body.email.length === 0 || request.body.password.length === 0) {
                response.json({
                    message: 'Penser a renseigner tous les champs'
                })
            }
            // We check that the user exists
            const user = await userDatamapper.checkMail(request.body);
            if (user) {
                //if user existe verify is confirmed
                if (user.statut === "notconfirm") {
                    response.json({
                        error: " Email not confirm"
                    })
                } else {
                    //If the user exists, we recover his password and compare it to the one in the database
                    if (bcrypt.compareSync(request.body.password, user.mdp)) {
                        console.log("mot de pass validé");
                        //creat a token
                        const content = {
                            user_id: user.id,
                            user_email: user.eamil
                        }
                        const createToken = token.create(content);
                        console.log(createToken);
                        response.json({
                            return: 'Ok',
                            user,
                            token: createToken
                        })
                    }
                    //If the password does not match, an error is returned
                    else {
                        response.json({
                            return: "Email ou mot de passe incorrect"
                        });
                    }
                }

            }
            //if the user is not found, an error message is returned
            else {
                response.json({
                    return: "Email ou mot de passe incorrect"
                });
            }


        } catch (error) {
            console.log(error.message);
        }

    },
    //Controller for register new user
    async signUp(request, response) {
        try {
            // We check that the user exists
            if (request.body.pseudo.length === 0 || request.body.password.length === 0 || request.body.confirm.length === 0 || request.body.email.length === 0 || request.body.city.length === 0) {
                response.status(400).json({
                    error: "Tous les champs d'un formulaire sont obligatoire"
                })
            }
            const mail = await userDatamapper.checkMail(request.body);
            if (mail) {

                response.status(400).json({
                    error: "Email dejas existant"
                })

            }
            const usercheck = await userDatamapper.checkPseudo(request.body);
            if (usercheck) {

                response.status(400).json({
                    error: "Ce nom d'utilisateur existe dejas"
                })

            }

            if (request.body.password !== request.body.confirm) {

                response.status(400).json({
                    error: "les mots de passe ne correspondent pas"
                })

            }
            const createUser = await userDatamapper.create(request.body);
            const sendMail = mailModule.sendMail(createUser.return.email, createUser.return.keyconfirm)
            console.log(sendMail);
            response.json({
                message: 'Utilisateur crée et mail envoyé'
            });
        } catch (error) {
            console.log(error.message);
        }

    },
    async logOut(request, response) {
        try {
            const result = await "logOut Account";
            response.json({
                result
            })
        } catch (error) {
            console.log(error.message);
        }

    },
    async userSeedlistView(request, response) {
        try {
            const result = await "view User Seed List";
            response.json({
                result
            })
        } catch (error) {
            console.log(error.message);
        }

    },
    async updateUser(request, response) {
        //check if user exist 
        const userCheck = await userDatamapper.checkUser(request.params.iduser);
        if (userCheck[0]) {
            console.log(request.body.password);
            if (request.body.password) {
                if (request.body.password === request.body.confirm) {
                    userUpdate = {
                        userid: request.params.iduser,
                        password: request.body.password,
                        pseudo: request.body.pseudo,
                        email: request.body.email,
                        city: request.body.city
                    };
                    const result = await userDatamapper.update(userUpdate);
                    response.json({
                        error: "user update"
                    })
                } else {
                    response.json({
                        error: "passwords are not the same"
                    })
                }
            } else {
                console.log('controller not mdp user update')
                userUpdate = {
                    userid: request.params.iduser,
                    password: request.body.password,
                    pseudo: request.body.pseudo,
                    email: request.body.email,
                    city: request.body.city
                };
                const result = await userDatamapper.update(userUpdate);
                response.json({
                    message: "user update"
                })
            }

        } else {
            response.json({
                error: "user not found"
            })
        }

    },
    async deleteUser(request, response) {
        //check if user exist 
        console.log('user delete controller');
        console.log(request.params.iduser)
        const userCheck = await userDatamapper.checkUser(request.params.iduser);
        if (userCheck[0]) {
            const userDelete = await userDatamapper.delete(request.params.iduser);
            response.json({
                message: "user delete"
            })
        } else {
            console.log('user not found')
            response.json({
                error: 'user not found'
            })
        }

    },
    async validateUser(request, response) {
        try {
            console.log(`email = ${request.params.email}`);
            console.log(`email = ${request.params.key}`);
            //check if user existe
            const user = {
                email: request.params.email
            }
            const checkUser = await userDatamapper.checkMail(user);
            if (checkUser) {
                //check is statut is already confirm
                if (checkUser.statut === "notconfirm") {
                    //check if this key is good

                    if (checkUser.keyconfirm === request.params.key) {
                        const result = await userDatamapper.confirm(request.params.email);
                        response.json({
                            message: "user confirmed"
                        })
                    } else {
                        console.log('les clé ne corresponde pas ');
                    }
                } else {
                    response.json({
                        message: "email already confirme"
                    })
                }
            } else {
                console.log('user not found');
            }
        } catch (error) {
            console.log(error)
        }
    },
    async resetMdp(request, response) {
        //check if mail exist in bdd
        try {
            console.log(request.params);
            const checkMail = await userDatamapper.checkMail(request.params);
            console.log(checkMail);
            if (checkMail) {
                const newPassword ={
                    email: request.params.email,
                    password: passGen.generated()
                }
                console.log(newPassword)
                const result = await userDatamapper.updatePassword(newPassword);
                mailModule.sendReset(newPassword);
                response.json({
                    message:"password changed"
                })

            } else {
                response.json({
                    error: "Email not found"
                })
            }

        } catch (error) {
            cons
        }

    },
    async checkToken(request,response){
        
    }
}