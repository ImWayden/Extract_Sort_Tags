#!/bin/bash

# Nom du fichier d'entrée
input_file="Tags.txt"

# Utilisation de csplit pour diviser le fichier en blocs
csplit -s -z "$input_file" '/^$/' '{*}' 2>/dev/null

# Parcourir les fichiers temporaires créés par csplit
for tempfile in xx*; do
    # Compter le nombre de lignes dans le fichier temporaire
    line_count=$(wc -l < "$tempfile")
    
    # Nom du fichier de sortie en fonction du nombre de lignes
    output_file="output_$line_count.txt"
    
    # Ajouter le contenu du fichier temporaire au fichier de sortie
    cat "$tempfile" >> "$output_file"
done

# Nettoyage des fichiers temporaires
rm xx*

echo "La séparation des blocs de texte est terminée."