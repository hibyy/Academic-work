

-- REQUÊTE 1 : Agrégation simple - CORRIGÉE
-- --------------------------------------------------------
SELECT
    t.ANNEE,
    t.MOIS,
    m.REGION AS nom_region,
    SUM(v.QTE_VENDUE) AS somme_qte,
    AVG(v.MONTANTVENTE) AS montant_moyen
FROM VENTE v
JOIN DIM_TEMPS t ON v.ID_TEMPS = t.ID_TEMPS
JOIN DIM_MAGASIN m ON v.ID_MAGASIN = m.ID_MAGASIN
WHERE t.MOIS BETWEEN 1 AND 3
GROUP BY t.ANNEE, t.MOIS, m.REGION
ORDER BY m.REGION, t.ANNEE, t.MOIS;


-- REQUÊTE 2 : ROLLUP - CORRIGÉE
-- --------------------------------------------------------
SELECT
    m.REGION AS nom_region,
    t.ANNEE,
    t.MOIS,
    SUM(v.QTE_VENDUE) AS somme_qte,
    AVG(v.MONTANTVENTE) AS montant_moyen
FROM VENTE v
JOIN DIM_TEMPS t ON v.ID_TEMPS = t.ID_TEMPS
JOIN DIM_MAGASIN m ON v.ID_MAGASIN = m.ID_MAGASIN
WHERE t.MOIS BETWEEN 1 AND 3
GROUP BY ROLLUP (m.REGION, t.ANNEE, t.MOIS)
ORDER BY m.REGION, t.ANNEE, t.MOIS;


-- REQUÊTE 3 : CUBE avec DECODE - CORRIGÉE
-- --------------------------------------------------------
SELECT
    DECODE(GROUPING(m.REGION), 1, 'TOUTES REGIONS', m.REGION) AS region,
    DECODE(GROUPING(t.ANNEE), 1, 'TOUTES ANNEES', TO_CHAR(t.ANNEE)) AS annee,
    DECODE(GROUPING(t.MOIS), 1, 'TOUS MOIS', TO_CHAR(t.MOIS)) AS mois,
    SUM(v.QTE_VENDUE) AS somme_qte,
    AVG(v.MONTANTVENTE) AS montant_moyen
FROM VENTE v
JOIN DIM_TEMPS t ON v.ID_TEMPS = t.ID_TEMPS
JOIN DIM_MAGASIN m ON v.ID_MAGASIN = m.ID_MAGASIN
WHERE t.MOIS BETWEEN 1 AND 3
GROUP BY CUBE (m.REGION, t.ANNEE, t.MOIS)
ORDER BY m.REGION, t.ANNEE, t.MOIS;


-- REQUÊTE 4 : GROUPING SETS - CORRIGÉE
-- --------------------------------------------------------
SELECT
    t.ANNEE,
    m.VILLE AS nom_ville,
    p.NOM_PRODUIT,
    p.CATEGORIE AS nom_categorie,
    m.REGION AS nom_region,
    MAX(v.QTE_VENDUE) AS qte_max
FROM VENTE v
JOIN DIM_TEMPS t ON v.ID_TEMPS = t.ID_TEMPS
JOIN DIM_PRODUIT p ON v.ID_PRODUIT = p.ID_PRODUIT
JOIN DIM_MAGASIN m ON v.ID_MAGASIN = m.ID_MAGASIN
WHERE t.ANNEE = 2019
  AND t.TRIMESTRE = 2
GROUP BY GROUPING SETS (
    (t.ANNEE, p.NOM_PRODUIT, m.VILLE),
    (t.ANNEE, p.CATEGORIE, m.REGION)
)
ORDER BY m.REGION, p.CATEGORIE, m.VILLE, p.NOM_PRODUIT;


-- REQUÊTE 5 : RANK global et partitionné - CORRIGÉE
-- --------------------------------------------------------
SELECT
    p.NOM_PRODUIT,
    m.REGION AS nom_region,
    SUM(v.QTE_VENDUE) AS total_qte,
    RANK() OVER (PARTITION BY p.NOM_PRODUIT ORDER BY SUM(v.QTE_VENDUE) DESC) AS rang_regional,
    RANK() OVER (ORDER BY SUM(v.QTE_VENDUE) DESC) AS rang_global
FROM VENTE v
JOIN DIM_TEMPS t ON v.ID_TEMPS = t.ID_TEMPS
JOIN DIM_PRODUIT p ON v.ID_PRODUIT = p.ID_PRODUIT
JOIN DIM_MAGASIN m ON v.ID_MAGASIN = m.ID_MAGASIN
WHERE t.ANNEE = 2018
GROUP BY p.NOM_PRODUIT, m.REGION
ORDER BY p.NOM_PRODUIT, rang_regional;


-- REQUÊTE 6 : Top 3 par catégorie et année - CORRIGÉE
-- --------------------------------------------------------
SELECT *
FROM (
    SELECT
        p.CATEGORIE AS nom_categorie,
        t.ANNEE,
        p.NOM_PRODUIT,
        SUM(v.QTE_VENDUE) AS total_qte,
        RANK() OVER (
            PARTITION BY p.CATEGORIE, t.ANNEE
            ORDER BY SUM(v.QTE_VENDUE) DESC
        ) AS rang
    FROM VENTE v
    JOIN DIM_TEMPS t ON v.ID_TEMPS = t.ID_TEMPS
    JOIN DIM_PRODUIT p ON v.ID_PRODUIT = p.ID_PRODUIT
    JOIN DIM_MAGASIN m ON v.ID_MAGASIN = m.ID_MAGASIN
    WHERE m.REGION = 'Ouest'
    GROUP BY p.CATEGORIE, t.ANNEE, p.NOM_PRODUIT
)
WHERE rang <= 3
ORDER BY nom_categorie, annee, rang;

