// Connexion à la base de données :

// on require le module pg, qui va nous permettre de nous connecter à notre base de données
const { Pool } = require('pg');

// on crée un client (qui récupère les infos de connexion à la BDD dans les variables d'environment : le fichier .env)
const client = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: {
      rejectUnauthorized: false
    }
  });

// on connecte ce lient, et on le laisse connecté !
client.connect();
// on est connectés !

// on exporte (on rends disponible dans d'autres fichiers) notre client connecté !
module.exports = client;


// là ou on a besoin de faire des requêtes à notre BDD, il faut importer (require) cette connexion
// => dans promoController et studentController

// Note : on ne se soucie pas de fermer la connection : en quittant node, la connexion sera détruite automatiquement.