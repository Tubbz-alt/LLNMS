#!/bin/sh
#
#   File:    llnms-print-scanner-info.sh
#   Author:  Marvin Smith
#   Date:    12/26/2013
#
#   Purpose:  Print information about an LLNMS Scanner.
#


#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "`basename $0` [options] -f <scanner-file>"
    echo ''
    echo '    Options:'
    echo '        -h, --help         :  Print usage instructions'
    echo '        -v, --version      :  Print version information'
    echo '        -f, --file [*.llnms-scanner.xml file] :  Set the LLNMS Scanner File to read.'
    echo ''
    echo '    Printing Options (Select one or more of the following)'
    echo '        -a, --all            :  Print everything (Default)'
    echo '        -i, --id             :  Print scanner id'
    echo '        -n, --name           :  Print scanner name'
    echo '        -d, --description    :  Print scanner description.'
    echo '        -c, --command        :  Print scanner command.'
    echo '        -b, --base-path      :  Print scanner base path.'
    echo '        -num, --number-args  :  Print the number of arguments.'
    echo '        -arg-name, --argument-name [arg #] : Print the specified argument name.'
    echo '        -arg-type, --argument-type [arg #] : Print the specified argument type.'
    echo '        -arg-val, --argument-value [arg #] : Print the specified argument value.'
    echo '        -arg-def, --argument-default [arg #] : Print the specified argument default value.'
    echo ''

}


