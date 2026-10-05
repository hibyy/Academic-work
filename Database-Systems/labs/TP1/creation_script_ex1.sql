              drop table produit;
  drop table PRODUIT_Etranger;

 drop table categorie;

 drop table produitHistory;
 
CREATE TABLE Categorie (IDCategorie number NOT NULL,  nom varchar(45) DEFAULT NULL,
  PRIMARY KEY (IDcategorie));
  
  
  CREATE TABLE produit (
  IDP number NOT NULL,
  designation varchar(20),
  prixunitaire number(*,0),
  IDcategorie number not null,
  PRIMARY KEY (IdP),
  CONSTRAINT fk_c_p FOREIGN KEY (Idcategorie) REFERENCES categorie (Idcategorie)  );
  
  create table PRODUIT_Etranger (IDP number primary key, designation varchar(20), 
                      prixunitaire number(*,0), IDCategorie number,
                      CONSTRAINT PRODUIT_CATEGORIE_FK2 FOREIGN KEY (IDCATEGORIE) REFERENCES 
                      CATEGORIE (IDCATEGORIE) ENABLE);
 
  create table produitHistory  (users varchar(50) not null, Idp int, operation_date date, operation_type varchar(20));

  insert into categorie values (1, 'boisson');
  
  insert into produit values (1, 'coca', 1200,1);
  insert into produit values (2, 'pepsi', 1400,1);
  insert into produit values (3, 'kassera', 1600,1);
  insert into produit values (4, 'rami', 1000,1);
  insert into produit values (5, 'hamoud', 800,1);
  
  commit;