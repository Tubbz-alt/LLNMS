#!/bin/bash


#  This script handles incrementing the version file


usage(){

    echo "$0 [options]"
    echo ''
    echo '    options:'
    echo '       -h | --help     : Print usage instructions'
    echo '       -v | --version  : Print current LLNMS Version'
    echo '       -i [major|minor|subminor = default] : Increment major, minor, or subminor id'
    echo '       -d [major|minor|subminor = default] : Decrement major, minor, or subminor id'

}


print_version(){
    

    echo "LLNMS Version: ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}


source src/bash/llnms-info.sh

SET_INCREMENT=0
SET_DECREMENT=0

for OPTION in $@; do

    case $OPTION in 

        "-h" | '--help' )
            usage
            exit 1
            ;;

        '-v' | '--version' )
            print_version
            exit 0
            ;;

        '-i' )
            SET_INCREMENT=1
            ;;

        '-d' )
            SET_DECREMENT=1
            ;;
         *)

            if [ "$SET_INCREMENT" == "1" ]; then
                
                if [ "$OPTION" == "major" ]; then
                    NEW_MAJOR=`expr $LLNMS_MAJOR + 1`
                    sed -i  "s/^ *LLNMS_MAJOR=$LLNMS_MAJOR$/LLNMS_MAJOR=${NEW_MAJOR}/g" 'src/bash/llnms-info.sh'
                elif [ "$OPTION" == "minor" ]; then
                    NEW_MINOR=`expr $LLNMS_MINOR + 1`
                    sed -i  "s/^ *LLNMS_MINOR=$LLNMS_MINOR$/LLNMS_MINOR=${NEW_MINOR}/g" 'src/bash/llnms-info.sh'
                
                elif [ "$OPTION" == "subminor" ]; then
                    NEW_SUBMINOR=`expr $LLNMS_SUBMINOR + 1`
                    sed -i  "s/^ *LLNMS_SUBMINOR=$LLNMS_SUBMINOR$/LLNMS_SUBMINOR=${NEW_SUBMINOR}/g" 'src/bash/llnms-info.sh'
                
                else
                    echo "error: $OPTION is not one of the accepted items to increment [major,minor,subminor]"
                    exit 1
                fi


            elif [ "$SET_DECREMENT" == "1" ]; then
                
                if [ "$OPTION" == "major" ]; then
                    NEW_MAJOR=`expr $LLNMS_MAJOR - 1`
                    sed -i  "s/^ *LLNMS_MAJOR=$LLNMS_MAJOR$/LLNMS_MAJOR=${NEW_MAJOR}/g" 'src/bash/llnms-info.sh'
                elif [ "$OPTION" == "minor" ]; then
                    NEW_MINOR=`expr $LLNMS_MINOR - 1`
                    sed -i  "s/^ *LLNMS_MINOR=$LLNMS_MINOR$/LLNMS_MINOR=${NEW_MINOR}/g" 'src/bash/llnms-info.sh'
                
                elif [ "$OPTION" == "subminor" ]; then
                    NEW_SUBMINOR=`expr $LLNMS_SUBMINOR - 1`
                    sed -i  "s/^ *LLNMS_SUBMINOR=$LLNMS_SUBMINOR$/LLNMS_SUBMINOR=${NEW_SUBMINOR}/g" 'src/bash/llnms-info.sh'
                
                else
                    echo "error: $OPTION is not one of the accepted items to increment [major,minor,subminor]"
                    exit 1
                fi


            else
                echo "error: Unknown option $OPTION"
                exit 1
                
            fi
            ;;
    
    esac
done