#-------------------------------------#
#-         Warning Function          -#
#-                                   -#
#-   $1 -  Error Message             -#
#-   $2 -  Line Number (Optional).   -#
#-   $3 -  File Name (Optional).     -$
#-------------------------------------#
warning(){

    #  If the user only gives the warning message
    if [ $# -eq 1 ]; then
        echo "warning: $1."

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "warning: $1.  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "warning: $1.  Line: $2, File: $3"
    fi
}

#-------------------------------------#
#-            Error Function         -#
#-                                   -#
#-   $1 -  Error Message             -#
#-   $2 -  Line Number (Optional).   -#
#-   $3 -  File Name (Optional).     -$
#-------------------------------------#
error(){

    #  If the user only gives the error message
    if [ $# -eq 1 ]; then
        echo "error: $1."

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "error: $1.  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "error: $1.  Line: $2, File: $3"
    fi
}


#-------------------------------------#
#           Version Function          #
#-------------------------------------#
version(){

    echo "`basename $0` Information"
    echo ''
    echo "   LLNMS Version ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}


#---------------------------------#
#-         Main Function         -#
#---------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info.sh

#  Import the configuration info
. $LLNMS_HOME/config/llnms-config.sh

#  Important flags
FILE_FLAG=0
FILE_VALUE=''

PRINT_EVERYTHING=1
PRINT_ID=0
PRINT_NAME=0
PRINT_DESCRIPTION=0
PRINT_COMMAND=0
PRINT_BASEPATH=0
PRINT_NUMARGS=0

PRINT_ARGUMENT_NAME=0
PRINT_ARGUMENT_TYPE=0
PRINT_ARGUMENT_VALUE=0
PRINT_ARGUMENT_DEFAULT=0

ARGUMENT_NAME_FLAG=0
ARGUMENT_TYPE_FLAG=0
ARGUMENT_VALUE_FLAG=0
ARGUMENT_DEFAULT_FLAG=0

ARGUMENT_NAME_DATA=''
ARGUMENT_TYPE_DATA=''
ARGUMENT_VALUE_DATA=''
ARGUMENT_DEFAULT_DATA=''

#   Parse Command-Line Options
for OPTION in "$@"; do

    case $OPTION in

        #  Print usage instructions
        '-h' | '--help' )
            usage
            exit 1
            ;;


        #  Print version information
        '-v' | '--version' )
            version
            exit 1
            ;;

        #  Set File Flag
        '-f' | '--file' )
            FILE_FLAG=1
            ;;

        #  Print everything
        '-a' | '--all' )
            PRINT_EVERYTHING=1
            ;;

        #  Print id
        '-i' | '--id' )
            PRINT_EVERYTHING=0
            PRINT_ID=1
            ;;

        #  Print name
        '-n' | '--name' )
            PRINT_EVERYTHING=0
            PRINT_NAME=1
            ;;

        #  Print description
        '-d' | '--description' )
            PRINT_EVERYTHING=0
            PRINT_DESCRIPTION=1
            ;;

        #  Print command
        '-c' | '--command' )
            PRINT_EVERYTHING=0
            PRINT_COMMAND=1
            ;;

        #  Print scanner base path
        '-b' | '--base-path' )
            PRINT_EVERYTHING=0
            PRINT_BASEPATH=1
            ;;

        #  Print the number of arguments
        '-num' | '--number-args' )
            PRINT_EVERYTHING=0
            PRINT_NUMARGS=1
            ;;

        #  Print argument name
        '-arg-name' | '--argument-name' )
            PRINT_ARGUMENT_NAME=1
            PRINT_EVERYTHING=0
            ARGUMENT_NAME_FLAG=1
            ;;

        #  Print argument type
        '-arg-type' | '--argument-type' )
            PRINT_ARGUMENT_TYPE=1
            PRINT_EVERYTHING=0
            ARGUMENT_TYPE_FLAG=1
            ;;

        #  Print argument value
        '-arg-val' | '--argument-value' )    
            PRINT_ARGUMENT_VALUE=1
            PRINT_EVERYTHING=0
            ARGUMENT_VALUE_FLAG=1
            ;;

        #  Print argument default
        '-arg-def' | '--argument-default' )    
            PRINT_ARGUMENT_DEFAULT=1
            PRINT_EVERYTHING=0
            ARGUMENT_DEFAULT_FLAG=1
            ;;

        #  Process flag values or print error message
        *)
            
            #  If file flag set, then grab the filename
            if [ "$FILE_FLAG" = '1' ]; then
                FILE_FLAG=0
                FILE_VALUE=$OPTION

            #  If argument flag set, then grab the value
            elif [ "$ARGUMENT_NAME_FLAG" = '1' ]; then
                ARGUMENT_NAME_FLAG=0
                ARGUMENT_NAME_DATA=$OPTION

            elif [ "$ARGUMENT_TYPE_FLAG" = '1' ]; then
                ARGUMENT_TYPE_FLAG=0
                ARGUMENT_TYPE_DATA=$OPTION

            elif [ "$ARGUMENT_VALUE_FLAG" = '1' ]; then
                ARGUMENT_VALUE_FLAG=0
                ARGUMENT_VALUE_DATA=$OPTION
            
            elif [ "$ARGUMENT_DEFAULT_FLAG" = '1' ]; then
                ARGUMENT_DEFAULT_FLAG=0
                ARGUMENT_DEFAULT_DATA=$OPTION
                
                
            #  Otherwise, throw an error for an unknown option
            else
                error "Unknown option $OPTION" "$LINENO"
                usage
                exit 1
            fi
            ;;


    esac
done


#-----------------------------------------------#
#-      Make sure the filename has been set    -#
#-----------------------------------------------#
if [ "$FILE_VALUE" = "" ]; then
    error "No filename set.  Use the -f flag." "$LINENO"
    usage
    exit 1
fi

#--------------------------------------#
#-      Make sure the file exists     -#
#--------------------------------------#
if [ ! -e "$FILE_VALUE" ]; then
    error "$FILE_VALUE does not exist." "$LINENO"
    usage
    exit 1
fi

#----------------------------------------------------------------#
#-      Make sure the scanner file has the proper extension.    -#
#----------------------------------------------------------------#
if [ "`echo $FILE_VALUE | sed -n '/.*\.llnms-scanner\.xml/ p'`" = '' ]; then
    warning "File ($FILE_VALUE) does not have the proper .llnms-scanner.xml extension." "$LINENO" "`basename $0`"
