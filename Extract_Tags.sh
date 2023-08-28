xml_directory="/home/wayden/lsx/"

# Fichier de sortie
output_file="Tags.txt"

# Initialisation du fichier de sortie
> "$output_file"

# Boucle pour traiter chaque fichier XML
if [ -e "$output_file" ]; then
    rm "$output_file"
fi

# Boucle pour traiter chaque fichier XML
for xml_file in "$xml_directory"/*.lsx; do
    # Extraire les lignes pertinentes et les reformater
    grep -E '<attribute (id="Description"|id="Name"|id="UUID") .* value="[^"]+"' "$xml_file" | \
    sed -E 's/.* id="([A-Za-z]+)" .* value="([^"]+)".*/\1 value="\2"/' >> "$output_file"
    echo >> "$output_file"  # Ajout d'un retour à la ligne après chaque fichier
done
echo "Extraction terminée. Résultats enregistrés dans $output_file"