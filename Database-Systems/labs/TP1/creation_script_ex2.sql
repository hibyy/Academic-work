   drop table resultat;
   drop table cycliste;
 drop table etape;
  drop table equipe;
  drop table resultatfinal;


CREATE TABLE equipe (idequipe number NOT NULL, 
                    nom varchar(20), 
                    nbCycliste number,
                     PRIMARY KEY(idequipe));

CREATE TABLE cycliste (idcycliste number NOT NULL,
                        nom  varchar(20), 
                        idequipe number NOT NULL,
                        PRIMARY KEY (idcycliste),
                         CONSTRAINT fk_1 FOREIGN KEY (idequipe) REFERENCES equipe (idequipe) );

 CREATE TABLE  etape (idetape number NOT NULL,
                       depart varchar(20), 
                      arrivee varchar(20), 
                      distance number NOT NULL,
                      PRIMARY KEY (idetape));

  CREATE TABLE resultat (idcycliste number NOT NULL,
                         idetape number NOT NULL,
                          temps number,
                         PRIMARY KEY (idcycliste,idetape),
                         CONSTRAINT fk_2 FOREIGN KEY (idcycliste) REFERENCES cycliste(idcycliste),
                         CONSTRAINT fk_3 FOREIGN KEY (idetape) REFERENCES etape  (idetape));

CREATE TABLE resultatfinal (idcycliste number NOT NULL, totaltemps number);

  
insert into etape values (1, 'oran','sba',80);
insert into etape values (2, 'sba','benisaf',90);
insert into etape values (3, 'benisaf','tlemcen',100);

insert into equipe values (1, 'sbacy',4);
  
insert into cycliste values (1, 'amine', 1); insert into resultat values (1, 1, 7000); insert into resultat values (1, 2, 8100); insert into resultat values (1, 3, 9500);
insert into cycliste values (2, 'samir', 1); insert into resultat values (2, 1, 6950); insert into resultat values (2, 2, 8109);
insert into cycliste values (3, 'fouad', 1);insert into resultat values (3, 1, 7500);
insert into cycliste values (4, 'ali', 1); insert into resultat values (4, 1, 7002); insert into resultat values (4, 2, 8091); insert into resultat values (4, 3, 9400);

insert into equipe values (2, 'cyAlgerie',4);
  
insert into cycliste values (5, 'malki', 2); insert into resultat values (5, 1, 7020); insert into resultat values (5, 2, 7989); insert into resultat values (5, 3, 9405);
insert into cycliste values (6, 'djamel', 2); insert into resultat values (6, 1, 6949); insert into resultat values (6, 2, 7985); insert into resultat values (6, 3, 9392);
insert into cycliste values (7, 'mohamed', 2); insert into resultat values (7, 1, 7021); insert into resultat values (7, 2, 8004); insert into resultat values (7, 3, 9405);
insert into cycliste values (8, 'tarek', 2); insert into resultat values (8, 1, 7505);

  
  commit;