fi


#------------------------------------------------#
#-   Start printing the required information    -#
#------------------------------------------------#
DATA_PRINTED=0

#  Print id
if [ "$PRINT_ID" = '1' -o "$PRINT_EVERYTHING" = '1' ]; then
    printf "`xmlstarlet sel -t -m '//llnms-scanner' -v 'id' -n $FILE_VALUE`"
    DATA_PRINTED=1
fi

#  Print name
if [ "$PRINT_NAME" = '1' -o "$PRINT_EVERYTHING" = '1' ]; then
    if [ "$DATA_PRINTED" = '1' ]; then
        printf ", "
    fi
    printf "`xmlstarlet sel -t -m '//llnms-scanner' -v 'name' -n $FILE_VALUE`"
    DATA_PRINTED=1
fi

#  Print description
if [ "$PRINT_DESCRIPTION" = '1' -o "$PRINT_EVERYTHING" = '1' ]; then
    if [ "$DATA_PRINTED" = '1' ]; then
        printf ", "
    fi
    printf "`xmlstarlet sel -t -m '//llnms-scanner' -v 'description' -n $FILE_VALUE`"
    DATA_PRINTED=1
fi

#  Print Command
if [ "$PRINT_COMMAND" = '1' -o "$PRINT_EVERYTHING" = '1' ]; then
    if [ "$DATA_PRINTED" = '1' ]; then
        printf ", "
    fi
    printf "`xmlstarlet sel -t -m '//llnms-scanner/configuration/linux' -v 'command' -n $FILE_VALUE`"
    DATA_PRINTED=1
fi

#  Print Command base path
if [ "$PRINT_BASEPATH" = '1' -o "$PRINT_EVERYTHING" = '1' ]; then
    if [ "$DATA_PRINTED" = '1' ]; then
        printf ", "
    fi
    printf "`xmlstarlet sel -t -m '//llnms-scanner/configuration/linux' -v 'base-path' -n $FILE_VALUE`"
    DATA_PRINTED=1
fi

#  Print the number of arguments
if [ "$PRINT_NUMARGS" = '1' -o "$PRINT_EVERYTHING" = '1' ]; then
    if [ "$DATA_PRINTED" = '1' ]; then
        printf ", "
    fi
    printf "`xmlstarlet sel -t -m '//llnms-scanner/configuration/linux' -v 'number-arguments' -n $FILE_VALUE`"
    DATA_PRINTED=1
fi

#  Print the specified argument
if [ "$PRINT_ARGUMENT_NAME" = '1' ]; then
    $ECHO "`xmlstarlet sel -t -m "//llnms-scanner/configuration/linux/argument[@id=${ARGUMENT_NAME_DATA}]" -v '@name' $FILE_VALUE`"
    exit 0
fi

if [ "$PRINT_ARGUMENT_TYPE" = '1' ]; then
    $ECHO "`xmlstarlet sel -t -m "//llnms-scanner/configuration/linux/argument[@id=${ARGUMENT_TYPE_DATA}]" -v '@type' $FILE_VALUE`"
    exit 0
fi

if [ "$PRINT_ARGUMENT_VALUE" = '1' ]; then
    $ECHO "`xmlstarlet sel -t -m "//llnms-scanner/configuration/linux/argument[@id=${ARGUMENT_VALUE_DATA}]" -v '@value' $FILE_VALUE`"
    exit 0
fi

if [ "$PRINT_ARGUMENT_DEFAULT" = '1' ]; then
    $ECHO "`xmlstarlet sel -t -m "//llnms-scanner/configuration/linux/argument[@id=${ARGUMENT_DEFAULT_DATA}]" -v '@default' $FILE_VALUE`"
    exit 0
fi


#  print final newline
echo ''

