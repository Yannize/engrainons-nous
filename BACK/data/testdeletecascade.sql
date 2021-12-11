CREATE TABLE "userdatadelete"(
    "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "pseudo" TEXT NOT NULL UNIQUE
   );
INSERT INTO "userdatadelete" ("pseudo") VALUES ('CEDRIC'),('ANNA'),('IVY');
CREATE TABLE "messagedelete"(
    "id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "message" TEXT NOT NULL,
	"user_id" INT NOT NULL REFERENCES userdatadelete(id) ON DELETE CASCADE
   );
   INSERT INTO "messagedelete"("message", "user_id") VALUES ('j"aime les pizzas au kiwi et toi ?', 1),
('j"aime les pizzas au kiwi et toi ?', 1),
('j"aime les pizzas a lananas et toi ?', 2),
('j"aime les pizzas au lananas et toi ?', 1);