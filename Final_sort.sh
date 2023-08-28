#!/bin/bash

# Chemin du répertoire contenant les fichiers d'entrée
input_directory="./Sorted/"

# Lister les fichiers d'entrée dans le répertoire (selon le format "sorted.*")
input_files=("$input_directory"/sorted_*)

# Parcourir tous les fichiers d'entrée
for ((i=0; i<${#input_files[@]}; i++)); do
    file_a="${input_files[$i]}"
    
    # Parcourir tous les autres fichiers pour la comparaison
    for ((j=0; j<${#input_files[@]}; j++)); do
        if [[ $i -ne $j ]]; then
            file_b="${input_files[$j]}"
            
            # Obtenir le nombre de lignes des fichiers A et B
            line_count_a=$(wc -l < "$file_a")
            line_count_b=$(wc -l < "$file_b")
            
            # Si le nombre de lignes est différent, passer au fichier suivant
            if [[ $line_count_a -ne $line_count_b ]]; then
                continue
            fi
            
            # Comparaison des lignes en suivant les règles spéciales
            
            for ((k=3; k<=$line_count_a; k+=5)); do
                line_a=$(sed -n "${k}p" "$file_a")
                match=false
                for ((v=1; v<=$line_count_b; v+=1)); do
                    line_b=$(sed -n "${v}p" "$file_b")
                    if [[ "$line_a" == "$line_b" ]]; then
                        match=true
                        break
                    fi
                done
                if ! $match; then
                    break
                fi
            done
            if $match; then
                echo "$file_a"
                echo "$file_b"
                rm "$file_b"
            fi
        fi
    done
done

echo "Le processus est terminé."
