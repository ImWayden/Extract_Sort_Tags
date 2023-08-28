#!/bin/bash

# Nom du fichier d'entrée
input_file="output_5.txt"

# Utilisation de csplit pour diviser le fichier en blocs
csplit -s -z "$input_file" '/^$/' '{*}' 2>/dev/null

# Obtenir la liste des fichiers temporaires créés par csplit
tempfiles=(xx*)

# Parcourir tous les fichiers temporaires
for ((i=0; i<${#tempfiles[@]}; i++)); do
    reference_file="${tempfiles[$i]}"
    reference_lines=$(sort "$reference_file" | uniq -c)
    
    # Variables pour suivre la similarité maximale et les fichiers correspondants
    max_similarity=0
    similar_files=()
    
    # Parcourir tous les autres fichiers pour la comparaison
    for ((j=0; j<${#tempfiles[@]}; j++)); do
        if [[ $i -ne $j ]]; then
            current_file="${tempfiles[$j]}"
            
            # Compter les lignes en commun avec le fichier de référence
            common_lines=$(comm -12 <(sort "$reference_file") <(sort "$current_file") | wc -l)
            
            # Si la similarité est supérieure ou égale à la similarité maximale
            if ((common_lines >= max_similarity)); then
                if ((common_lines > max_similarity)); then
                    max_similarity=$common_lines
                    similar_files=("$current_file")
                else
                    similar_files+=("$current_file")
                fi
            fi
        fi
    done
    
    # Si des fichiers similaires ont été trouvés
    if [[ ${#similar_files[@]} -gt 0 ]]; then
        # Concaténer les fichiers similaires et les enregistrer dans un fichier de sortie
        output_file="sorted_${reference_file}_${max_similarity}"
        cat "$reference_file" "${similar_files[@]}" > "./Sorted/$output_file"
        echo "Les fichiers ${similar_files[@]} ont été concaténés avec $reference_file dans $output_file."
    fi
done

# Nettoyage des fichiers temporaires
rm xx*

echo "Le processus est terminé."