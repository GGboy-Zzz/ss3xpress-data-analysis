
for file in S*/S*_R1.fq.gz S*/S*_R2.fq.gz; 
do
    if [[ $file == *_R1* ]]; then
        new_file="${file/_R1/_R1_001}"
    elif [[ $file == *_R2* ]]; then
        new_file="${file/_R2/_R2_001}"
    fi
    mv "$file" "$new_file"
done