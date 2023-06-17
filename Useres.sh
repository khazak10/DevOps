#!/bin/bash
# Vérifier si l'utilisateur en cours d'exécution est un superutilisateur
if [ "$EUID" -ne 0 ]; then
  echo "Ce script doit être exécuté en tant que superutilisateur." 
  exit 1
fi


# Vérifier si le nombre de paramètres est correct
if [ "$#" -ne 1 ]; then
  echo "Utilisation : $0 <nombre d'utilisateurs>"
  exit 1
fi

#---------------creation des groupes -----------------
# Créer le groupe s'il n'existe pas déjà


if ! getent group $nom_groupe > /dev/null; then
  groupadd admin
  groupadd dev
fi


#-----------creation et attribution des users to groupes 
# with all right



if id -u DevopsAdminNour >/dev/null 2>&1; then
    echo "L'utilisateur DevopsAdminNour existe déjà."
else
   useradd -m -G admin DevopsAdminNour


# + randon password

password=$(openssl rand -base64 12)


# Définir le mot de passe pour le utilisateur

echo "DevopsAdminNour:$password" | chpasswd

#display user and her password

echo "Utilisateur DevopsAdminNour créé avec succès et ajouté au groupe Admin."
    echo "Mot de passe : $password"
fi

if id -u DevopsAdminHamza >/dev/null 2>&1; then
    echo "L'utilisateur DevopsAdminHamza existe déjà."
else

useradd -m -G admin DevopsAdminHamza

# + randon password

password=$(openssl rand -base64 12)


# Définir le mot de passe pour les utilisateurs

echo "DevopsAdminHamza:$password" | chpasswd

#display user and her password

    echo "Utilisateur DevopsAdminHamza créé avec succès et ajouté au groupe Admin."
    echo "Mot de passe : $password"
fi


#------ create and add users to groupe dev
nb_utilisateurs=$1
for ((i=1; i<=nb_utilisateurs; i++))
do
    username="DevopsDev$i"
    
    # Vérifier si l'utilisateur existe
    if id -u $username >/dev/null 2>&1; then
   password1=$(openssl rand -base64 12)
     # Définir le mot de passe pour l'utilisateur
    echo "$username:$password1" | chpasswd
    sudo chmod u+w+x -R "/home/$username"   
      # Ajouter l'utilisateur au groupe
        usermod -aG dev $username
           echo "Utilisateur $username est deja dans existe et bien ajoute au groupe dev "
                 echo "Mot de passe : $password1"
    else
     password1=$(openssl rand -base64 12)
    
    # Créer l'utilisateur
    useradd -m $username
    
    # Définir le mot de passe pour l'utilisateur
    echo "$username:$password1" | chpasswd
    
           # Ajouter l'utilisateur au groupe
        usermod -aG dev $username
        
        # Donner les droits pour éditer et exécuter dans le répertoire personnel
    sudo chmod u+w+x -R "/home/$username"
        echo "L'utilisateur $username est bien ajouter et ajouté avec succès au groupe dev ."
      echo "Mot de passe : $password1"
    fi
done