-- REQUÊTE 7 : Top 2 villes avec le moins de ventes - CORRIGÉE
-- --------------------------------------------------------
SELECT *
FROM (
    SELECT
        m.REGION AS nom_region,
        t.ANNEE,
        m.VILLE AS nom_ville,
        SUM(v.QTE_VENDUE) AS total_qte,
        RANK() OVER (
            PARTITION BY m.REGION, t.ANNEE
            ORDER BY SUM(v.QTE_VENDUE) ASC
        ) AS rang
    FROM VENTE v
    JOIN DIM_TEMPS t ON v.ID_TEMPS = t.ID_TEMPS
    JOIN DIM_MAGASIN m ON v.ID_MAGASIN = m.ID_MAGASIN
    JOIN DIM_PRODUIT p ON v.ID_PRODUIT = p.ID_PRODUIT
    WHERE p.CATEGORIE = 'Laitier'
    GROUP BY m.REGION, t.ANNEE, m.VILLE
)
WHERE rang <= 2
ORDER BY nom_region, annee, rang;


-- REQUÊTE 8 : NTILE - Quartiles - CORRIGÉE
-- --------------------------------------------------------
SELECT
    'VILLE' AS type,
    m.VILLE AS nom,
    NTILE(4) OVER (ORDER BY SUM(v.QTE_VENDUE) DESC) AS quartile,
    SUM(v.QTE_VENDUE) AS total_qte
FROM VENTE v
JOIN DIM_TEMPS t ON v.ID_TEMPS = t.ID_TEMPS
JOIN DIM_MAGASIN m ON v.ID_MAGASIN = m.ID_MAGASIN
WHERE t.ANNEE = 2018
GROUP BY m.VILLE

UNION ALL

SELECT
    'PRODUIT' AS type,
    p.NOM_PRODUIT AS nom,
    NTILE(4) OVER (ORDER BY SUM(v.QTE_VENDUE) DESC) AS quartile,
    SUM(v.QTE_VENDUE) AS total_qte
FROM VENTE v
JOIN DIM_TEMPS t ON v.ID_TEMPS = t.ID_TEMPS
JOIN DIM_PRODUIT p ON v.ID_PRODUIT = p.ID_PRODUIT
WHERE t.ANNEE = 2018
GROUP BY p.NOM_PRODUIT
ORDER BY type, quartile, total_qte DESC;


-- REQUÊTE 9 : Fonctions de fenêtrage complexes - CORRIGÉE
-- --------------------------------------------------------
SELECT
    m.NOM_MAGASIN,
    t.ANNEE,
    t.MOIS,
    SUM(v.MONTANTVENTE) AS montant_total,
    MAX(SUM(v.MONTANTVENTE)) OVER (
        PARTITION BY m.NOM_MAGASIN
        ORDER BY t.ANNEE, t.MOIS
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) AS max_3_mois_plus_courant,
    MAX(SUM(v.MONTANTVENTE)) OVER (
        PARTITION BY m.NOM_MAGASIN, t.ANNEE
        ORDER BY t.MOIS
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS max_annee,
    MAX(SUM(v.MONTANTVENTE)) OVER (
        PARTITION BY m.NOM_MAGASIN
        ORDER BY t.ANNEE, t.MOIS
        ROWS BETWEEN 4 PRECEDING AND 4 FOLLOWING
    ) AS max_8_mois,
    LAG(SUM(v.MONTANTVENTE), 12) OVER (
        PARTITION BY m.NOM_MAGASIN, t.MOIS
        ORDER BY t.ANNEE
    ) AS montant_annee_precedente
FROM VENTE v
JOIN DIM_TEMPS t ON v.ID_TEMPS = t.ID_TEMPS
JOIN DIM_MAGASIN m ON v.ID_MAGASIN = m.ID_MAGASIN
GROUP BY m.NOM_MAGASIN, t.ANNEE, t.MOIS
ORDER BY m.NOM_MAGASIN, t.ANNEE, t.MOIS;


-- REQUÊTE 10 : Cumuls et ratios - CORRIGÉE
-- --------------------------------------------------------
SELECT
    m.REGION AS nom_region,
    t.ANNEE,
    p.CATEGORIE AS nom_categorie,
    SUM(v.QTE_VENDUE) AS total_qte,
    SUM(SUM(v.QTE_VENDUE)) OVER (PARTITION BY m.REGION) AS cumul_region,
    SUM(SUM(v.QTE_VENDUE)) OVER (PARTITION BY t.ANNEE) AS cumul_annee,
    RATIO_TO_REPORT(SUM(v.QTE_VENDUE)) OVER (PARTITION BY m.REGION, t.ANNEE) AS ratio
FROM VENTE v
JOIN DIM_TEMPS t ON v.ID_TEMPS = t.ID_TEMPS
JOIN DIM_MAGASIN m ON v.ID_MAGASIN = m.ID_MAGASIN
JOIN DIM_PRODUIT p ON v.ID_PRODUIT = p.ID_PRODUIT
GROUP BY m.REGION, t.ANNEE, p.CATEGORIE
ORDER BY m.REGION, t.ANNEE, p.CATEGORIE;


