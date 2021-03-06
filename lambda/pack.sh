#!/bin/bash

LAMBDA_BUCKET="s3eker-lambda-store"
ORIG_DIR="$PWD"

mkdir dist 2>/dev/null

for D in */
do
    FUNCTION_NAME="${D%%/}" # Remove slash at end of dir name. dir/ to dir
    if [ "$FUNCTION_NAME" = "dist" ] || [ "$FUNCTION_NAME" = "ingest-example" ] # Ignore some directories
    then
        continue
    fi

    TARGET_DIR="./dist/$D" # Place to put code before zipping.

    echo
    #echo -e "\e[31mPacking $D\e[0m"
    echo "Packing $D"
    
    # Install dependencies in dist/FUNCTION_NAME/
    cp -r "$D" "$TARGET_DIR"

    if [[ "$FUNCTION_NAME" == ingest-* ]];
    then
        cp uploader.py "$TARGET_DIR"
    fi

    if [ -f "$FUNCTION_NAME/requirements.txt" ]; then
        pip3 install -r "$FUNCTION_NAME/requirements.txt" --target "$TARGET_DIR"
    fi
    
    cd "$TARGET_DIR"
    
    DIST_DIR=".."
    ZIP_FILENAME="$FUNCTION_NAME.zip"
    ZIP_FILE="$DIST_DIR/$ZIP_FILENAME"
    
    if zip -r "$ZIP_FILE"  *; then
        echo "Successfully zipped $FUNCTION_NAME"
        aws s3 cp "$ZIP_FILE" "s3://$LAMBDA_BUCKET/$FUNCTION_NAME/$ZIP_FILENAME"

        # Update Lambda function with new code.
        aws lambda update-function-code --function-name "s3eker-$FUNCTION_NAME" --s3-bucket $LAMBDA_BUCKET --s3-key "$FUNCTION_NAME/$ZIP_FILENAME" > /dev/null
    fi    
    
    cd $ORIG_DIR
    rm -r $TARGET_DIR

done