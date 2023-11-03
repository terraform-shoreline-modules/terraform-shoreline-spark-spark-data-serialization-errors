

#!/bin/bash



# Get the path to the data source from the user

data_path=${DATA_FILE_PATH}



# Check the encoding of the data source

encoding=$(file -i $data_path | awk -F "=" '{print $2}')



if [[ $encoding != "utf-8" ]]; then

    # If the encoding is not utf-8, convert the data source to utf-8

    iconv -f $encoding -t utf-8 $data_path -o $data_path.utf8

    mv $data_path $data_path.bak

    mv $data_path.utf8 $data_path

fi



# Check the format of the data source

format=$(file $data_path | awk '{print $2}')



if [[ $format != "ASCII" ]]; then

    # If the format is not ASCII, convert the data source to ASCII

    iconv -f utf-8 -t ASCII//TRANSLIT $data_path -o $data_path.ascii

    mv $data_path $data_path.bak

    mv $data_path.ascii $data_path

fi



# Exit with success status

exit 0