BEGIN;
DROP VIEW IF EXISTS "seedlist" CASCADE ;
DROP TABLE IF EXISTS "userdata",
"category",
"variety",
"seed" CASCADE;

DROP DOMAIN IF EXISTS "email";

DROP TYPE IF EXISTS "stat",
"availability";

CREATE DOMAIN "email" AS text CHECK (
    VALUE ~ '^(?:[a-z0-9!#$%&''*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&''*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$'
);

CREATE TYPE "stat" AS ENUM('notconfirm', 'confirm');

CREATE TYPE "availability" AS ENUM('notstock', 'stock');
DROP TABLE IF EXISTS "userdata", "seed";
CREATE TABLE "userdata"(
    "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "pseudo" TEXT NOT NULL UNIQUE,
    "email" EMAIL NOT NULL UNIQUE,
    "city" TEXT NOT NULL,
    "mdp" TEXT NOT NULL,
    "keyconfirm" TEXT NOT NULL,
    "statut" STAT NOT NULL DEFAULT 'notconfirm',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE "category"(
    "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "name" TEXT NOT NULL,
    "img" TEXT NOT NULL,
    "img_author" TEXT NOT NULL
);

CREATE TABLE "variety"(
    "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "name" TEXT NOT NULL,
    "category_id" INT NOT NULL REFERENCEs "category"("id")
);

CREATE TABLE "seed"(
    "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "user_id" INT NOT NULL REFERENCES "userdata"("id") ON DELETE CASCADE,
    "variety_id" INT NOT NULL REFERENCES "variety"("id"),
    "description" TEXT NOT NULL,
    "conseil" TEXT NOT NULL,
    "availability" AVAILABILITY NOT NULL DEFAULT 'stock',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ
);
/*
INSERT INTO
    "userdata" ("pseudo", "email", "city", "mdp", "keyconfirm")
VALUES
    (
        'Cedric',
        'cedric@engrainon.nous',
        'Peyrolles en provence',
        '$2b$05$nNLJdFwrLKsoKkWkn8G9t.qgVlJ8zJwwv7COS6fpoivKGArvzFzPK',
        '6wz36JJ54lZnlZpCbq1kEyrIBgvNOi'
    ),
    (
        'Yann',
        'yann@engrainon.nous',
        'Aucune idée',
        '$2b$05$nNLJdFwrLKsoKkWkn8G9t.qgVlJ8zJwwv7COS6fpoivKGArvzFzPK',
        '6wz367854zZnlZpCbq1kEyrIBgvNOi'
    ),
    (
        'Julie',
        'julie@engrainon.nous',
        'Mayenne',
        '$2b$05$nNLJdFwrLKsoKkWkn8G9t.qgVlJ8zJwwv7COS6fpoivKGArvzFzPK',
        '6wz36JJ54lZnlZpCbq1kEyrIBer58e'
    ),
    (
        'Mikael',
        'mikael@engrainon.nous',
        'Chnor',
        '$2b$05$nNLJdFwrLKsoKkWkn8G9t.qgVlJ8zJwwv7COS6fpoivKGArvzFzPK',
        '6wz36JJ54lZnlze9851kEyrIBgvNOi'
    ),
    (
        'Kevin',
        'kevin@engrainon.nous',
        'les iles',
        '$2b$05$nNLJdFwrLKsoKkWkn8G9t.qgVlJ8zJwwv7COS6fpoivKGArvzFzPK',
        '6wz36JJ54l659zdCbq1kEyrIBgvNOi'
    );
*/
INSERT INTO
    "category"("name", "img", "img_author")
VALUES
    (
        'Courgette',
        'https://images.unsplash.com/photo-1596056094719-10ba4f7ea650?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1',
        'Edson Rosas'
    ),
    (
        'Tomate',
        'https://images.unsplash.com/photo-1562695530-ca03c4b98623?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1',
        'Hamed Omidian'
    ),
    (
        'Aubergine',
        'https://images.unsplash.com/photo-1613881553903-4543f5f2cac9?ixlib=rb-1.2.1',
        'Nina Luong'
    ),
    (
        'Carotte',
        'https://images.unsplash.com/photo-1445282768818-728615cc910a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        'Jonathan Pielmayer'
    ),
    (
        'Salade',
        'https://images.unsplash.com/photo-1543056295-d585ba290712?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=967&q=80',
        'Lulucmy'
    ),
    (
        'Radis',
        'https://images.unsplash.com/photo-1592346520936-9444037b2e28?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80',
        'Laura Lefurgey-Smith'
    ),
    (
        'Framboise',
        'https://images.unsplash.com/photo-1618422689173-3dbcdeb82fa7?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=807&q=80',
        'Jocelyn Morales'
    ),
    (
        'Poire',
        'https://images.unsplash.com/photo-1570115114436-63d3405246e7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
        'Moritz Kindler'
    ),
    (
        'Pastèque',
        'https://images.unsplash.com/photo-1587049352846-4a222e784d38?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=80',
        'Art Rachen'
    ),
    (
        'Melon',
        'https://images.unsplash.com/photo-1602597190461-43774583d3c0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1189&q=80',
        'Otherness TV'
    ),
    (
        'Courge',
        'https://images.unsplash.com/photo-1506785212-4b1c7d23a1cc?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80',
        'Brigitte Tohm'
    ),
    (
        'Menthe',
        'https://images.unsplash.com/photo-1582556135623-653b87486f21?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=995&q=80',
        'Abby Boggier'
    ),
    (
        'Piment',
        'https://images.unsplash.com/photo-1526346698789-22fd84314424?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80',
        'Elle Hughes'
    ),
    (
        'Poireau',
        'https://images.unsplash.com/photo-1549913468-0ddc24a4a1bf?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        'Heather Gill'
    )(
        'Ail',
        'https://images.unsplash.com/photo-1579705744772-f26014b5e084?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        'Tijana Drndarski'
    ),
    (
        'Artichaud',
        'https://images.unsplash.com/photo-1615421461965-64d52bc8399f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        '
Margaret Jaszowska'
    ),
(
        'Asperge',
        'https://images.unsplash.com/photo-1562068609-d1588b747e3e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
        'Visual Stories || Micheile'
    ),
(
        'Basilic',
        'https://images.unsplash.com/photo-1527964105263-1ac6265a569f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80',
        '
Rob Pumphrey'
    ),
(
        'Blette',
        'https://images.unsplash.com/photo-1553536645-f83758b55d23?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=681&q=80',
        '
Heather Barnes'
    ),
(
        'Betterave',
        'https://images.unsplash.com/photo-1593105544559-ecb03bf76f82?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
Emma-Jane Hobden'
    ),
(
        'Céleri branche',
        'https://images.unsplash.com/photo-1601459427108-47e20d579a35?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=675&q=80',
        '
Mutzii'
    ),
(
        'Céleri-rave',
        'https://images.unsplash.com/photo-1575286368486-a9bd023a3d1e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1037&q=80',
        '
Yuval Zukerman'
    ),
(
        'Cerfeuil',
        'https://cdn.pixabay.com/photo/2019/04/28/23/07/chervil-4164701_960_720.jpg',
        'Inconnu'
    ),
(
        'Brocoli',
        'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=818&q=80',
        '
Annie Spratt'
    ),
(
        'Chou-fleur',
        'https://images.unsplash.com/photo-1584615467033-75627d04dffe?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
Louis Hansel'
    ),
(
        'Ciboulette',
        'https://images.unsplash.com/photo-1593149198123-46380dbd87fd?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        '
Laura Ockel'
    ),
(
        'Choux',
        'https://images.unsplash.com/photo-1611105637889-3afd7295bdbf?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80',
        '
ibuki Tsubo'
    ),
(
        'Concombre',
        'https://images.unsplash.com/photo-1589621316382-008455b857cd?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
Markus Winkler'
    ),
(
        'Coriandre',
        'https://images.unsplash.com/photo-1588879460618-9249e7d947d1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80',
        '
Chandan Chaurasia'
    ),
(
        'Cornichon',
        'https://images.unsplash.com/photo-1591340270341-00a786ffc0aa?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        '
Markus Spiske'
    ),
(
        'Echalotte',
        'https://images.unsplash.com/photo-1554978264-ac549b2feba2?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
Barbara Cilliers'
    ),
(
        'Epinard',
        'https://images.unsplash.com/photo-1576045057995-568f588f82fb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=80',
        '
Elianna Friedman'
    ),
(
        'Estragon',
        'https://cdn.pixabay.com/photo/2013/06/01/03/31/tarragon-115368_960_720.jpg',
        'Inconnu'
    ),
(
        'Fenouil',
        'https://images.assetsdelivery.com/compings_v2/lukeluke/lukeluke1901/lukeluke190100035.jpg',
        'Inconnu'
    ),
(
        'Haricot vert',
        'https://images.unsplash.com/photo-1574963835594-61eede2070dc?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=967&q=80',
        '
Bob Bowie'
    ),
(
        'Marjolaine',
        'https://images.unsplash.com/photo-1501085934018-450c8e615dbc?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        '
Monika Grabkowska'
    ),
(
        'Oignon',
        'https://images.unsplash.com/photo-1580201092675-a0a6a6cafbb1?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
mayu ken'
    ),
(
        'Origan',
        'https://images.unsplash.com/photo-1595835088291-8690a8044df1?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=639&q=80',
        '
Tina Xinia'
    ),
(
        'Ortie',
        'https://images.unsplash.com/photo-1526127410-01ef03017f7b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=967&q=80',
        '
Paul Morley'
    ),
(
        'Oseille',
        'https://images.unsplash.com/photo-1620661551565-53e190ef9701?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80',
        '
Filipp Romanovski'
    ),
(
        'Panais',
        'https://images.unsplash.com/photo-1584118247518-68fd1f69ad4a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=714&q=80',
        '
Charles Deluvio'
    ),
(
        'Persil',
        'https://images.unsplash.com/photo-1568493840567-5836c376e857?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80',
        '
Hanna Stolt'
    ),
(
        'Petit pois',
        'https://images.unsplash.com/photo-1592394533824-9440e5d68530?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=967&q=80',
        '
Artie Kostenko'
    ),
(
        'Poivron',
        'https://images.unsplash.com/photo-1525607551316-4a8e16d1f9ba?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=654&q=80',
        '
Honza Vojtek'
    ),
(
        'Radis noir',
        'https://image.freepik.com/photos-gratuite/divers-radis-frais-radis-blanc-long-radis-rose-radis-noir_114579-47626.jpg',
        'Inconnu'
    ),
(
        'Rhubarbe',
        'https://images.unsplash.com/photo-1557648493-6e5f8afda63d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        '
Monika Grabkowska'
    ),
(
        'Romarin',
        'https://images.unsplash.com/photo-1607721098274-e54cbfab475d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
        '
Jocelyn Morales'
    ),
(
        'Salsifis',
        'https://cdn.pixabay.com/photo/2018/09/18/18/30/salsify-3686887_960_720.jpg',
        'Inconnu'
    ),
(
        'Sauge',
        'https://images.unsplash.com/photo-1606841610375-7cd2adbadded?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
        '
Paulina H.'
    ),
(
        'Thym',
        'https://images.unsplash.com/photo-1606072104299-cdaab62c0a07?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80',
        '
Anja Junghans'
    ),
(
        'Abricot',
        'https://images.unsplash.com/photo-1524222835726-8e7d453fa83c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
        '
LUM3N'
    ),
(
        'Airelle',
        'https://images.unsplash.com/photo-1598768357792-efc94a4a9042?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        '
Klara Kulikova'
    ),
(
        'Amande',
        'https://images.unsplash.com/photo-1583126379180-ec70bb3178b1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=967&q=80',
        '
Avinash Kumar'
    ),
(
        'Avocat',
        'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=968&q=80',
        '
Thought Catalog'
    ),
(
        'Cerise',
        'https://images.unsplash.com/photo-1559181567-c3190ca9959b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80',
        '
Mae Mu'
    ),
(
        'Châtaigne',
        'https://images.unsplash.com/photo-1506158568548-fc86ccf0d2b1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=639&q=80',
        '
Ricardo Gomez Angel'
    ),
(
        'Citron',
        'https://images.unsplash.com/photo-1590502593747-42a996133562?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=675&q=80',
        '
Thitiphum Koonjantuek'
    ),
(
        'Clémentine',
        'https://images.unsplash.com/photo-1615421461869-69c341309bcd?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        '
Margaret Jaszowska'
    ),
(
        'Coing',
        'https://images.unsplash.com/photo-1421167418805-7f170a738eb4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
        '
margot pandone'
    ),
(
        'Figue',
        'https://images.unsplash.com/photo-1579845141066-883286ebb39f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=80',
        '
Quin Engle'
    ),
(
        'Figue de barbarie',
        'https://images.unsplash.com/photo-1563422156298-c778a278f9a5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1052&q=80',
        '
Frankie Lopez'
    ),
(
        'Fraise',
        'https://images.unsplash.com/photo-1543158181-e6f9f6712055?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
Maksim Shutov'
    ),
(
        'Framboise',
        'https://images.unsplash.com/photo-1618422689173-3dbcdeb82fa7?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=807&q=80',
        '
Jocelyn Morales'
    ),
(
        'Groseille',
        'https://images.unsplash.com/photo-1591085654809-7cdfbd103b8c?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
Bermix Studio'
    ),
(
        'Jujube',
        'https://images.unsplash.com/photo-1537201872643-ff006e1f016f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
Mona Mok'
    ),
(
        'Kaki',
        'https://images.unsplash.com/photo-1590005240700-39f39861fa6a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=925&q=80',
        '
Estúdio Bloom'
    ),
(
        'Kiwi',
        'https://images.unsplash.com/photo-1585059895524-72359e06133a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80',
        '
engin akyurt'
    ),
(
        'Mandarine',
        'https://images.unsplash.com/photo-1549888834-3ec93abae044?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1050&q=80',
        '
Graphic Node'
    ),
(
        'Myrtille',
        'https://images.unsplash.com/photo-1498557850523-fd3d118b962e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
Joanna Kosinska'
    ),
(
        'Noisette',
        'https://images.unsplash.com/photo-1573851552153-816785fecf4a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
        '
Janine Robinson'
    ),
(
        'Noix',
        'https://images.unsplash.com/photo-1524593656068-fbac72624bb0?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
Tom Hermans'
    ),
(
        'Olive',
        'https://images.unsplash.com/photo-1591122523233-22037c1dec9f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        '
Emre'
    ),
(
        'Orange',
        'https://images.unsplash.com/photo-1547514701-42782101795e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        '
Xiaolong Wong'
    ),
(
        'Pamplemousse',
        'https://images.unsplash.com/photo-1557656806-534427e2fe2e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=700&q=80',
        '
Georgia de Lotz'
    ),
(
        'Pêche',
        'https://images.unsplash.com/photo-1595743825637-cdafc8ad4173?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80',
        '
Jason Leung'
    ),
(
        'Physalis',
        'https://images.unsplash.com/photo-1506176874237-f0abdd2041a0?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
Jonathan Pielmayer'
    ),
(
        'Poire',
        'https://images.unsplash.com/photo-1570115114436-63d3405246e7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=634&q=80',
        '
Moritz Kindler'
    ),
(
        'Pomme',
        'https://images.unsplash.com/photo-1584306670957-acf935f5033c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=633&q=80',
        '
Sara Cervera'
    ),
(
        'Raisin',
        'https://images.unsplash.com/photo-1474152042542-1e794677a34b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
        '
Amos Bar-Zeev'
    );

/*INSERT INTO
    "variety"("name", "category_id")
VALUES
    ('De nice', 1),
    ('Rome', 2),
    ('Blanche', 3),
    ('de Chantenay à Coeur Rouge', 4),
    ('de Colmar à Coeur Rouge', 4),
    ('Jaune obtuse du doubs', 4),
    ('Batavia', 5),
    ('Pommée', 5),
    ('Iceberg', 5),
    ('Chicorée frisée', 5),
    ('Angelus', 6),
    ('bacchus', 6),
    ('Zlata', 6),
    ('Noir', 6),
    ('Malling promise', 7),
    ('Willamette', 7),
    ('Tulameen', 7),
    ('Surprise dautomne', 7),
    ('Beurré Giffard', 8),
    ('Dr Jules Guyot', 8),
    ('Williams', 8),
    ('Beurré Hardy', 8),
    ('Ali Baba', 9),
    ('Astrakhanski', 9),
    ('Crimson Sweet', 9),
    ('Jubilee', 9),
    ('Charantais', 10),
    ('Canari', 10),
    ('Banana', 10),
    ('Delicious 51', 10),
    ('Mooregold', 11),
    ('Lady Godiva', 11),
    ('Dickinson', 11),
    ('Tuffy', 11),
    ('Pommée', 12),
    ('Menthe Poivré', 12),
    ('Chocolat', 12),
    ('De Corée', 12),
    ('Violet Sparkle', 13),
    ('Balloon', 13),
    ('Aji Yellow', 13),
    ('Bonnet d’Évêque', 13),
    ('King Richard', 14),
    ('Bleu de Solaize', 14),
    ('Buttoir à manche', 14),
    ('Bleu d’Hiver', 14);

INSERT INTO
    "variety"("name", "category_id")
VALUES
    ('de Chantenay à Coeur Rouge', 4),
    ('de Colmar à Coeur Rouge', 4),
    ('Jaune obtuse du doubs', 4),
    ('Batavia', 5),
    ('Pommée', 5),
    ('Iceberg', 5),
    ('Chicorée frisée', 5),
    ('Angelus', 6),
    ('bacchus', 6),
    ('Zlata', 6),
    ('Noir', 6),
    ('Malling promise', 7),
    ('Willamette', 7),
    ('Tulameen', 7),
    ('Surprise dautomne', 7),
    ('Beurré Giffard', 8),
    ('Dr Jules Guyot', 8),
    ('Williams', 8),
    ('Beurré Hardy', 8),
    ('Ali Baba', 9),
    ('Astrakhanski', 9),
    ('Crimson Sweet', 9),
    ('Jubilee', 9),
    ('Charantais', 10),
    ('Canari', 10),
    ('Banana', 10),
    ('Delicious 51', 10),
    ('Mooregold', 11),
    ('Lady Godiva', 11),
    ('Dickinson', 11),
    ('Tuffy', 11),
    ('Pommée', 12),
    ('Menthe Poivré', 12),
    ('Chocolat', 12),
    ('De Corée', 12),
    ('Violet Sparkle', 13),
    ('Balloon', 13),
    ('Aji Yellow', 13),
    ('Bonnet d’Évêque', 13),
    ('King Richard', 14),
    ('Bleu de Solaize', 14),
    ('Buttoir à manche', 14),
    ('Bleu d’Hiver', 14);
*/
/*INSERT INTO
    "seed"(
        "user_id",
        "variety_id",
        "description",
        "conseil"
    )
VALUES
    (
        1,
        1,
        'Petite courgette longue',
        'Semis a faire 8 semaine avant la mise en terre'
    ),
    (
        2,
        2,
        'Tomate allongé parfaite pour sauce',
        'A planter en plein soleil'
    ),
    (
        3,
        3,
        'Aubergine a la chaire tendre de couleur blanche, parfait pour une poèlé',
        'Long a germé'
    ),
    (
        4,
        1,
        'Petite courgette longue',
        'Semis a faire 8 semaine avant la mise en terre'
    ),
    (
        4,
        2,
        'Tomate allongé parfaite pour sauce',
        'A planter en plein soleil'
    ),
    (
        3,
        3,
        'Aubergine a la chaire tendre de couleur blanche, parfait pour une poèlé',
        'Long a germé'
    ),
    (
        5,
        1,
        'Petite courgette longue',
        'Semis a faire 8 semaine avant la mise en terre'
    ),
    (
        5,
        2,
        'Tomate allongé parfaite pour sauce',
        'A planter en plein soleil'
    ),
    (
        5,
        3,
        'Aubergine a la chaire tendre de couleur blanche, parfait pour une poèlé',
        'Long a germé'
    ),
    (
        2,
        1,
        'Petite courgette longue',
        'Semis a faire 8 semaine avant la mise en terre'
    ),
    (
        1,
        2,
        'Tomate allongé parfaite pour sauce',
        'A planter en plein soleil'
    ),
    (
        2,
        3,
        'Aubergine a la chaire tendre de couleur blanche, parfait pour une poèlé',
        'Long a germé');*/

/*
CREATE VIEW seedlist AS
SELECT
    seed.id,
    seed.user_id,
    seed.description,
    seed.conseil,
    seed.availability,
	seed.created_at AS created_at,
	seed.variety_id AS variety_id,
    category.id AS category_id,
    category.name AS category_name,
    category.img AS category_img,
    category.img_author AS cathegory_img_author,
    variety.name AS variety_name,
    userdata.pseudo AS pseudo_user,
    userdata.email AS email_user
FROM
    seed
    JOIN userdata ON userdata.id = seed.user_id
    JOIN variety ON seed.variety_id = variety.id
    JOIN category ON variety.category_id = category.id;
*/
COMMIT;