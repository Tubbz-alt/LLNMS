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
    echo '       -t [text]  :  Assign description to configuration file'

}


print_version(){
    

    echo "LLNMS Version: ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}


source src/bash/llnms-info.sh

SET_INCREMENT=0
SET_DECREMENT=0
SET_TEXT=0
VERSION_TEXT=''


for OPTION in "$@"; do

    case $OPTION in 
        
        #  Print Help
        "-h" | '--help' )
            usage
            exit 1
            ;;

        #  Print version info
        '-v' | '--version' )
            print_version
            exit 0
            ;;

        #  Set increment flag
        '-i' )
            SET_INCREMENT=1
            ;;

        #  Set decrement flag
        '-d' )
            SET_DECREMENT=1
            ;;

        #  Set text flag
        '-t' )
            SET_TEXT=1
            ;;

        #  Pull values or throw an error
        *)

            #  If the user wants to increment, apply action
            if [ "$SET_INCREMENT" = "1" ]; then
                
                SET_INCREMENT=0

                #  Increment the major version
                if [ "$OPTION" = "major" ]; then
                    NEW_MAJOR=`expr ${LLNMS_MAJOR} + 1`
                    sed -ie  "s/^ *LLNMS_MAJOR=${LLNMS_MAJOR}$/LLNMS_MAJOR=${NEW_MAJOR}/g" 'src/bash/llnms-info.sh'
                    LLNMS_MAJOR=${NEW_MAJOR}
                
                #  Increment the minor version
                elif [ "$OPTION" = "minor" ]; then
                    NEW_MINOR=`expr $LLNMS_MINOR + 1`
                    sed -ie  "s/^ *LLNMS_MINOR=$LLNMS_MINOR$/LLNMS_MINOR=${NEW_MINOR}/g" 'src/bash/llnms-info.sh'
                    LLNMS_MINOR=$NEW_MINOR
                
                #  Increment the subminor version
                elif [ "$OPTION" = "subminor" ]; then
                    NEW_SUBMINOR=`expr $LLNMS_SUBMINOR + 1`
                    sed -ie  "s/^ *LLNMS_SUBMINOR=$LLNMS_SUBMINOR$/LLNMS_SUBMINOR=${NEW_SUBMINOR}/g" 'src/bash/llnms-info.sh'
                    LLNMS_SUBMINOR=$NEW_SUBMINOR
                
                #  Otherwise the option specified was in error and cannot be incremented
                else
                    echo "error: $OPTION is not one of the accepted items to increment [major,minor,subminor]"
                    exit 1
                fi

            
            #  If the user wants to decrement, apply action
            elif [ "$SET_DECREMENT" = "1" ]; then
                
                SET_DECREMENT=0

                #  Decrement the major version
                if [ "$OPTION" = "major" ]; then
                    NEW_MAJOR=`expr $LLNMS_MAJOR - 1`
                    sed -ie  "s/^ *LLNMS_MAJOR=$LLNMS_MAJOR$/LLNMS_MAJOR=${NEW_MAJOR}/g" 'src/bash/llnms-info.sh'
                    LLNMS_MAJOR=$NEW_MAJOR
                
                #  Decrement the minor version
                elif [ "$OPTION" = "minor" ]; then
                    NEW_MINOR=`expr $LLNMS_MINOR - 1`
                    sed -ie  "s/^ *LLNMS_MINOR=$LLNMS_MINOR$/LLNMS_MINOR=${NEW_MINOR}/g" 'src/bash/llnms-info.sh'
                    LLNMS_MINOR=$NEW_MINOR
                
                #  Decrement the subminor version
                elif [ "$OPTION" = "subminor" ]; then
                    NEW_SUBMINOR=`expr $LLNMS_SUBMINOR - 1`
                    sed -ie  "s/^ *LLNMS_SUBMINOR=$LLNMS_SUBMINOR$/LLNMS_SUBMINOR=${NEW_SUBMINOR}/g" 'src/bash/llnms-info.sh'
                    LLNMS_SUBMINOR=$NEW_SUBMINOR
                
                #  Otherwise the option specified was in error and cannot be decremented
                else
                    echo "error: $OPTION is not one of the accepted items to increment [major,minor,subminor]"
                    exit 1
                fi

            #  if set text flag is true, then grab it
            elif [ $SET_TEXT -eq 1 ]; then
                
                #  add it to the end of the file
                echo "# ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR} - $OPTION" >> 'src/bash/llnms-info.sh'
                SET_TEXT=0

            else
                echo "error: Unknown option $OPTION"
                exit 1
                
            fi
            ;;
    
    esac
done

