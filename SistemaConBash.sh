#!/bin/bash
ArticulateExport=content
CustomSourceFileDir=custom
SourceCustomLib=AccessibleITA_LGT.js
#Questa funzione sostituisce tutte le ooccorrenze di una stringa in tutti i file presenti in un percorso
#Argomento 1 =stringa da cercare
#Argomento 2 =stringa da sostituire
#Argomento 3 =cartella di destinazione
function replaceString(){
    STRINGA=$1
    NEWSTR=$2
    DESTPATH=$3
    for f in $(grep -rl $STRINGA ${DESTPATH}); do
        echo $f
        sed -i .origin "s/$STRINGA/${NEWSTR}/g" $f
        rm ${f}.origin
    done
}
#trovo file che contengono la stringa e in ogni occorrenza sostituisco
stringa="n.iso639Code"
destpath=${ArticulateExport}/lib
newstr=\"it\"
replaceString $stringa $newstr $destpath 

stringa="\"en\""
destpath=${ArticulateExport}
newstr=\"it\"
replaceString $stringa $newstr $destpath

#install libreria in lib
cp ${CustomSourceFileDir}/${SourceCustomLib} ${ArticulateExport}/lib/

#Aggiungo file nelle dipendenze
IndexFilePath=${ArticulateExport}/index.html
#Se è già presente nel file index non faccio nulla
grep ${SourceCustomLib} ${IndexFilePath}
if [ $? -eq 1 ]; then
    line=$(grep -n "/body" ${IndexFilePath} | cut -d ":" -f1 )
    newLine="<script type=\"text/javascript\" src=\"lib/${SourceCustomLib}\"></script>"

    awk -v n=$line -v s="$newLine" 'NR == n {print s} {print}' ${IndexFilePath} > ${IndexFilePath}.new
    rm ${IndexFilePath}
    mv ${IndexFilePath}.new ${IndexFilePath}
fi

