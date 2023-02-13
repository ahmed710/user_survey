#!/bin/bash

#twarri l'usage de l'outil test validé
function show_usage(){
echo "surveiller.sh:[-h][-d][-j][-v][-g][-m] user.."
exit 1
}

if [ $# -eq 0 ]; then
	echo "ajouter un argument s.v.p!!!"
show_usage
exit 1
fi


# help call : test validé 
function HELP(){
cat /home/osboxes/Desktop/help.txt
}

# Afficher les dernier cnx : test validé
function dernier_cnx(){
local user=$1
last -F $user
}

#el journata 
function journal(){
local user=$1
touch journal 
last -f journal
last -F -n 100  $user> journal
cat journal 
} 

#supp les entrées qui datent de plus de 7 jours 
function supp_entry(){
local journal =$1
time=$(date +%s)
annee=$(date | awk '{print $7}'| cut -c3-4)
while read -r journal; do
    col=$(echo $journal | awk '{print $5"-"$6}')
    fTime=$(date -j -f "%B-%d-%y" "$col"-"$annee" +%s)
    var=$(($time - $fTime))
    id=$(nl -ba | awk '{print $1}')
    if [ $var -gt 604800 ];
    then
        sed $id'd'
    fi
done < journal
}
function nom_v(){
echo "Ahmed Boukhari et Zouhour Rouissi et @version 1.00 de survey script"
}

#Afficher le menu a choix muliple Yad 
function affichage(){
champ=$(yad --title="Window Surveiller Ahmed & Zouhour" \ --form  \
--button="help":1 \
--button="journaliser":2 \
--button="supprimer":3 \
--button="dernier cnx":4 \
--button="Noms":5 )
fon=$?
if [[ $fon -eq 1 ]]; then HELP
elif [[ $fon -eq 2 ]]; then 
read -p "Entrez les noms d'utilisateur : " users
        journal $users 
elif [[ $fon -eq 3 ]]; then 
read -p "Entrez les noms d'utilisateur : " users
	 supp_entry $users
elif [[ $fon -eq 4 ]]; then
read -p "Entrez les noms d'utilisateur : " users
 	 dernier_cnx $users
elif [[ $fon -eq 5 ]]; then
read -p "Entrez les noms d'utilisateur : " users
 	 nom_v $users
fi
}

while getopts "hgvmdj" opt; do
  case $opt in
    h) HELP     
      exit 0
      ;;
    m)
      echo "1. Afficher les dernieres connexion ^"
      echo "2. Supprssion des connctions qui dates plus que 7 days ^"
      echo "3. Les noms et la version su script "
      echo "4. Affichage du contenue de journal"
      read -p "Choisissez une option: " option
      case $option in
        1) read -p "Entrez les noms d'utilisateur : " users
        dernier_cnx $user
        ;;
        2) read -p "Entrez les noms d'utilisateur : " users
        supp_entry $users
        ;;
        3) nom_v
        ;;
        4) journal
        ;;  
        *) echo "Option non valide"
        show_usage
        exit 1
        ;;
      esac
      exit 0
      ;;
    g) affichage
    exit
    ;;
    d)read -p "Entrez les noms d'utilisateur : " users 
    dernier_cnx $users
      exit 0
      ;;
    s)read -p "Entrez les noms d'utilisateur : " users 
    supp_entry $users   
      exit 0
      ;;
    v) nom_v
    exit
    ;;
    j) journal
    exit
    ;;
    
  esac 
done
