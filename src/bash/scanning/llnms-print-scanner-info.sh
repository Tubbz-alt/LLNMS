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
    #echo '        -arg, --argument [arg #] : Print the specified argument.'
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
        
        #  Process flag values or print error message
        *)
            
            #  If file flag set, then grab the filename
            if [ "$FILE_FLAG" = '1' ]; then
                FILE_FLAG=0
                FILE_VALUE=$OPTION

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
    $ECHO "`xmlstarlet sel -t -m '//llnms-scanner' -v 'id' -n $FILE_VALUE`\c"
    DATA_PRINTED=1
fi

#  Print name
if [ "$PRINT_NAME" = '1' -o "$PRINT_EVERYTHING" = '1' ]; then
    if [ "$DATA_PRINTED" = '1' ]; then
        echo ", \c"
    fi
    $ECHO "`xmlstarlet sel -t -m '//llnms-scanner' -v 'name' -n $FILE_VALUE`\c"
    DATA_PRINTED=1
fi

#  Print description
if [ "$PRINT_DESCRIPTION" = '1' -o "$PRINT_EVERYTHING" = '1' ]; then
    if [ "$DATA_PRINTED" = '1' ]; then
        echo ", \c"
    fi
    $ECHO "`xmlstarlet sel -t -m '//llnms-scanner' -v 'description' -n $FILE_VALUE`\c"
    DATA_PRINTED=1
fi

#  Print Command
if [ "$PRINT_COMMAND" = '1' -o "$PRINT_EVERYTHING" = '1' ]; then
    if [ "$DATA_PRINTED" = '1' ]; then
        echo ", \c"
    fi
    $ECHO "`xmlstarlet sel -t -m '//llnms-scanner/configuration/linux' -v 'command' -n $FILE_VALUE`\c"
    DATA_PRINTED=1
fi

#  Print Command base path
if [ "$PRINT_BASEPATH" = '1' -o "$PRINT_EVERYTHING" = '1' ]; then
    if [ "$DATA_PRINTED" = '1' ]; then
        echo ", \c"
    fi
    $ECHO "`xmlstarlet sel -t -m '//llnms-scanner/configuration/linux' -v 'base-path' -n $FILE_VALUE`\c"
    DATA_PRINTED=1
fi

#  Print the number of arguments
if [ "$PRINT_NUMARGS" = '1' -o "$PRINT_EVERYTHING" = '1' ]; then
    if [ "$DATA_PRINTED" = '1' ]; then
        echo ", \c"
    fi
    $ECHO "`xmlstarlet sel -t -m '//llnms-scanner/configuration/linux' -v 'number-arguments' -n $FILE_VALUE`\c"
    DATA_PRINTED=1
fi


#  print final newline
echo ''

