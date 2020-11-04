#!/bin/bash
vert='\033[0;32m'
rouge='\033[0;31m'
violet='\033[0;35m'
neutre='\033[0m'
rm -rf resultat.txt

echo "tests correctes :" >> resultat.txt
let "reussi = 0"
let "echec = 0"
let "nombre = 0"

for i in `ls  ../test/test_correct`
do
let "nombre = nombre + 1"
echo -e "${violet}$i${neutre}" >> resultat.txt
retour=`./as < ../test/test_correct/$i 2>&1`
let "valret = $?"
echo " valeur de retour :    $valret" >> resultat.txt
echo " retour :" >> resultat.txt
echo -e "${rouge}$retour${neutre}" >> resultat.txt
if [ $valret == 0 ]
then
	let "reussi = reussi + 1"
else
	let "echec = echec + 1"
fi
done

echo -e "Nombre de tests correctes réussis ${vert}BONNE NOUVELLE${neutre}:" >> resultat.txt
echo $reussi "/" $nombre >> resultat.txt 
echo -e "Nombre de tests incorrectes échoues ${rouge}MAUVAISE NOUVELLE${neutre}:" >> resultat.txt
echo $echec "/" $nombre  >> resultat.txt 
echo \ >>resultat.txt
echo \ >>resultat.txt


let "reussi = 0"
let "echec = 0"
let "nombre = 0"
echo "tests incorrectes :" >> resultat.txt
for i in `ls  ../test/test_incorrect`
do
let "nombre = nombre + 1"
echo -e "${violet}$i${neutre}" >> resultat.txt
retour=`./as < ../test/test_incorrect/$i 2>&1`
let "valret = $?"
echo " valeur de retour :    $valret" >> resultat.txt
echo " retour :" >> resultat.txt
echo -e "${rouge}$retour${neutre}" >> resultat.txt 
if [ $valret == 1 ]
then
	let "reussi = reussi + 1"
else
	let "echec = echec + 1"
fi
done

echo -e "Nombre de tests incorrectes échoues ${vert}BONNE NOUVELLE${neutre}:" >> resultat.txt
echo $echec "/" $nombre >> resultat.txt 
echo -e "Nombre de test incorrectes réussis ${rouge}MAUVAISE NOUVELLE${neutre}:" >> resultat.txt
echo $reussi "/" $nombre  >> resultat.txt 






