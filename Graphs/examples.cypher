//Récupération de toutes les parties des 10 dernières années pour les joueurs inscrits l'année en cours 
MATCH (gagnant:JoueurFFG)-[r]->(perdant:JoueurFFG)  
WHERE r.date > date("2012-01-01") AND gagnant.club IS NOT NULL AND perdant.club IS NOT NULL AND gagnant.club <> "Inconnu" AND perdant.club <> "Inconnu" 
RETURN gagnant.nom,perdant.nom

// Récupération de l'ensemble des mathcs joué entre des joueurs de montpellier, de rouen et de rouen-montpellier
MATCH (gagnant:JoueurFFG)-[r]-(perdant:JoueurFFG) 
WHERE r.date > date("2012-01-01") AND (gagnant.club ="Montpellier Komoku (34Mo)" OR gagnant.club = "Rouen (76Ro)") AND (perdant.club ="Montpellier Komoku (34Mo)" OR perdant.club = "Rouen (76Ro)") 
RETURN gagnant.nom,perdant.nom

// Récupération de matchs entre clubs du nord 
MATCH (n:JoueurFFG)-[]-(k:JoueurFFG) 
WHRE (n.club="Le Havre (76Ha)" OR n.club="Rouen (76Ro)" OR n.club ="LilleGo (59Li)" OR n.club="Arras - L'Atelier du Go Arrageois (62Ar)" OR n.club="Rennes - Club Rengo (35Re)" OR n.club="Nantes (44NE)" or n.club="Miai Nantes (44MN)" OR n.club="Yosakura club de go de Nantes (44Na)") AND (k.club="Le Havre (76Ha)" OR k.club="Rouen (76Ro)" OR k.club ="LilleGo (59Li)" OR k.club="Arras - L'Atelier du Go Arrageois (62Ar)" OR k.club="Rennes - Club Rengo (35Re)" OR k.club="Nantes (44NE)" OR k.club="Miai Nantes (44MN)" OR k.club="Yosakura club de go de Nantes (44Na)")  
RETURN n.nom, k.nom

// Intégration via API python des joueurs après scrapping du site FFG
MERGE (joueur:JoueurFFG {nom:"%s",rang:"%s",club:"%s",idFFG:"%d"})

MERGE (gagnant:JoueurFFG {nom:"%s"}) 
MERGE (perdant:JoueurFFG {nom:"%s"})\
CREATE (gagnant)-[:GAGNE {lieu:"%s",date:date("%s")}]->(perdant)

//Suppression des anonymes
MATCH (n:JoueurFFG) WHERE n.nom='A. ANONYME' DETACH DELETE n

//Shortest path
MATCH (m:JoueurFFG) WHERE m.nom<>"%s" and m.club is not null and m.club <> "Inconnu"
MATCH path = shortestPath( (j:JoueurFFG{nom:"%s"})-[r*..10]-(m) )
RETURN j.nom,m.nom,nodes(path),size([g in nodes(path)]) AS count

// Après manipulaton python
MATCH (m:JoueurFFG{nom:"%s"})
SET m.proximity="%f"





