-------------------------------------------------------------------------------
--           P O L Y H E D R A    D E M O
--           Copyright (C) 2005-2014 Enea Software AB
-------------------------------------------------------------------------------
-- 	Filename      : inspect.cl
-- 	Description   : produce SQL to recreate the structure of a database,
--                  and also an HTML file describing the database


-- 	Author        : Nigel Day
--
--	CVSID         : $Id: inspector.cl,v 1.6 2014/07/23 20:22:38 nigel Exp $
-------------------------------------------------------------------------------
-- NOTE: this is ILLUSTRATIVE CODE, provided on an 'as is' basis to help
-- demonstrate one or more features of the Polyhedra product. 
-- It may well need adaption for use in a live installation, and
-- Enea Software AB and its agents and distributors do not warrant this code.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- first, set up constants that can be tuned or redefined via resource settings
-------------------------------------------------------------------------------

-- parameters that control what the application does, starting with those that
-- decide which of the major functions of the application shall be performed.

constant boolean dump_schema   = GetBoolDefault ('dump_schema',   true )
constant boolean check_names   = GetBoolDefault ('check_names',   false)
constant boolean create_html   = GetBoolDefault ('create_html',   true )

-- when reporting info about clashes with reserved words, should we also check
-- for the use of non-reserved words?

constant boolean check_nonreserved_words = GetBoolDefault ('check_nonreserved_words', false)

-- should we report information about table sizes?

constant boolean report_record_count = GetBoolDefault ('report_record_count',   true)

-- should the HTML table detail tables be a single table?

constant boolean single_table_for_table_details = GetBoolDefault ('single_table_for_table_details',   true)

-- 'stub' is used as a prefix to the names of generated files.
                
constant string stub           = GetDefault ('stub', 'db_')

-- users can supply a space-separated list of names to check, to enable an early
-- indication of potential problems when upgrading to a new version of Polyhedra, say.

constant string extra_reserved_words = \
                     lowercase (' ' & GetDefault ('extra_reserved_words', '-') & ' ')

-- users can also supply a space-separated list of names that are to circumvent the name-checking. 
-- this can be useful if a particular word - "value", say - occurs many times in a schema but you
-- are not worried that it is a reserved word in a new version of the standard (in this case, 
-- SQL 2003).

constant string permitted_words = \
                     lowercase (' ' & GetDefault ('permitted_words', '-') & ' ')


-- parameters that control how the application does what it does; they should not
-- affect the output, merely things such as the performance, the load on the server,
-- and the space used.

constant integer parallelops   = GetIntDefault  ('parallelops',   1000 )
constant boolean globalfetch   = GetBoolDefault ('globalfetch',   false)

-------------------------------------------------------------------------------
-- define some constants controlling the appearance of the HTML we generate;
-- values here can be changed without breaking the application, or we could make
-- them settable/tunable via resources.
-------------------------------------------------------------------------------

constant string html_system_tables_colour  = 'bgcolor="gray"'
constant string html_special_tables_colour = 'bgcolor="silver"'
constant string html_skipped_tables_colour = 'bgcolor="#B0C4DE"'  -- lightsteelblue
constant string html_general_colour        = 'bgcolor="#ADD8E6"'  -- lightblue
constant string html_border_colour         = 'bgcolor="#B0C4DE"'  -- lightsteelblue
constant string standard_table             = '<table cellspacing="2" cellpadding="3" bgcolor="white" width="100%">\n'
constant string bordered_table             = '<table cellspacing="2" cellpadding="3"' && html_border_colour & '>\n'

-------------------------------------------------------------------------------
-- reserved words for CL, SQL, C and C++, used when checking names (of tables
-- and columns) for validity and for protential problems (now or in the future)
-------------------------------------------------------------------------------

constant string Polyhedra_SQL_keywords = \
          lowercase ('' && \
                     'ADD ALL ALTER AND ANY ARRAY AS ASC AUTHORIZATION AVG' && \
                     'BEGIN BETWEEN BINARY BUT BY CASCADE CHANGE CHAR' && \
                     'CHARACTER CHECK CL CLOSE COBOL COMMIT COMPUTED COMPUTING' && \
                     'CONTINUE CORRESPONDING COUNT CREATE CUR DEC' && \
                     'DECIMAL DECLARE DEFAULT DELETE DERIVED DESC DISTINCT' && \
                     'DISTINCT DOUBLE DROP END ESCAPE EVERY EXEC EXECUTE' && \
                     'EXISTS FALSE FETCH FLOAT FOR FOREIGN FORTRAN FOUND FROM' && \
                     'GO GOTO GRANT GROUP HAVING HIDDEN IN INDEX INDICATOR' && \
                     'INSERT INT INTEGER INTO IS KEY LANGUAGE' && \
                     'LIKE LOAD LOCAL LOGGED LOGGING MAX MIN MODIFY MODULE NOT' && \
                     'NULL NUMERIC OBJECT OF OLD ON OPEN OPTION OR ORDER' && \
                     'ORDERED PASCAL PERSISTENT PLI PRECISION PRIMARY' && \
                     'PRIVILEGES PROCEDURE PUBLIC PURGING REAL REFERENCES' && \
                     'RESTRICT REVOKE ROLLBACK SAVE SCHEMA SECTION' && \
                     'SELECT SEND SET SHARED SHUTDOWN SMALLINT SOME SQL SQLCODE' && \
                     'SQLERROR SUM TABLE TO TRANSIENT TRUE UNION UNIQUE' && \
                     'UPDATE USER VALUES VARCHAR VARYING VIEW VIRTUAL WHENEVER' && \
                     'WHERE WITH WORK ')

constant string Polyhedra50_SQL_keywords = lowercase (' CALL RENAME ')

constant string Polyhedra63_SQL_keywords = lowercase (' EXCEPT INTERSECT UNKNOWN ')

constant string Polyhedra70_SQL_keywords = lowercase (' LARGE ')
         
constant string Polyhedra83_SQL_keywords = lowercase (' LIMIT OFFSET ')
         
constant string Polyhedra86_SQL_keywords = lowercase (' INTEGER64 ')
         
constant string Polyhedra87_SQL_keywords = lowercase (' CONDITION LOCK OPTIMISTIC PESSIMISTIC WITHOUT ')

constant string Polyhedra89_SQL_keywords = lowercase (' CROSS FULL IF INNER JOIN LEFT NATURAL OUTER RIGHT USING ')
            
constant string CL_keywords = '' && \
                     'abort add and array as assert at beep by case catch char' && \
                     'child class commit component constant create debug' && \
                     'default delay delete displayed div divide do else emit' && \
                     'end error exists exit export false fill for foreach' && \
                     'forever forget from function get global go if in insert' && \
                     'into is item library line link local locate me mod' && \
                     'multiply new next not null object of on or private public' && \
                     'pure quit reference remove repeat return rollback root' && \
                     'schema script send set shared sleep sql start step stop' && \
                     'subtract switch target threadpriority then throw to' && \
                     'transaction true try unlink until update uses while with word '

constant string SQL_2003_reserved_words = \
          lowercase ('' && \
                     'ABS ALL ALLOCATE ALTER AND ANY ARE ARRAY AS ASENSITIVE' && \
                     'ASYMMETRIC AT ATOMIC AUTHORIZATION AVG BEGIN BETWEEN' && \
                     'BIGINT BINARY BLOB BOOLEAN BOTH BY CALL CALLED' && \
                     'CARDINALITY CASCADED CASE CAST CEIL CEILING CHAR' && \
                     'CHAR_LENGTH CHARACTER CHARACTER_LENGTH CHECK CLOB CLOSE' && \
                     'COALESCE COLLATE COLLECT COLUMN COMMIT CONDITION CONNECT' && \
                     'CONSTRAINT CONVERT CORR CORRESPONDING COUNT COVAR_POP' && \
                     'COVAR_SAMP CREATE CROSS CUBE CUME_DIST CURRENT' && \
                     'CURRENT_DATE CURRENT_DEFAULT_TRANSFORM_GROUP' && \
                     'CURRENT_PATH CURRENT_ROLE CURRENT_TIME CURRENT_TIMESTAMP' && \
                     'CURRENT_TRANSFORM_GROUP_FOR_TYPE CURRENT_USER CURSOR' && \
                     'CYCLE DATE DAY DEALLOCATE DEC DECIMAL DECLARE DEFAULT DELETE' && \
                     'DENSE_RANK DEREF DESCRIBE DETERMINISTIC DISCONNECT' && \
                     'DISTINCT DOUBLE DROP DYNAMIC EACH ELEMENT ELSE END' && \
                     'END-EXEC ESCAPE EVERY EXCEPT EXEC EXECUTE EXISTS EXP' && \
                     'EXTERNAL EXTRACT FALSE FETCH FILTER FLOAT FLOOR FOR' && \
                     'FOREIGN FREE FROM FULL FUNCTION FUSION GET GLOBAL GRANT' && \
                     'GROUP GROUPING HAVING HOLD HOUR IDENTITY IN INDICATOR' && \
                     'INNER INOUT INSENSITIVE INSERT INT INTEGER INTERSECT' && \
                     'INTERSECTION INTERVAL INTO IS JOIN LANGUAGE LARGE LATERAL' && \
                     'LEADING LEFT LIKE LN LOCAL LOCALTIME LOCALTIMESTAMP LOWER' && \
                     'MATCH MAX MEMBER MERGE METHOD MIN MINUTE MOD MODIFIES' && \
                     'MODULE MONTH MULTISET NATIONAL NATURAL NCHAR NCLOB NEW NO' && \
                     'NONE NORMALIZE NOT NULL NULLIF NUMERIC OCTET_LENGTH OF' && \
                     'OLD ON ONLY OPEN OR ORDER OUT OUTER OVER OVERLAPS OVERLAY' && \
                     'PARAMETER PARTITION PERCENT_RANK PERCENTILE_CONT' && \
                     'PERCENTILE_DISC POSITION POWER PRECISION PREPARE PRIMARY' && \
                     'PROCEDURE RANGE RANK READS REAL RECURSIVE REF REFERENCES' && \
                     'REFERENCING REGR_AVGX REGR_AVGY REGR_COUNT REGR_INTERCEPT' && \
                     'REGR_R2 REGR_SLOPE REGR_SXX REGR_SXY REGR_SYY RELEASE' && \
                     'RESULT RETURN RETURNS REVOKE RIGHT ROLLBACK ROLLUP ROW' && \
                     'ROW_NUMBER ROWS SAVEPOINT SCOPE SCROLL SEARCH SECOND' && \
                     'SELECT SENSITIVE SESSION_USER SET SIMILAR SMALLINT SOME' && \
                     'SPECIFIC SPECIFICTYPE SQL SQLEXCEPTION SQLSTATE' && \
                     'SQLWARNING SQRT START STATIC STDDEV_POP STDDEV_SAMP' && \
                     'SUBMULTISET SUBSTRING SUM SYMMETRIC SYSTEM SYSTEM_USER' && \
                     'TABLE TABLESAMPLE THEN TIME TIMESTAMP TIMEZONE_HOUR' && \
                     'TIMEZONE_MINUTE TO TRAILING TRANSLATE TRANSLATION TREAT' && \
                     'TRIGGER TRIM TRUE UESCAPE UNION UNIQUE UNKNOWN UNNEST' && \
                     'UPDATE UPPER USER USING VALUE VALUES VAR_POP VAR_SAMP' && \
                     'VARCHAR VARYING WHEN WHENEVER WHERE WIDTH_BUCKET WINDOW' && \
                     'WITH WITHIN WITHOUT YEAR ')

constant string SQL_2003_nonreserved_words = \
          lowercase ('' && \
                     'A ABSOLUTE ACTION ADA ADD ADMIN AFTER ALWAYS ASC' && \
                     'ASSERTION ASSIGNMENT ATTRIBUTE ATTRIBUTES BEFORE' && \
                     'BERNOULLI BREADTH C CASCADE CATALOG CATALOG_NAME CHAIN' && \
                     'CHARACTER_SET_CATALOG CHARACTER_SET_NAME' && \
                     'CHARACTER_SET_SCHEMA CHARACTERISTICS CHARACTERS' && \
                     'CLASS_ORIGIN COBOL COLLATION COLLATION_CATALOG' && \
                     'COLLATION_NAME COLLATION_SCHEMA COLUMN_NAME' && \
                     'COMMAND_FUNCTION COMMAND_FUNCTION_CODE COMMITTED' && \
                     'CONDITION_NUMBER CONNECTION CONNECTION_NAME' && \
                     'CONSTRAINT_CATALOG CONSTRAINT_NAME CONSTRAINT_SCHEMA' && \
                     'CONSTRAINTS CONSTRUCTOR CONTAINS CONTINUE CURSOR_NAME' && \
                     'DATA DATETIME_INTERVAL_CODE DATETIME_INTERVAL_PRECISION' && \
                     'DEFAULTS DEFERRABLE DEFERRED DEFINED DEFINER DEGREE DEPTH' && \
                     'DERIVED DESC DESCRIPTOR DIAGNOSTICS DISPATCH DOMAIN' && \
                     'DYNAMIC_FUNCTION DYNAMIC_FUNCTION_CODE EQUALS EXCEPTION' && \
                     'EXCLUDE EXCLUDING FINAL FIRST FOLLOWING FORTRAN FOUND G' && \
                     'GENERAL GENERATED GO GOTO GRANTED HIERARCHY IMMEDIATE' && \
                     'IMPLEMENTATION INCLUDING INCREMENT INITIALLY INPUT' && \
                     'INSTANCE INSTANTIABLE INVOKER ISOLATION K KEY KEY_MEMBER' && \
                     'KEY_TYPE LAST LENGTH LEVEL LOCATOR M MAP MATCHED MAXVALUE' && \
                     'MESSAGE_LENGTH MESSAGE_OCTET_LENGTH MESSAGE_TEXT MINVALUE' && \
                     'MORE MUMPS NAME NAMES NESTING NEXT NORMALIZED NULLABLE' && \
                     'NULLS NUMBER OBJECT OCTETS OPTION OPTIONS ORDERING' && \
                     'ORDINALITY OTHERS OUTPUT OVERRIDING PAD PARAMETER_MODE' && \
                     'PARAMETER_NAME PARAMETER_ORDINAL_POSITION' && \
                     'PARAMETER_SPECIFIC_CATALOG PARAMETER_SPECIFIC_NAME' && \
                     'PARAMETER_SPECIFIC_SCHEMA PARTIAL PASCAL PATH PLACING' && \
                     'PLI PRECEDING PRESERVE PRIOR PRIVILEGES PUBLIC READ' && \
                     'RELATIVE REPEATABLE RESTART RESTRICT' && \
                     'RETURNED_CARDINALITY RETURNED_LENGTH' && \
                     'RETURNED_OCTET_LENGTH RETURNED_SQLSTATE ROLE ROUTINE' && \
                     'ROUTINE_CATALOG ROUTINE_NAME ROUTINE_SCHEMA ROW_COUNT' && \
                     'SCALE SCHEMA SCHEMA_NAME SCOPE_CATALOG SCOPE_NAME' && \
                     'SCOPE_SCHEMA SECTION SECURITY SELF SEQUENCE SERIALIZABLE' && \
                     'SERVER_NAME SESSION SETS SIMPLE SIZE SOURCE SPACE' && \
                     'SPECIFIC_NAME STATE STATEMENT STRUCTURE STYLE' && \
                     'SUBCLASS_ORIGIN TABLE_NAME TEMPORARY TIES' && \
                     'TOP_LEVEL_COUNT TRANSACTION TRANSACTION_ACTIVE' && \
                     'TRANSACTIONS_COMMITTED TRANSACTIONS_ROLLED_BACK' && \
                     'TRANSFORM TRANSFORMS TRIGGER_CATALOG TRIGGER_NAME' && \
                     'TRIGGER_SCHEMA TYPE UNBOUNDED UNCOMMITTED UNDER UNNAMED' && \
                     'USAGE USER_DEFINED_TYPE_CATALOG USER_DEFINED_TYPE_CODE' && \
                     'USER_DEFINED_TYPE_NAME USER_DEFINED_TYPE_SCHEMA VIEW' && \
                     'WORK WRITE ZONE ')

constant string odbc_reserved_words = '' && \
                     'ABSOLUTE EXEC OVERLAPS ACTION EXECUTE PAD ADA EXISTS' && \
                     'PARTIAL ADD EXTERNAL PASCAL ALL EXTRACT POSITION' && \
                     'ALLOCATE FALSE PRECISION ALTER FETCH PREPARE AND FIRST' && \
                     'PRESERVE ANY FLOAT PRIMARY ARE FOR PRIOR AS FOREIGN' && \
                     'PRIVILEGES ASC FORTRAN PROCEDURE ASSERTION FOUND PUBLIC' && \
                     'AT FROM READ AUTHORIZATION FULL REAL AVG GETREFERENCES' && \
                     'BEGIN GLOBAL RELATIVE BETWEEN GO RESTRICT BIT ' && \
                     'GOTO REVOKE BIT_LENGTH GRANT RIGHT BOTH GROUP ROLLBACK BY' && \
                     'HAVING ROWS CASCADE HOUR SCHEMA CASCADED IDENTITY SCROLL' && \
                     'CASE IMMEDIATE SECOND CAST IN SECTION CATALOG INCLUDE' && \
                     'SELECT CHAR INDEX SESSION CHAR_LENGTH INDICATOR' && \
                     'SESSION_USER CHARACTER INITIALLY SET CHARACTER_LENGTH' && \
                     'INNER SIZE CHECK INPUT SMALLINT CLOSE INSENSITIVE SOME' && \
                     'COALESCE INSERT SPACE COLLATE INT SQL COLLATION INTEGER' && \
                     'SQLCA COLUMN INTERSECT SQLCODE COMMIT INTERVAL SQLERROR' && \
                     'CONNECT INTO SQLSTATE CONNECTION IS SQLWARNING CONSTRAINT' && \
                     'ISOLATION SUBSTRING CONSTRAINTS JOIN SUM CONTINUE KEY' && \
                     'SYSTEM_USER CONVERT LANGUAGE TABLE CORRESPONDING LAST' && \
                     'TEMPORARY COUNT LEADING THEN CREATE LEFT TIME CROSS LEVEL' && \
                     'TIMESTAMP CURRENT LIKE TIMEZONE_HOUR CURRENT_DATE LOCAL' && \
                     'TIMEZONE_MINUTE CURRENT_TIME LOWER TO CURRENT_TIMESTAMP' && \
                     'MATCH TRAILING CURRENT_USER MAX TRANSACTION CURSOR MIN' && \
                     'TRANSLATE DATE MINUTE TRANSLATION DAY MODULE TRIM' && \
                     'DEALLOCATE MONTH TRUE DEC NAMES UNION DECIMAL NATIONAL' && \
                     'UNIQUE DECLARE NATURAL UNKNOWN DEFAULT NCHAR UPDATE' && \
                     'DEFERRABLE NEXT UPPER DEFERRED NO USAGE DELETE NONE USER' && \
                     'DESC NOT USING DESCRIBE NULL VALUE DESCRIPTOR NULLIF' && \
                     'VALUES DIAGNOSTICS NUMERIC VARCHAR DISCONNECT' && \
                     'OCTET_LENGTH VARYING DISTINCT OF VIEW DOMAIN ON WHEN' && \
                     'DOUBLE ONLY WHENEVER DROP OPEN WHERE ELSE OPTION WITH' && \
                     'END OR WORK END-EXEC ORDER WRITE ESCAPE OUTER YEAR EXCEPT' && \
                     'OUTPUT ZONE EXCEPTION '

constant string c_reserved_words = '' && \
                     'asm auto break case char const continue default do' &&\
                     'double else enum extern float for goto if int long' &&\
                     'register return short signed sizeof static struct' &&\
                     'switch typedef union unsigned void volatile while '
                     
constant string cplusplus_reserved_words = \
                    ' catch class delete except finally friend inline new' &&\
                     'operator protected public template this throw try virtual '

-------------------------------------------------------------------------------
-- names of special tables in a Polyhedra database
-- Note: there are some additional tables (such as dataconnection) that have
--       special meaning if present (and with the right structure). At present
--       these are not included in all_special_tables 
-------------------------------------------------------------------------------

constant string schematables   = 'tables,views,attributes,indexes,indexattrs,'
constant string basetables     = 'journalcontrol,dbcontrol,sqlprocedure,'
constant string logtables      = 'logcontrol,logcolumn,logdata,logextract,logarchive,' & \
                                 'loghistory,logaccess,logobject,logworker,'
constant string cltables       = 'clcontrol,exception,runtimeexception,udpmsg,udpport,' & \
                                 'tcpserver,tcpconnection,exceptionhandler,timer,' & \
                                 'dataport,dataservice,'
constant string securitytables = 'users,table_privileges,column_privileges,'

-- (jcpcontrol is used by the FT mechanisms, but not by the rtrdb in which it resides!
--  hence it is an application table, not a special one.)

constant string all_special_tables  = schematables & basetables & logtables & cltables & securitytables & 'dvi_*'

constant string default_tables_to_skip = all_special_tables

-------------------------------------------------------------------------------
-- some constants that help simplify the CL code
-------------------------------------------------------------------------------

constant String TenZeros                   = "0000000000"
constant String FiftyZeros                 = TenZeros & TenZeros & TenZeros & \
                                             TenZeros & TenZeros
constant string thirty_spaces              = '                              '
constant string thirty_dashes              = '------------------------------'

constant datetime compiletime              = days (999)
constant string sqlbuffsize                = uppercase (stub & 'sqlbuffersize')

-------------------------------------------------------------------------------
-- general-purpose global functions
-------------------------------------------------------------------------------

---------------------------------------------------------------
function string ZeroRightJustify (string value, integer places)
---------------------------------------------------------------
-- return either the LAST <places> chars of value, or 
-- pad it with zeros at the FRONT to be <places> long.
---------------------------------------------------------------
        local integer len = numberofchars (value)
        
        if places <= len then 
                return value
        else
                return (char 1 to (places-len) of FiftyZeros) & value
        end if
--------------------
end ZeroRightJustify
--------------------

---------------------------------------------------------
function string RealToString (real value, integer places)
---------------------------------------------------------
    local boolean negative = (value < 0)
    local real    frac
    local integer int
    local string  rounded

    if places = 0 then 
        return round (value)
    else if places < 0 then
        if value < 0 then
            return "-" & ZeroRightJustify (round (-value), (-places)-1)
        else
            return ZeroRightJustify (round (value), -places)
        end if
    else
        if negative then set value to -value
        set int to truncate (value)
        set frac to (value - int) + 1.0
        for places
            multiply frac by 10
        end for
        set rounded to round (frac)
        if char 1 of rounded = "2" then add 1 to int
        set rounded to int & "." & char 2 to (places + 1) of rounded
        if negative then return "-" & rounded
        return rounded
    end if
----------------
end RealToString
----------------

------------------------------------------
function string quoted_string (string str)
------------------------------------------

    -- return the argument, enclosed in quotes. Actually, we need to 
    -- expand internal quotes to double-quotes as well!
    -- note: this code may not properly handle unicode strings.
    
    local integer i
    local integer n = numberofchars (str)
    
    repeat with i=1 to n
        if i="'" then return "'" & (char 1 to i of str) & quoted_string (char (i+1) to n of str)
    end repeat
    
    -- no quotes inside!
    return "'" & str & "'"

-----------------
end quoted_string
-----------------

---------------------------------------
function string spaced_out (string str)
---------------------------------------

    -- make a string 'stand out' in a listing by 
    -- stretching it with spaces.
    
    local integer i
    local string  s = char 1 of str
    repeat with i=2 to numberofchars (str)
        set s to s && char i of str
    end repeat
    return s
--------------
end spaced_out
--------------

--------------------------------------------------
function string rightpad (string str, integer len)
--------------------------------------------------

    -- return the supplied string, right-padded to make it at
    -- least <len> chars long.

    local integer i = len - numberofchars (str)
    repeat while i>=30
        set str to str & thirty_spaces
        subtract 30 from i
    end repeat
    if i <=0 then return str
    return str & char 1 to i of thirty_spaces
    
------------
end rightpad
------------

----------------------------------------
function string comment_bar (string str)
----------------------------------------

    -- pretty-print a comment bar containing a string, to assist 
    -- finding ones way around the output of an application.
    
    local string s = spaced_out (str) -- will be an odd length!
    local integer n = numberofchars (s)
    local integer n2 = n div 2
    return '/*' && thirty_dashes & thirty_dashes && '*/\n/*' & \
           (char 1 to (30-n2)   of thirty_spaces) && s && \
           (char 1 to (30+n2-n) of thirty_spaces) & \
           '*/\n/*' && thirty_dashes & thirty_dashes && '*/\n'

---------------
end comment_bar
---------------

---------------------------------------------------------
function string indent_string (string str, string indent)
---------------------------------------------------------

    -- produce an indented version of the supplied multi-line string
    -- (though don't bother indenting blank lines)
    
    local string  res = ''
    local string  s
    local string  sep = ''
    local integer i
    
    repeat with i=1 to numberoflines (str)
        set s to line i of str
        if s <> '' then set s to indent & s
        set res to res & sep & s
        set sep to '\n'
    end repeat
    return res

-----------------
end indent_string
-----------------

-------------------------------------------------------------------------------
-- more global functions, that are relevant only to this application
-------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
function boolean check_name_in_string (string name, string wordlist, \
                                       string message1, string message2, string location)
-----------------------------------------------------------------------------------------

    -- check whether the 'name' string (which should begin and end in a space) is
    -- in the given wordlist (which should also begin and end in a space). if so, 
    -- use debug to report the fact (complete with the supplied messages and the
    -- information about the location of the occurence of the word) and return TRUE.
    -- if no match, return FALSE

    if name in wordlist then
        debug message1 & name & '(used' && location & '):\n       ' & message2
        return true
    end if
    return false

------------------------
end check_name_in_string
------------------------

--------------------------------------------------------------------------------------
function boolean check_name_in_SQLstring (string name, string wordlist, \
                                          string versioninfo, string location)
--------------------------------------------------------------------------------------

    -- use check_name_in_string to report whether the name is a Polyhedra SQL reserved
    -- word; versioninfo will be blank or an indication of the version of Polyhedra in
    -- which the word was introduced.

    return check_name_in_string ( name                                                       \
                                , wordlist                                                   \
                                , 'WARNING:'                                                 \
                                , 'this is a reserved word in Polyhedra SQL' & versioninfo & \
                                  '; rename or use in double-quotes!'                        \
                                , location) 

---------------------------
end check_name_in_SQLstring
---------------------------

---------------------------------------------------------
function boolean check_name (string str, string location)
---------------------------------------------------------

    -- check if the supplied string is a reserved word (or
    -- other SQL keyword) and if so print out a warning and
    -- return FALSE.
    
    local string s = ' ' & str & ' '
    
    if s in permitted_words then return false -- skip all checks
    
    if check_name_in_SQLstring (s, Polyhedra_SQL_keywords,   '',                               location) then return true
        
    if check_name_in_SQLstring (s, Polyhedra50_SQL_keywords, ' (introduced in Polyhedra 5.0)', location) then return true
        
    if check_name_in_SQLstring (s, Polyhedra63_SQL_keywords, ' (introduced in Polyhedra 6.3)', location) then return true
        
    if check_name_in_SQLstring (s, Polyhedra83_SQL_keywords, ' (introduced in Polyhedra 8.3)', location) then return true
        
    if check_name_in_SQLstring (s, Polyhedra86_SQL_keywords, ' (introduced in Polyhedra 8.6)', location) then return true
        
    if check_name_in_SQLstring (s, Polyhedra87_SQL_keywords, ' (introduced in Polyhedra 8.7)', location) then return true
        
    if check_name_in_SQLstring (s, Polyhedra89_SQL_keywords, ' (introduced in Polyhedra 8.9)', location) then return true
        
    if check_name_in_string ( s, CL_keywords \
                            , 'warning re' \
                            , 'this is a reserved word in CL; we advise renaming it if you use CL' \
                            , location) then return true

    if check_name_in_string ( s, SQL_2003_reserved_words \
                            , 'advisory notice re' \
                            , 'this is a reserved word in in SQL 2003 - consider renaming it' \
                            , location) then return true

    if check_nonreserved_words then
       if check_name_in_string ( s, SQL_2003_nonreserved_words \
                                , 'advisory notice re' \
                                , 'this is a "non-reserved" word in in SQL 2003 - consider renaming it' \
                                , location) then return true
    end if
    
    if check_name_in_string ( s, c_reserved_words \
                            , 'warning re' \
                            , 'this is a reserved word in C and C++' \
                            , location) then return true

    if check_name_in_string ( s, cplusplus_reserved_words \
                            , 'warning re' \
                            , 'this is a reserved word in C++' \
                            , location) then return true
    
    if check_name_in_string ( s, extra_reserved_words \
                            , 'warning re' \
                            , 'this is in the list of extra words that you gave me!' \
                            , location) then return true

    return false

--------------
end check_name
--------------

-------------------------------------------------
function boolean name_needs_quoting (string name)
-------------------------------------------------

    -- do we need to quote the name when generating SQL?
    
    local string str = ' ' & name & ' '
    
    -- (1) is the name not all lower case? Polyhedra is in general case-insensitive,
    --     except when names are quoted.
    
    if name <> lowercase (name) then return true
    
    -- (2) does the name match a Polyhedra SQL keyword - in which case we
    --     certainly need to quote it
    
    if str in Polyhedra_SQL_keywords then return true
    
    -- (3) what about if it is an SQL 2003 reserved word? Well, it might be 
    --     sensible to quote it on the grounds of being able to use the 
    --     generated SQL with other SQL engines (and to allow for future
    --     extensions to the Polyhedra SQL engine). 
    --     Perhaps we ought to make the next line resource-controlled, but 
    --     the simpler solution is just to comment it out
    
    -- if str in SQL_2003_reserved_words then return true
        
    -- (4) do we, or should we escape any of the SQL 2003 non-reserved words?
    --    (That is, the SQL keywords that do not have to be reserved because
    --    SQL parsers should always be able to distinguish them by their
    --    context.) Probably not - but if we wanted to do so, we would ensure
    --    that the next line is not commented out.
    
    -- if (' ' & name & ' ') in SQL_2003_nonreserved_words then return true
    
    -- (5) What if it is a special word we have been asked to check for? 
    --     As this mechanism was primarily provided to allow existing databases
    --     to be checked for problems concerning forthcoming enhancements, we
    --     should probably ensure such words are quoted. This also allows us a
    --     way of ensuring specific words in other SQL dialects are quoted, 
    --     even if tests (3) and (4) are commented out.
    
    if str in extra_reserved_words then return true
    
    return false

----------------------
end name_needs_quoting
----------------------

---------------------------------------------
function string html_table_link (string name)
---------------------------------------------

    -- return a string containing a link to a detailed table definition

    return '<a href="#table_' & name & '">' & name & '</a>'

-------------------
end html_table_link
-------------------

------------------------------------------
function string sql_quoted_word (string s)
------------------------------------------

    -- return the string, but as an SQL quoted name.

    return '"' & s & '"'

-------------------
end sql_quoted_word
-------------------

-----------------------------------
function string sql_word (string s)
-----------------------------------

    -- return the string, but wrapped in quotes if, for example it is a 
    -- reserved word in Polyhedra's SQL dialect.

    if name_needs_quoting (s) then return sql_quoted_word (s)
    return s

------------
end sql_word
------------

---------------------------------------
function string interval (datetime dt)
---------------------------------------

    -- function used to show how long a stage took, in a normalised form
    
    -- first, a tweak to see if the time given is the start time of
    -- the phase, instead of the actual time taken for a stage.
    
    if dt >= compiletime then set dt to now () - dt
    
    -- return a normalised string
    
    return RightJustify (RealToString (to_microseconds (dt) / 1000000, 2), 6)
 
------------
end interval
------------

---------------------------------------
function string timetaken (datetime dt)
---------------------------------------

    -- function used to show how long a stage took, in a normalised form
    
    
    return interval (dt) && 'seconds.'
 
-------------
end timetaken
-------------

-------------------------------------------------------------------------------
-- utility classes to help us build up very long strings a bit more efficiently
-------------------------------------------------------------------------------

------------------
class stringholder
------------------

export string value

---------
end class
---------

----------------
class stringlist
----------------

    -- a class to build up a string from a lot of pieces, avoiding some of the n-squared
    -- problems of doing it ther 'lazy way' in CL (eg, just repeatedly saying 
    -- 'set str to str & ...')
    
    -- to use this class, create an instance, add substrings by calling record...
    --    record ('...') of strlist
    -- and then extracting the final result by calling GetValue...
    --    set str to Getvalue () of strlist
    -- (remember to delete the object, either explicitly or by exiting
    -- the function to which the object is a local variable! The deconstructor
    -- tidies up the stringholder objects used to hold the substrings.)

    array of stringholder strings
    integer        length = 0 -- number of substrings
    export integer bytes  = 0 -- cumulative string length
    export integer lines  = 0 -- cumulative number of lines       
    
    on  delete
        repeat while exists object 1 of strings
            delete object 1 of strings
        end repeat
    end delete
    
    on record (string str)
        create stringholder (value = str) into strings
        add 1 to length
        add numberofchars (str) to bytes
        add numberoflines (str) to lines
    end record

    function string getsubstring (integer lo, integer hi)
        --
        -- (an internal function, to help build up the total
        -- string using a binary chop mechanism to minimise
        -- copying. it is assumed that all strings are a
        -- similar-enough size for a binary chop procedure
        -- to be reasonably efficient.)
        --
        -- return the substring corresponding to the objects
        -- <lo> to <hi> (inclusive) of the strings array.
        --
        local integer i = (lo + hi) div 2
        if lo > hi then return ''
        if lo = hi then return value of object i of strings
        return getsubstring (lo, i) & getsubstring (i+1, hi)
    end getsubstring
    
    function string getvalue
        return getsubstring (1, length)
    end getvalue
    
    function boolean write_text_to_file (string filename, boolean decorate)
        --
        local integer        i
        local boolean        res = true
        local reference file output
        --
        create file (name=filename, IsBinary=false, Mode=Write) into output
        if not exists output then
            debug 'could not create "file" object with name' && filename & '!'
            return false
        end if
        if not Open () of output then
            debug 'could not open file' && filename & ':' && LastError of output
            return false
        end if
        
        if decorate then set res to Write (comment_bar (filename) & '\n') of output

        repeat with i=1 to length
           if not res then exit repeat
           set res to Write (value of object i of strings) of output
        end repeat
        
        if decorate and res then set res to Write (comment_bar ('end of file')) of output

        if not res then debug 'problem writing to file' && filename & ':' && Lasterror of output       
        set res to Close () of output
        if not res then debug 'problem closing file' && filename & ':' && LastError of Output
        delete output
        return res
    end write_text_to_file
    
---------
end class
---------

-------------------------------------------------------------------------------
-- classes to hold schema information, and associated methods
-------------------------------------------------------------------------------

------------------
class named_object
------------------
    
    -- base class from which things like column, table, etc can derive, to
    -- provide a way of centralising how names which match Polyhedra reserved
    -- words are handled.
    
    export string  name
    boolean        needs_quoting
    
    on  create
        --
        -- check if its name is an SQL reserved word, or if it needs to always be
        -- quoted to ensure the case is preserved
        --
        set needs_quoting to name_needs_quoting (name)
    end create
    
    function string sqlname
        --
        -- return the name, using SQL quotes if necessary
        --
        if needs_quoting then return sql_quoted_word (name)
        return name
    end sqlname

---------
end class
---------

----------------
class nameholder
----------------

    export string  text
    export string  text2
    
    boolean text_needs_quoting  = false
    boolean text2_needs_quoting = false
    
    on  create
        --
        -- check if the 1st text needs quoting when used in generated SQL
        --
        set text_needs_quoting  to name_needs_quoting (text)
        set text2_needs_quoting to name_needs_quoting (text2)
    end create
    
    function string sqltext
        --
        -- return the 1st text, using quotes if it is a Polyhedra reserved word
        --
        if text_needs_quoting then return sql_quoted_word (text)
        return text
    end sqltext
    
    function string sqltext2
        --
        -- return the 1st text, using quotes if it is a Polyhedra reserved word
        --
        if text2_needs_quoting then return sql_quoted_word (text2)
        return text2
    end sqltext2
    
---------
end class
---------

-- Polyhedra 8.7 introduced cascade deletes, etc:

constant integer cleanup_rule_cascade  = 0
constant integer cleanup_rule_restrict = 1
constant integer cleanup_rule_nullify  = 2

-------------------------------------------------------------------------------------
function string integrity_rule (integer code, integer default_code, string condition)
-------------------------------------------------------------------------------------
    if code = default_code then return ""
    if code = 0 then return condition && "cascade"
    if code = 1 then return condition && "restrict"
    if code = 2 then return condition && "set null"
    -- something odd occurred:
    return '/* ERROR:' && condition && 'code is' && code && '*/'
------------------
end integrity_rule
------------------

------------------------
class FK is named_object
------------------------

    -- used to hold info about a foreign key: its name, the name of the referenced
    -- table, the column(s) that hold the reference and the name of the corresponding
    -- PK column(s) in the referenced table.
    
    -- inherited attributes: name, (needs_quoting)
    
    export string table_name
    export string foreign_table
    
    -- attributes for cascade deletes, etc:
    export integer update_rule = cleanup_rule_cascade
    export integer delete_rule = cleanup_rule_restrict
    
    --boolean       table_name_needs_quoting
    --boolean       foreign_table_needs_quoting
    
    export array of nameholder names
    
    --on  create 
        --debug 'FK' && name && '->' && foreign_table
        --set table_name_needs_quoting to name_needs_quoting (table_name)
        --set foreign_table_needs_quoting to name_needs_quoting (foreign_table)        
    --end create
    
    on  populate (schemata s)
        --
        -- find the names of the FK attributes, and the names of the corresponding columns
        -- of the referenced table
        --
        -- in Polyhedra, foreign keys can only reference primary key attributes, 
        -- and the 'indexattrs' table merely contains the names of the FK columns
        -- plus their position - so you need to look elsewhere to find the name of the
        -- referenced column(s). 
        -- 
        -- in fact, you cannot just look at the information in the schema directly
        -- relating to the foreign table itself, as it may be a derived table -
        -- in which case you have to find the base table, and look there.
        --
        local reference table pointee
        
        --Report ('\t(populate () called for FK' && name & ')') of s
        set pointee to find_base_table (foreign_table) of s
        assert exists pointee  

        fill names with sql \
            'select ia.attr_name text, ia2.attr_name text2'             && \
            'from indexes i, indexattrs ia, indexes i2, indexattrs ia2' && \
            'where i.name=ia.index_name'                                && \
            'and   i2.name=ia2.index_name'                              && \
            "and   i2.name='PK-" & name of pointee & "'"                && \
            'and   ia.index_order=ia2.index_order'                      && \
            "and   i.name='" & name & "' order by ia2.index_order"
	
        assert exists object 1 of names
    end populate
    
    function string sql_for_fk
        --
        -- generate the SQL for defining a foreign key in a table
        --
        local string               str = 'foreign key (' 
        local string               sep = ''
        local reference nameholder n
        local string               integrity_policy = ''
        --
        foreach n in names
            set str to str & sep & sqltext () of n
            set sep to ', '
        end foreach
        set sep to ') references' && sql_word (foreign_table) && '('
        foreach n in names
            set str to str & sep & sqltext2 () of n
            set sep to ', '
        end foreach
        return str & ')' & integrity_rule (update_rule, cleanup_rule_cascade,  ' on update') & \
                           integrity_rule (delete_rule, cleanup_rule_restrict, ' on delete') 
    end sql_for_fk
    
    function string html_for_fk
        --
        -- generate the HTML for describing a foreign key in a table,
        -- with the reference to the other table being a link (if it
        -- is not to the same table)
        --
        local string               str = '(' 
        local string               sep = ''
        local reference nameholder n
        --
        foreach n in names
            set str to str & sep & text of n
            set sep to ', '
        end foreach
        
        if table_name = foreign_table then 
            set sep to ') references' && foreign_table && '('
        else 
            set sep to ') references' && html_table_link (foreign_table) && '('
        end if
        
        foreach n in names
            set str to str & sep & text2 of n
            set sep to ', '
        end foreach
        return str & ')' & integrity_rule (update_rule, cleanup_rule_cascade,  ' on update') & \
                           integrity_rule (delete_rule, cleanup_rule_restrict, ' on delete')
    end html_for_fk
    
---------
end class
---------

constant string unknowntype = 'SQLUNKNOWN'

----------------------------
class column is named_object
----------------------------

    -- inherited attributes: name, (needs_quoting)

    -- attributes obtained from database
    
    export string   table_name
    export string   type
    export integer  length
    export boolean  persistence
    export boolean  not_null
    export boolean  islocal
    export boolean  isarray
    export boolean  ishidden
    export string   default_value
    export boolean  isprimary
    export boolean  isshared
    export boolean  isvirtual
    export boolean  isexternal
    
    -- other attributes
    
    export integer       colnumber    = -1 -- will be set >=0 by table::find_columnumber()
    export reference FK  references        -- will be set later if this is a single-key ref.
    boolean              passbyvalue  = true
    string               emptyval     = '0'
    
    on  create
        --
        -- old databases might make use of the 'internal' type; 
        -- change this to hidden integers.
        --
        if type = 'internal' then
            debug 'Warning: the INTERNAL type is no longer supported -\n       we will treat' && \
                  "type of '" & name & "' attribute as as INTEGER HIDDEN."
            set type to 'integer'
            set ishidden to true
        end if
    end create
    
    function string sqltype
        --
        -- determine the SQL string which can be used to set the attribute type.
        -- used in building an SQL definition of the schema.
        --
        local string str = ''
        --
        if type='binary' then
            if length=0 then
                set str to 'binary large object'
            else
                set str to 'binary(' & length & ') large object'
            end if
        else 
            if isarray then 
                set str to 'array of' && sql_word (type)
            else if isexternal then 
                set str to 'large ' && type
            else
                set str to type
            end if
            if length>0 then set str to str & '(' & length & ')'
        end if
        return str
    end sqltype
    
    function string sql_default_info
        --
        -- generate the text for the default values
        --
        if default_value = '' then return ''
        if type='char' or type='varchar' or type='datetime' then
            return quoted_string (default_value)
        else if type='binary' then
            return "x'" & default_value & "'"
        else if (type='float' or type='float32') and not \
                ('.' in default_value or 'E' in default_value) then 
            return default_value & '.0'
        else
            return default_value
        end if
    end sql_default_info
    
    function string sql_details (table t)
        --
        -- generate the sql for the full attribute definition, including
        -- default values, primary key and references info where appropriate.
        --
        local string str
        local string str2
        
        -- type?
        
        set str to sqltype ()
        
        -- primary, not-null, persistent, local?
        
        if isprimary and not exists object 2 of PKs of t then
            set str to str && 'primary key'
            -- no need to print persistence, etc: it must match that of the table.
            -- (however, we will print this info per column if PK is multi-column)
        else
            if not_null then set str to str && 'not null'
            if persistence = persistence of t then
                -- no need to print column persistence
            else if persistence then
                set str to str && 'persistent'
            else
                set str to str && 'transient'
            end if
            if islocal and not islocal of t then set str to str && 'local'
        end if
        
        -- hidden, shared, virtual? 
        
        if ishidden and not isarray then set str to str && 'hidden'
        if isshared                 then set str to str && 'shared'
        if isvirtual                then set str to str && 'virtual'
        
        -- references?
        
        -- we can put 'references <table>' inline, provided it it is not a
        -- multi-key reference. 
        
        if exists references then 
            set str to str && \
                       'references' && sql_word (foreign_table of references) & \
                       integrity_rule (update_rule of references, cleanup_rule_cascade,  ' on update') & \
                       integrity_rule (delete_rule of references, cleanup_rule_restrict, ' on delete')
        end if
        
        -- default?
        
        if default_value <> '' then
            set str to str && 'default' && sql_default_info ()
        end if
        
        return str
    end sql_details

    function string html_details (table t, string tab)
        --
        -- generate the html for the attribute, including default values, 
        -- primary key/null info and references info where appropriate.
        --
        local string  str
        local string  str2
        local string  blank = '&nbsp;'
        
        -- type?
        
        set str to sqltype ()
        
        -- primary, not-null, persistent, local?
        
        if isprimary and not exists object 2 of PKs of t then
            set str to str & tab && 'primary key'
        else if not_null then 
            set str to str & tab && 'not null'
        else
            set str to str & tab & blank
        end if
        
        if persistence then
            set str to str & tab && 'persistent'
        else
            set str to str & tab && 'transient'
        end if
        if islocal and not islocal of t then set str to str && 'local'
        
        -- hidden, shared virtual? 
                
        set str2 to ''
        if ishidden  and not isarray then set str2 to str2 && 'hidden'
        if isshared                  then set str2 to str2 && 'shared'
        if isvirtual                 then set str2 to str2 && 'virtual'
        if str2 <> '' then
            set str to str & tab & str2
        else 
            set str to str & tab & blank
        end if
        
        -- references?
        
        -- we can put 'references <table>' inline, provided it it is not a
        -- multi-key reference. 
        if exists references  then
            set str to str & tab & html_table_link (foreign_table of references) 
        else
            set str to str & tab & blank
        end if
        
        -- default?
        
        if default_value <> '' then
            set str to str & tab && sql_default_info ()
        else
            set str to str & tab & blank
        end if
        
        return str
    end html_details

    function string sql_for_column (table t, integer col_len, string prefix)
        --
        return '\n' & prefix & ',' && rightpad (sqlname(), col_len) && sql_details (t)
    end sql_for_column

---------
end class
---------

---------------------------
class table is named_object
---------------------------

    -- from database schema (the 'tables' table):
    
    -- inherited attributes: name, (needs_quoting)
    
    export string              derived_from
    export string              pk_index
    export boolean             persistence
    export boolean             islocal
    export boolean             system
    export integer             depth
    
    -- additional attributes used by this app:
    
    export boolean             skip_me = false
    export array of column     columns
    export array of nameholder PKs
    export array of FK         FKs
    export reference schemata  schema_object           -- used to report when we are populated
    reference table            supertable              -- table record for derived_from
    reference table            basetable       = me    -- base from which I derive
    export integer             visible_columns = -1    -- will include #(inherited columns)
    export string              classtype       = 'table'
    export boolean             special         = false -- is it a CL, DVI, Historian or other special table?
    export string              colour          = html_general_colour
    -- track subclasses (for HTML)        
    export table_list          subclasses
    export integer             subclasscount   = 0
    -- track references to me (for HTML)
    export array of index      FK_references
    -- track uses of me (for HTML about domains)
    export array of nameholder Columns_using_me
    -- how many records in the table and subtables?
    integer                    recordsintable     = 0 -- (can find this by select count(*) query)
    integer                    recordsinsubtables = 0 -- subtables will need to tell us!
            
    on  check_hierarchy
        --
        -- check subclass structure. Note that all the table objects
        -- should have been created, and 'supertable' discovered for
        -- all my superclasses. (note that 'subclasscount' is misnamed;
        -- it is actually the number of rows that will be needed to 
        -- represent this hierarchy in the hierarchy diagram)
        --
        local reference table t
        local boolean increasecounts = true
        ---
        if derived_from = '' then
            --set basetable to me
        else
            if depth > max_depth of schema_object then set max_depth of schema_object to depth
            set supertable to find_table (derived_from) of schema_object
            set t to supertable
            add_table (me) of subclasses of t

            repeat forever
                if increasecounts then 
                    add 1 to subclasscount of t
                    if subclasscount of t < 2 then set increasecounts to false
                end if
                if not exists supertable of t then exit repeat
                set t to supertable of t
            end repeat
            set basetable to t
        end if
        
        if report_record_count then
            -- ask how many records in me (and my subclasses); this currently
            -- (November 2010) needs the server to iterate over the table, so
            -- will be slow if the table is big.
            fill me with sql "select count(*) recordsintable from" && sqlname()
            -- report record count to my parent class
            if recordsintable > 0 and exists supertable then
               add recordsintable to recordsinsubtables of supertable
            end if
        end if
    end check_hierarchy
    
    on populate
        --
        -- look up information relating to the current table, and
        -- report back to the parent object (of type schemata)
        -- when done.
        --
        -- to allow for parallel operations, we should NOT assume
        -- that other table structures have been fully populated -
        -- though we can assume that the basic info picked up from
        -- the 'tables' table is present.
        --
        local reference fk     fkptr
        local reference column c
        local reference table  t = me
        local integer          i
        --        
	    set colour to choose_colour ()
	
        -- find about my columns, by looking in the 'attributes' table
        -- note: we deliberately use 'select *' rather than listing 
        -- the columns we want, as we would like to be able to inspect 
        -- databases running on old versions of the Polyhedra software.
	
        if not globalfetch then fill columns with SQL \
            "select * from attributes where table_name='" & name & "'"
                    
        -- discover my PK attributes, by querying the indexattrs
        -- table that refer to my PK index (defined by the pk_index
        -- column from the 'tables' table).
	
        if not globalfetch then fill PKs with SQL \
            "select attr_name text from indexattrs" && \
            "where index_name='" & pk_index & "' order by index_order"
        -- domains will not have PKs, views might or might not have PKs
	    
        -- find the foreign keys defined on this table: we can discover
        -- this by looking for indexes on this table where the entry
        -- in the 'indexes' table has a non-null value in the 
        -- 'foreign_table' column. We cannot have indexes on domains or
        -- views, so this step is a waste of time for them (but harmless)
	
        if not globalfetch then fill FKs with SQL \
            "select * from indexes" && \
            "where foreign_table is not null and table_name='" & name & "'"
	    
        -- for each FK, find out the relevant columns. 
	
        foreach fkptr in FKs
            populate (schema_object) of fkptr
            
            -- I (ND) have a personal preference for defining references as
            -- part of the column definition where possible - that is,
            -- where the referenced table does not have a multi-column
            -- primary key.
            -- If other styles are preferred, remove the following code:
            
            if not exists object 2 of names of fkptr then
                set c to findcolumnbyname (text of object 1 of names of fkptr)
                set references of c to fkptr
                remove fkptr from FKs -- to avoid double-reporting
            end if
        end foreach
	
        -- we have almost finished grabbing the info relating to this table;
        -- however, it may actually be a domain, so give it a chance to grab any
        -- info available. (in particular, we can see if/where the domain is used,
        -- and populate the Columns_using_me array accordingly.
        
        more_populate_code ()
        
        -- decrement the pointer in my parent object, so that if things
        -- are being done in parallel it can know when all tables are done
	
        --Report '\t    (' & classtype && name && 'populated.)') of schema_object
        subtract 1 from counter of schema_object
    end populate
    
    on  more_populate_code
        --
        -- virtual function; do nothing here, redefine in subclasses as needed
        --
    end more_populate_code
    
    function string recordcount_info (string prefix, string postfix)
        --
        -- return info about the number of records, including the number of
        -- records in derived tables, wrapped up in the given prefix and postfix
        -- (but return the empty string if record count is zero, or if we have
        -- not checked the record count).
        --
        -- currently, output will be blank, or in one of the forms
        -- (surrounded, of course, by <prefix> and <postfix>):
        --
        --     1 record
        --     <n> records
        --     1 record, in a subtable
        --     <n> records, all in subtables
        --     1 record, plus <m> in subtables
        --     <n> records, plus <m> in subtables 
        --
        local string str
        local integer ct     = recordsintable 
        local integer basect = recordsintable - recordsinsubtables
        --
        if (not report_record_count) or recordsintable = 0 then return ''
        if basect = 0 then set ct to recordsinsubtables
        set str to prefix & ct && 'record'
        if ct > 1 then set str to str & 's'
        if recordsinsubtables > 0 then
            if recordsinsubtables = recordsintable then
                if recordsintable=1 then
                    set str to str & ', in a subtable'
                else
                    set str to str & ', all in subtables'
                end if
            else
                set str to str & ', plus' && recordsinsubtables && 'in subtables'
            end if
        end if
        return str & postfix
    end recordcount_info
    
    function string sql_for_table (string prefix)
        --
        -- produce the string that would recreate the current table object
        -- (unless the table name is in the list of those to be skipped).
        --
        local reference column     c
        local reference nameholder n
        local reference fk         fkptr
        local string               sep
        local stringlist           strlist 
        local string               str2 = prefix & 'create' && classtype && sqlname () & '\n'
        local integer              maxlen = 0
        --
        if skip_me then return '--' && classtype && name && 'skipped.'
        
        set str2 to str2 & recordcount_info (prefix & '--\n' & prefix & '-- (', ')\n' & prefix & '--\n')
        
        if persistence then 
            set str2 to str2 & '( persistent'
        else
            set str2 to str2 & '( transient'
            if islocal then set str2 to str2 & ', local'
        end if
        if derived_from <> '' then set str2 to str2 && '\n' & prefix & ', derived from' && sql_word (derived_from)
        record (str2) of strlist
        
        foreach c in columns
            set maxlen to round (max (maxlen, numberofchars (sqlname() of c)))
        end foreach
        foreach c in columns
            record (sql_for_column (me, maxlen, prefix) of c) of strlist
        end foreach
        
        -- primary keys?
        if getarraysize (PKs) > 1 then
            set str2 to '\n,' & prefix && 'primary key ('
            set sep to ''
            foreach n in PKs
                set str2 to str2 & sep & sqltext () of n
                set sep to ', '
            end foreach
            record (str2 & ')') of strlist
        end if
        
        -- foreign keys
        foreach fkptr in FKs
            record ('\n' & prefix & ',' && sql_for_fk () of fkptr) of strlist
        end foreach
        
        return getvalue () of strlist && '\n' & prefix & ')'
    end sql_for_table
    
    function string choose_colour
        --
        -- what is an appropriate colour to associate with this table/domain/view?
        --
        -- for the moment, base this decision on whether it is a system table,
        -- a special table, etc; later, we could introduce 'islands'.
        --
        if system      then return html_system_tables_colour
        if not skip_me then return html_general_colour
        if special     then return html_special_tables_colour
        return                     html_skipped_tables_colour
    end choose_colour
    
    function string colouredcell (integer width, integer height, string forcedcolour)
        --
        if forcedcolour="" then set forcedcolour to colour
        if width<=1 and height <=1 then return '<td' && forcedcolour & '>'
        return '<td' && forcedcolour && 'colspan="' & width & '" rowspan="' & height & '">'
    end colouredcell
        
    function string html_link
        --
        -- return a string containing a link to the detailed table definition
        --
        if skip_me then return name
        return html_table_link (name)
    end html_link
    
    function string html_derived_chain
        --
        -- return a string indication the derivation chain
        --
        local string str
        --
        if not exists supertable then return ''
        set str to html_derived_chain () of supertable
        if str = '' then return html_link () of supertable
        return str && '&lt;&lt;&lt;' && html_link () of supertable 
    end html_derived_chain
 
    function string decorative_html_derived_chain (boolean linkme, boolean include_subclasses)
        --
        -- return a decorative string indication of the derivation chain. 
        -- if subclasses is true, include an indication of them as well (if any).
        -- when showing my name, linkme will determine whether it appears as a link.
        --
        local string          str   = ''
        local reference table t     = supertable
        local integer         depth = subclasscount
        local string          mytext
        
        if depth=0 or not include_subclasses then set depth to 1 
        if linkme then
            set mytext to html_link ()
        else
            set mytext to '<font size="+1"><b>' & name &'</b></font>'
        end if
        
        repeat while exists t 
            set str to colouredcell (1, depth, 'bgcolor="white"') & html_link () of t & str
            set t to supertable of t
        end repeat
        
        set str to str & colouredcell (1, subclasscount, 'bgcolor="white"') & mytext
        
        if subclasscount > 0 and include_subclasses then
            set str to str & html_subclass_structure_for_table ( max_depth of schema_object     \
                                                               , true, false, 'bgcolor="white"' \
                                                               ) 
        end if

        return '<table cellspacing="2" cellpadding="3"><tr>' & str & '</tr></table>\n'
    end decorative_html_derived_chain
    
    function string html_subclass_structure_for_table (integer max_depth, boolean skip_level, boolean show_counts, string forcedcolour)
        --
        -- return a string illustrating the subclass structure for this table
        --
        local stringlist      strlist
        local string          sep = ''
        local reference table t
        local string          ctinfo = ""
        --
        if show_counts then set ctinfo to recordcount_info (' (', ')')
        --
        if not exists object 1 of tables of subclasses then
            if skip_level then return ''
            return colouredcell (1+max_depth - depth, 1, forcedcolour) & html_link () & ctinfo
        else
            if not skip_level then record (colouredcell (1, subclasscount, forcedcolour) & html_link () & ctinfo) of strlist
            repeat foreach t in tables of subclasses
                record (sep & html_subclass_structure_for_table (max_depth, false, show_counts, forcedcolour) of t) of strlist
                set sep to '\n<tr>'
            end repeat
            return getvalue () of strlist
        end if
    end html_subclass_structure_for_table
    
    function string html_summary_for_table
        --
        -- produce the string to describe the current table object
        --
        local reference column     c
        local string               sep
        local string               str
        local string               str2
        local string               cell   = colouredcell (1, 1, "")
        --
        set str to '<tr>' & cell & '<b>' & html_link () & '</b>\n'
        
        if persistence then 
            set str to str & cell & 'persistent'
        else
            set str to str & cell & 'transient'
            if islocal then set str to str & ', local'
        end if
        if derived_from = '' then 
            set str to str & cell && '&nbsp;' 
        else
            set str to str & cell & decorative_html_derived_chain (false, false) 
        end if
        
        set str to str & cell
        set sep to ''
        foreach c in columns
            set str to str & sep && name of c
            set sep to ','
        end foreach
        
        return str & '\n'
    end html_summary_for_table
    
    function string html_for_columns (boolean inherited, string cell, table t)
        --
        -- produce the string to describe the columns.
        --
        local reference column     c
        local string               sep
        local string               str = ''
        local string               str2
        local string               whitecell = '<td align="center">'
        --       
        if exists object 1 of columns then
            if inherited then 
                set str2 to 'columns inherited from' && html_link ()
            else if derived_from='' then
                set str2 to 'columns'
            else
                set str2 to 'added columns'
            end if
            if derived_from='' then 
                set str to '\n<tr>'                                            & \
                       colouredcell (1, 1 + getarraysize(columns), "") of t    & \
                       str2                                                    & \
                       whitecell & '<i><font size="-1">column name</i></font>' & \
                       whitecell & '<i><font size="-1">type</i></font>'        & \
                       whitecell & '<i><font size="-1">null?</i></font>'       & \
                       whitecell & '<i><font size="-1">persistence</i></font>' & \
                       whitecell & '<i><font size="-1">hidden?</i></font>'     & \
                       whitecell & '<i><font size="-1">references</i></font>'  & \
                       whitecell & '<i><font size="-1">default</i></font>'
                set sep to '\n<tr>'
            else
                set str to html_for_columns (true, cell, t) of supertable & '\n<tr>' & \
                           colouredcell (1, getarraysize(columns), "") of t & str2
                set sep to ''
            end if
            foreach c in columns
                set str to str & sep & cell & name of c & cell & html_details (me, cell) of c
                set sep to '\n<tr>'
            end foreach
        else if exists supertable then
            set str to html_for_columns (true, cell, t) of supertable
        end if
        
        return str 
    end html_for_columns
    
    function string html_for_table
        --
        -- produce the string to describe the current table object.
        -- 
        -- the output will define a number of rows in a table, 
        -- but does not include the <table and </table> directives.
        -- As a result, it is possible to output all the detailed
        -- table descriptions as a single HTML table (with blank rows
        -- as separators) to ensure consistency of column width, or
        -- have separate HTML tables for each database table (which
        -- means loading the html file is quicker, but the output is
        -- perhaps not as pretty).
        --
        local reference column     c
        local reference nameholder n
        local reference fk         fkptr
        local reference table      t
        local reference index      index_ptr
        local string               sep
        local stringlist           strlist
        local string               str2
        local string               str3
        local string               cell          = colouredcell (1, 1, "")
        local string               widecell      = colouredcell (7, 1, "")
        local string               fullwidthcell = colouredcell (8, 1, "")
        local string               widewhitecell = '<td colspan="7">'
        
        if skip_me then return ''

        -- record ('\n<tr><td><font size="-2">&nbsp;</font></td></tr>\n') of strlist   
        
        -- start off with a banner row identifying the table, plus an <A NAME="..."> tag to
        -- allow us to jump to this table description.
                     
        record ('<tr><td colspan="8"' && html_border_colour & '>' & \
                '<b><font size="+2" color="navy">' & name & '</font></b><a name="table_' & name & \
                '">&nbsp;</a></td></tr>') of strlist   
                     
        -- show info about superclasses and subclasses (if any)
        
        if counter of subclasses > 0 or exists supertable then

            if exists supertable then
                if counter of subclasses > 0 then
                    set str3 to "derivation chain,<br>plus derived tables"
                else
                    set str3 to "derivation chain"
                end if
            else
                set str3 to "derived tables"
            end if
            set t to supertable
            set str2 to ''
            repeat while exists t 
               set str2 to \
                    colouredcell (1, subclasscount, 'bgcolor="white"') & html_link () of t & str2
                set t to supertable of t
            end repeat

            record ('\n<tr>' & cell & str3 & widecell & decorative_html_derived_chain (false, true) & '</td></tr>') of strlist
        end if
        
        -- say if the table is persistent, transient, local.
        
        set str2 to '\n<tr>' & cell & 'persistence' & widecell
        if persistence then 
            set str2 to str2 && 'persistent'
        else
            set str2 to str2 && 'transient'
            if islocal then set str2 to str2 & ', local'
        end if
        record (str2) of strlist
        
        -- columns, including inherited ones
        
        record (html_for_columns (false, cell, me)) of strlist
        
        -- identify the primary keys
        
        if exists object 1 of PKs of basetable then
            set str2 to '\n<tr>' & cell & 'primary key' & widecell
            set sep to ''
            foreach n in PKs of basetable
                set str2 to str2 & sep & text of n
                set sep to ', '
            end foreach
            if depth >0 then 
                set str2 to str2 && '<i>(inherited from' && html_link () of basetable & ')</i>'
            end if
            record (str2 & '\n') of strlist
        end if
               
        -- list the multi-key foreign keys (added at this level)
        
        if exists object 1 of FKs then
            set sep to '\n<tr>' & colouredcell (1, getarraysize(FKs), "") & \
                       'multi-column foreign keys' & widecell
            foreach fkptr in FKs
                record (sep & html_for_fk () of fkptr) of strlist
                set sep to '\n<tr>' & widecell
            end foreach
        end if
        
        -- what references me?
        
        if exists object 1 of FK_references then
            set sep to '\n<tr>' & colouredcell (1, getarraysize(FK_references), "") & \
                       'referenced by' & widecell
            foreach index_ptr in FK_references
                record (sep & html_for_FK_index () of index_ptr) of strlist
                set sep to '\n<tr>' & widecell
            end foreach
        end if
        
        -- what uses me? (only meaningful for domains)

        if exists object 1 of Columns_using_me then
            set sep to '\n<tr>' & colouredcell (1, getarraysize(Columns_using_me), "") & \
                       'used by' & widecell
            foreach n in Columns_using_me
                record (sep & html_table_link (text of n) && '(' & text2 of n & ')') of strlist
                set sep to '\n<tr>' & widecell
            end foreach
        end if
        
        if not (system or skip_me) then
            record ('\n<tr>' & cell & 'definition' & widecell & '<pre>' & sql_for_table ('') & '</pre>\n') of strlist
        end if
        
        return getvalue () of strlist
    end html_for_table
    
    function integer find_columncount 
        --
        local integer          ct = 0
        local reference column c
        --
        if visible_columns >= 0 then return visible_columns  -- have been here before!
        
        if exists supertable then 
            set ct to find_columncount () of supertable
        end if
        foreach c in columns
            if not ishidden of c and not isarray of c then
                -- use ct before incrementing, as column numbers start at zero!
                set colnumber of c to ct
                add 1 to ct
            end if
        end foreach

        set visible_columns to ct
        return ct
    end find_columncount
    
    function column findcolumnbyname (string s)
        --
        -- locate the column object with the indicated name
        --
        local reference column c
        if exists supertable then
            set c to findcolumnbyname (s) of supertable
            if exists c then return c
        end if
        foreach c in columns
            if name of c = s then return c
        end foreach
        set c to null
        return c
    end findcolumnbyname
        
    function column findcolumnbynumber (integer n)
        --
        -- locate the column object with the indicated visible column number 
        --
        local reference column c
        local integer i
        if exists supertable then
            if n < visible_columns of supertable then
                return findcolumnbynumber (n) of supertable
            end if
        end if
        -- we cannot just zip along to a specific object in the 
        -- 'columns' array, as that does not allow for hidden 
        -- attributes. instead, do it the lazy way.
        foreach c in columns
            if colnumber of c = n then return c
        end foreach
        set c to null
        return c
    end findcolumnbynumber
    
    function integer check_names
        --
        -- check the name of the table and of all attributes to
        -- see if they clash with a reserved word.
        --
        local integer fail = 0
        local reference column c
        
        if skip_me then return 0
        
        --debug 'checking names in table' && name & '...'
        if check_name (name, 'as table name') then add 1 to fail
        foreach c in columns
            if check_name (name of c, 'as attribute in table' && name) then 
                add 1 to fail
            end if
        end foreach
        
        return fail
    end check_names
    
---------
end class
---------

-------------------
class view is table
-------------------

/* well, a view is not really a table, but has many things in common.
*/

    export string value
    
    on  create
        set classtype to 'view' 
    end create    
    
    function string sql_for_table (string prefix)
        --
        return prefix & 'create' && classtype && sqlname() && 'as\n' & prefix & '    ' & value & ';'   & \
               '\n\n' & prefix & '-- the "table" appears as though it had been defined by\n'      & \
               prefix & '--\n' & table:sql_for_table (prefix & '--    ')
    end sql_for_table

    function string html_for_view
        --
        return '<tr><td' && html_general_colour && 'rowspan=2><b>' & name & \
               '</b><td' && html_general_colour & '>' & value & ';\n'     & \
               '<tr><td' && html_general_colour                           & \
               '>the view appears as though it had been set up by the table definition:\n<ul><pre>' & \
               table:sql_for_table ('') & '</pre></ul>\n'
    end html_for_view

---------
end class
---------

---------------------
class domain is table
---------------------

/* well, a domain is not really a table, but has VERY many things in common.
   so we redefine certain things here so we can handle the extra stuff that
   is pertinent to a domain. (the bits that are not meaningful for a domain
   such as a list of foreign key references will be handled naturally, as
   the populate phase will have produced empty results).
*/
    
    on  create
        set classtype to 'domain' 
    end create   
    
    on  more_populate_code
        --
        -- virtual function; redefine here to populate the Columns_using_me array
        --
        fill Columns_using_me with sql "select table_name text, name text2 from attributes where type='" & name & "'"
    end more_populate_code

---------
end class
---------

---------------------------
class index is named_object
---------------------------

    -- inherited attributes: name, (needs_quoting)

    export string table_name
    export integer type
    export integer constraint_type
    export boolean is_unique
    export string foreign_table 
    
    export array of nameholder cols
    
    on populate (schemata s)
        --
        -- do any additional queries needed to set this object up fully.
        -- note this might be called in a separate CL thread, but all the
        -- table records, for example, will exist (but not necessarily
        -- fully populated).
        --        
        if foreign_table <> '' then 
            insert me into fk_references of find_table (foreign_table) of s
        end if
        
        fill cols with SQL \
            'select attr_name text from indexattrs' && \
            "where index_name='" & name & "' order by index_order"
        --Report ('\t    (index' && name && 'populated.)')
        subtract 1 from counter of s
    end populate
    
    on  print_schema_via_debug
        local string  s = sql_for_index ()
        local integer i
        repeat with i=1 to numberoflines (s)
            debug '\t' & line i of s
        end repeat
        debug ''
    end print_schema_via_debug
  
    function string sql_for_index
        --
        local string str = 'create'
        local string sep = ' ('
        local reference nameholder n
        --
        if is_unique then set str to str && 'unique'
        if type=4    then set str to str && 'ordered'
        set str to str && 'index' && sqlname () && 'on' && sql_word (table_name)
        foreach n in cols
            set str to str & sep & sqltext () of n
            set sep to ', '
        end foreach
        return str & ');'
    end sql_for_index
    
    function string html_for_index
        --
        local string str = '<tr><td' && html_general_colour & '><b>' & name & '</b>'
        local string sep = ''
        local string cell = '<td' && html_general_colour & '>'
        
        local reference nameholder n
        --
        set str to str & cell && html_table_link (table_name) && cell
        foreach n in cols
            set str to str & sep & text of n
            set sep to ', '
        end foreach
        
        if type=4 then 
            set str to str & cell & '<center>yes</center>'
        else
            set str to str & cell & '&nbsp;'
        end if
        
        if is_unique then 
            set str to str & cell & '<center>yes</center>'
        else
            set str to str & cell & '&nbsp;'
        end if
        
        return str 
    end html_for_index
    
    function string html_for_FK_index
        --
        local string str = html_table_link (table_name)
        local string sep = ' ('
        
        local reference nameholder n
        --
        foreach n in cols
            set str to str & sep & text of n
            set sep to ', '
        end foreach
        
        return str & ')'
    end html_for_FK_index
    
---------
end class
---------

----------------
class table_list
----------------

    export array of table tables
    export integer counter = 0
    
    on add_table (table t)
        --
        -- insert the table into my array, keeping it sorted!
        -- use a binary chop to find the right place.
    
        local integer         lo  = 1
        local integer         mid
        local integer         hi = counter
        local reference table obj

        repeat while lo <= hi
            set mid to (lo + hi) div 2
            set obj to object mid of tables

            -- check object is not already in the array!
            if t = obj then exit

            if name of t < name of obj then
                set hi to mid - 1
            else
                set lo to mid + 1
            end if
        end repeat

        insert t into tables at lo
        add 1 to counter
    end add_table
    
    function table find_table (string name)
        --
        -- use a binary chop to find the right object.
        
        local integer         lo  = 1
        local integer         mid
        local integer         hi = counter
        local reference table t
        --
        --debug "\t    find_table ('" & name & "') called.)"
        repeat while lo <= hi
            set mid to (lo + hi) div 2
            set t to object mid of tables
            --debug "\t    \tmid=" & mid & ", object name='" & name of t & "')"
            if name of t = name then return t
            if name < name of t then
                set hi to mid - 1
            else
                set lo to mid + 1
            end if
        end repeat

        forget t
        return t
    end find_table
    
    function string list_names
        --
        return get_names (1, counter)
    end list_names
    
    function string get_names (integer lo, integer hi)
        --
        local integer mid = (lo + hi) div 2
        --
        if lo>hi then 
            return ""
        else if lo=hi then 
            return name of object lo of tables
        else
            return get_names (lo, mid) && get_names (mid+1, hi)
        end if
    end get_names
    
---------
end class
---------

-------------------------------------------------------------------------------
-- main work class
-------------------------------------------------------------------------------

--------------
class schemata
--------------

/*  the class to instantiate to run the program. On creation, it populates
    the arrays of tables, views and indexes by means of queries on the 
    database to which the CLC is attached, and then tells the objects in
    these arrays to get what additional info they need to be able to 
    describe themselves. 
    It will set the counter attribute to indicate the number
    of objects in these arrays that need to grab more info. 
    When each these objects are ready, they will decrement the counter 
    attribute; when it reaches zero, the main work of the application is
    performed (as specified by resource settings)
*/

    array of table      tables
    array of view       views
    array of index      indexes
    array of index      FKindexes
    array of domain     domains
    
    -- if pre-fetching attribute info for tables (to reduce the need for 
    -- lots of little queries), then we need somewhere to put the data:
    
    array of column     columns
    array of nameholder PKs
    array of FK         FKs
    
    export integer      counter = 1
    export integer      max_depth = 0
    
    export datetime     starttime = now ()
    export datetime     preptime
    
    string              tables_to_skip
    string              tables_to_include
    
    table_list          base_tables
    table_list          special_tables
    table_list          application_tables
    table_list          all_tables
    table_list          domain_list
    
    on  create
        --
        local integer i
        --
        -- first, work out which tables to process, and which to skip.
        -- the resource 'include_tables' takes precedence: if specified,
        -- only tables in that list are of significance. Otherwise,
        -- the resource 'skip_tables' can replace or add to the default
        -- list of tables to skip; all others are included.
        --
        set tables_to_skip    to lowercase (GetResource ('skip_tables'))
        set tables_to_include to lowercase (GetResource ('include_tables'))
        if tables_to_skip='' then
            set tables_to_skip to default_tables_to_skip
        else if char 1 of tables_to_skip='+' then
            set tables_to_skip to \
                           default_tables_to_skip & ',' & \
                           (char 2 to (numberofchars(tables_to_skip)) of tables_to_skip)
        end if
        
        -- as a general rule of thumb it is better not to do too much
        -- (or more accurately, things that involve lots of round trips
        -- to the server or lots of I/O activity) inside CL 'on create'
        -- handlers unless necessary, so we do the first stage of the
        -- application (retreiving information about the schema in the
        -- database we are examining) in a separate CL thread. The 2nd
        -- stage of the application will be done by the 'stageTwo'
        -- method, below, and will be triggered by the 'counter'
        -- attribute being decremented to zero.
        
        Report ('Starting stage 1...')
        send populate () to me
    end create
    
    on  delete
    end delete
    
    on  set counter
        --
        if counter = 0 then send stagetwo () to me
    end set counter

    on  stageTwo
        --
        -- this is called when information about the database schema
        -- has been gathered, so it is here that we decide what to do
        -- about it. This procedure must also arrange for the client
        -- application to close down when it is finished.
        --
        -- (first perform here any final setup actions that must wait
        -- until all info has been gathered from the database being
        -- queried.)
        --
        local datetime        stagetime = now ()
        --
        check_column_counts ()
      
        set preptime to now () - starttime
        Report ('    Stage 1 completed in' && timetaken (preptime) & '\n')
        
        Report ('Starting stage 2...\n')
        
        if check_names   then check_names ()
        if dump_schema   then print_schema ()
        if create_html   then print_html ()
        
        Report ('    Stage 2 completed in' && timetaken (stagetime))
        Report ('    Total time taken was' && timetaken (starttime))
        quit
    end stageTwo
    
    ------------------------------------------------------------------
    -- methods used when populating the internal schema representation
    ------------------------------------------------------------------
    
    on populate
        --
        -- scan the database schema tables, to build up an internal
        -- representation of the schema of the database to which
        -- we are attached. Once this is done, decrement to
        -- zero to do the real work (as defined by the 'StageTwo'
        -- method).
        --
        -- note: we can't skip 'built-in' and/or selected tables at this 
        -- stage, as other tables might be derived from them and so
        -- (depending what is being done in stage 2) might need info
        -- about attributes, etc.
        --
        -- (to speed up the queries, we can do various ops in parallel,
        -- in which case we need to know when everything is complete:
        -- this is done by incrementing 'counter' whenever a // op is
        -- initiated, and decrementing it whenever the op is complete.)
        --
        local reference table      t
        local reference index      i
        local reference view       v
        local reference column     c
        local reference FK         fkptr
        local reference nameholder nh
        local integer              n
        local string               str

        --Report '\t(schemata::populate () called)'
        
        -- note: for certain queries we deliberately use 'select *' rather than
        -- listing the columns we want, as we would like to be able to inspect
        -- databases running on old versions of the Polyhedra software.     
        
        fill tables with sql \
            'select * from tables where type=0' -- and system=false' -- && 'order by depth, name'
        Report ('\t(schemata::populate () -' && getarraysize(tables) && 'tables fetched)')
        fill views with sql \
            'select name, value from views'
        Report ('\t(schemata::populate () -' && getarraysize(views) && 'views fetched)')
        fill domains with sql \
            'select * from tables where type=2' 
        Report ('\t(schemata::populate () -' && getarraysize(domains) && 'domains fetched)')
        fill indexes with sql \
            "select * from indexes where foreign_table is null and name not like '%K-%' order by name"
        Report ('\t(schemata::populate () -' && getarraysize(indexes) && 'indexes fetched)')
        fill FKindexes with sql \
            'select * from indexes where foreign_table is not null'
        Report ('\t(schemata::populate () -' && getarraysize(FKindexes) && 'FK indexes fetched)')

        -- an initial scan to build up an ordered list of all tables, etc
        -- so we can do fast look-ups

        foreach t in tables
            add_table (t) of all_tables
         end foreach
        foreach t in views
            add_table (t) of all_tables
         end foreach
        foreach t in domains
            add_table (t) of all_tables
            add_table (t) of domain_list
        end foreach
        Report ('\t(schemata::populate () - fast look-up table has' && counter of all_tables && 'entries)')

        if globalfetch then
        
            -- pre-fetch information about attributes, etc, so that the 
            -- individual table object do not have their own individual
            -- queries with the appropriate 'where' clause.
            
            -- attributes.
            
            -- note: deliberately use 'select *' rather than listing the
            -- columns we want, as we would like to be able to inspect
            -- databases running on old versions of the Polyhedra software.
            
            fill columns with sql 'select * from attributes'
            Report ('\t(schemata::populate () -' && getarraysize(columns) && 'attributes fetched)')
            repeat with n=1 to getarraysize (columns)
                set c to object n of columns
                set t to find_table (table_name of c)
                if exists t then 
                    insert c into columns of t
                else
                    debug "\tno home for column" && name of c && "of" && table_name of c
                    quit
                end if
            end repeat
            Report ('\t(schemata::populate () - attributes assigned)')
            
            -- primary keys
            
            fill PKs with SQL \
                "select attr_name text, index_name text2 from indexattrs" && \
                "where index_name like 'PK_%' order by index_order"
            Report ('\t(schemata::populate () -' && getarraysize(PKs) && 'PK attribute names fetched)')
            repeat with n=1 to getarraysize (PKs)
                set nh to object n of PKs
                set t to find_table (char 4 to 9999 of text2 of nh)
                if exists t then 
                    insert nh into PKs of t
                else
                    debug "\tno home for PK name" && text of nh && "of" && text2 of nh
                    quit
                end if
            end repeat
            Report ('\t(schemata::populate () - PK attribute names assigned)')
            
            -- foreign keys; we need table_name, name and foreign_table, and would like
            -- update_rule and delete_rule if available - but we might be connected to
            -- a pre-8.7 server, so use 'select *'.
            
            fill FKs with SQL \
                 'select * from indexes where foreign_table is not null'
            Report ('\t(schemata::populate () -' && getarraysize(FKs) && 'FKs fetched)')
            repeat with n=1 to getarraysize (FKs)
                set fkptr to object n of FKs
                set t to find_table (table_name of fkptr)
                if exists t then 
                    insert fkptr into FKs of t
                else
                    debug "\tno home for FK" && name of fkptr && "on" && table_name of fkptr
                    quit
                end if
            end repeat
            Report ('\t(schemata::populate () - FK names assigned)')
            
        end if
        
        -- tell table and view objects to get whatever extra info they need.
        -- We use 'send' to introduce some parallelism, and use 'counter' to
        -- keep track of when all have done their work - when it goes to zero
        -- we are ready to finish off.
        
        -- NOTE THAT the table objects in the tables array are in order of creation,
        -- so supeclasses will precede subclasses. Ww can rely on this when checking
        -- the hierarchy of classes.
        
        set n to 0
        foreach t in tables
            --Report ('\t(schemata::populate (): table' && name of t & ')')
            set schema_object of t to me
            check_hierarchy () of t
            
            -- mark tables to skip (which affects output, but not population)
            if skiptable (name of t) then
                set skip_me of t to true
                add 1 to n
            end if
            
            -- mark special tables (which affects appearance of generated html)
            set special of t to matchtablename (name of t, all_special_tables)

            if system of t then
                add_table (t) of base_tables
            else if special of t then
                add_table (t) of special_tables
            else
                add_table (t) of application_tables
            end if
            
            -- tell the table object to populate itself
            add 1 to counter
            if counter <= parallelops then
                send populate () to t
            else
                populate () of t
            end if
        end foreach
        Report ('    ' & getarraysize (tables) && 'tables in all (' & n && 'to be skipped)')

        set n to 0
        foreach t in domains
            --Report ('\t(schemata::populate (): table' && name of t & ')')
            set schema_object of t to me
            check_hierarchy () of t
            
            -- mark tables to skip (which affects sql output, but not population phase)
            if skiptable (name of t) then
                set skip_me of t to true
                add 1 to n
            end if
                        
            -- mark special tables (which affects appearance of generated html)
            set special of t to matchtablename (name of t, all_special_tables)

            -- tell the table object to populate itself
            add 1 to counter
            if counter <= parallelops then
                send populate () to t
            else
                populate () of t
            end if
        end foreach
        Report ('    ' & getarraysize (domains) && 'domains in all (' & n && 'to be skipped)')

        set n to 0
        foreach t in views
            set schema_object of t to me
        
            -- mark views to skip (which affects output, but not population)
            if skiptable (name of t) then
                set skip_me of t to true
                add 1 to n
            end if
            
            -- tell the table object to populate itself
            add 1 to counter
            if counter <= parallelops then
                send populate () to t
            else
                populate () of t
            end if
        end foreach
        Report ('    ' & getarraysize (views) && 'views in all (' & n && 'to be skipped)')  
 
        -- tell index operations to get whatever extra info they need;
        -- as with tables, we optionally introduce some parallelism
                     
        foreach i in indexes
            add 1 to counter
            if counter <= parallelops then
                send populate (me) to i
            else
                populate (me) of i
            end if
        end foreach
        Report ('    ' & getarraysize (indexes) && 'indexes')
        
        foreach i in FKindexes
            add 1 to counter
            if counter <= parallelops then
                send populate (me) to i
            else
                populate (me) of i
            end if
        end foreach
        Report ('    ' & getarraysize (FKindexes) && 'foreign key indexes')
        
        -- counter was originally set to one, to prevent premature
        -- triggering of the code to be executed when it gets back to
        -- zero. We now know, though, that (depending on parallelops
        -- setting) we have either done all the population we need to 
        -- do, or set off in the background all the work we will need
        -- to do, so we can safely decrement the counter and so (be
        -- be ready to) set off the 2nd stage of this application.
         
        subtract 1 from counter
    end populate
    
    on check_column_counts
        --
        -- only to be called after stage 1 is complete, will iterate
        -- over tables (and over columns of tables) to determine
        -- the count of columns that will be visible in queries
        -- including inherited columns, which is why we have to wait!);
        -- it will also set the columnnumber on each column.
        --
        local reference table t
        local integer i
        foreach t in tables
            set i to find_columncount () of t
        end foreach
        foreach t in views
            set i to find_columncount () of t
        end foreach
    end check_column_counts
    
    function boolean skiptable (string name)
        --
        -- return TRUE if the given name is to be skipped, which will depend 
        -- on the contents of tables_to_skip and tables_to_include (which
        -- themselves depend on the settings of the skip_tables and
        -- include_tables resources)
        --
        local string str
        local integer i
        local integer n
        --
        if tables_to_include <> '' then
            return not matchtablename (name, tables_to_include)
        else 
            return matchtablename (name, tables_to_skip)
        end if
    end skiptable
    
    function boolean matchtablename (string name, string pattern)
        --
        -- return TRUE if the given name is in the list of tables
        -- defined by the supplied pattern.
        --
        -- (note: a table name in the list may end in '*', representing
        -- a wild part - so we can't just use the 'in' operator! (though
        -- that might be a speedup in certain cases - however, the best
        -- solution is to use a dictionary)
        --
        local string str
        local integer i
        local integer n
        --
        repeat with i=1 to Numberofitems (pattern)
            set str to item i of pattern
            if name=str then return true
            set n to numberofchars (str) - 1
            if char (n+1) of str ='*' then
                if char 1 to n of name = char 1 to n of str then return true
            end if
        end repeat
    return false
    end matchtablename
    
    ------------------
    -- utility methods
    ------------------
    
    on report (string str)
        --
        debug interval (starttime) & "\t" & str
    end report
    
    on write_text_to_file (string filename, stringlist strlist, boolean decorate)
        --
        local integer        i
        local boolean        res = write_text_to_file (filename, decorate) of strlist
        --
        if res then 
            Report ("\tfile" && filename && "written;" && \
                    lines of strlist && 'lines,' && \
                    bytes of strlist && 'bytes long.')
        end if
    end write_text_to_file

    function table find_table (string name)
        --
        local reference table t = find_table (name) of all_tables
        if exists t then return t
        debug "application error: cannot find table, view or domain '" & name & "'"
        return t
    end find_table 
    
    function table find_domain (string name)
        --
        return find_table (name) of domain_list
    end find_domain 
    
    function table find_base_table (string name)
        --
        -- given a table name, return a pointer to its base table object.
        --
        local reference table t
        --debug '\tfind_base_table (' & name & ') called.'
        set t to find_table (name)
        repeat forever 
            if not exists t then return t
            if not exists derived_from of t then return t
        if derived_from of t = '' then return t
        set t to find_table (derived_from of t)
        end repeat
    end find_base_table
    
    ----------------------------------------------------------------
    -- the main work methods, that operate on the retrieved schema
    ----------------------------------------------------------------
    -- 
    -- Note that in most of these, the 'result' is a big string,
    -- which is then written to a file. 
    -- As we will be building up the string gradually, we need
    -- to avoid too much copying, otherwise we get into n-squared
    -- problems. To alleviate this effect, we 'chunk it up', 
    -- building an intermediate string (in a variable called str2)
    -- which is then appended to our main string variable (str) 
    -- whenever it gets too big. Still n-squared, but with a much
    -- smaller constant! (An alternative approach would be to use a
    -- array of objects with a string attribute, and then pass a
    -- pointer to the array to the method that writes it to a file;
    -- one day, maybe - if the current approach takes too long for
    -- 'real-life' customer databases.)
    --
    ----------------------------------------------------------------
    
    on  check_names
        --
        -- look at the names of tables, attributes, etc to see
        -- if any clash with SQL or CL reserved words, and thus
        -- might cause future problems for the database owner.
        --
        local reference table t
        local integer   fail = 0
        --
        Report ('    Check names of tables and attributes.')

        foreach t in tables
            add check_names () of t to fail
        end foreach
        foreach t in views
            add check_names () of t to fail
        end foreach
        if fail>0 then
            Report ('\t' & fail && 'problems found.\n')
        else
            Report ('\tno problems found.\n')
        end if
    end check_names

    ----------------------------------------------------------------
    
    on  print_schema
        --
        -- build up a (potentially huge!) string containing the SQL
        -- needed to recreate the schema, and write it out to file.
        --
        local reference table t
        local reference view  v
        local reference index i
        local datetime        stagetime = now ()
        local stringlist      strlist
        --
        Report ('    Schema file generation...')
        
        record ('-- schema dump created using the Polyhedra schema scanner,' && \
                '$Revision: 1.6 $\n\n' & comment_bar ('tables and domains') & \
                '\ncreate schema\n\n') of strlist
        
        foreach t in domains
            record (sql_for_table ('') of t & '\n\n') of strlist
        end foreach
        
        foreach t in tables
            record (sql_for_table ('') of t & '\n\n') of strlist
        end foreach
        record ('; -- end of domain and table definitions\n\n') of strlist
                
        if exists object 1 of views then 
            record (comment_bar ('views') & '\n') of strlist
        end if
        foreach v in views
            record (sql_for_table ('') of v & '\n\n') of strlist
        end foreach
        
        if exists object 1 of indexes then
            record (comment_bar ('indexes') & '\n') of strlist
        end if
        foreach i in indexes
            record (sql_for_index () of i & '\n\n') of strlist
        end foreach
       
        -- generate a summary.
        
        record (comment_bar ('summary')                                               &  \
                '\n-- PLEASE NOTE:'                                                   &  \
                '\n--  * Security information not included.'                          &  \
                '\n--  * Accuracy not warranted.'                                     &  \
                '\n-- Statistics:'                                                    &  \
                '\n--   info gather time was' && timetaken (preptime)                 &  \
                '\n--   sql preparation time was' && timetaken (stagetime)            &  \
                '\n--   schema has' && getarraysize (tables) && 'tables,'             && \
                        getarraysize (domains) && 'domains,'                          && \
                        getarraysize (views) && 'views and'                           && \
                        getarraysize (indexes) && 'indexes.\n\n'                         \
               ) of strlist
         
        write_text_to_file (stub&'schema.sql', strlist, true)

        Report ('\tSchema file generation took' && timetaken (stagetime) & '\n')
    end print_schema
    
    ----------------------------------------------------------------

    on  print_html
        --
        -- build up a (potentially huge!) string containing HTML
        -- describing the schema, and write it out to file.
        --
        local reference table t
        local reference view  v
        local reference index i
        local stringlist      strlist
        local datetime        stagetime = now ()
        local integer         j
        local string          table_summary_header = '<tr><th>name<th>persistence<th>derived from<th>columns\n'
        local string          top = '<p align="right"><font size="-2"><a href="#top">(top)</a></font>\n'
        --
        Report ('    HTML generation...')
        
        record ('<html><head><title>' & stub & '_schema </title></head>\n'          &  \
                '<body>\n<h3 align=center><a name="top">Database Schema</a></h3>\n' &  \
                'Contents:<ul>\n'                                                   &  \
                '  <li><a href="#Tables"       >Table summary</a>\n  <ul>'          &  \
                '    <li><a href="#System"       >System tables</a>\n'              &  \
                '    <li><a href="#Special"      >Special tables</a>\n'             &  \
                '    <li><a href="#Apps"         >Application tables</a>\n\n'       &  \
                '    <li><a href="#Hierarchy"    >Table hierarchy</a>\n  </ul>\n'   &  \
                '  <li><a href="#Domains"      >Domains</a>\n'                      &  \
                '  <li><a href="#Views"        >Views</a>\n'                        &  \
                '  <li><a href="#Indexes"      >Indexes</a>\n'                      &  \
                '  <li><a href="#Table_details">Detailed table descriptions</a>\n'  &  \
                '</ul><hr><h3><a name="tables">Table summary</a></h3>\n\n'          &  \
                '<h4><a name="System">System tables</a></h4>\n'                     &  \
                '(these read-only tables allow the schema to be inspected via SQL)\n<p>'& \
                standard_table & table_summary_header                                  \
               ) of strlist
                    
        foreach t in tables of base_tables
            record (html_summary_for_table () of t & '\n\n') of strlist
        end foreach
            
        record ('</table>\n' & top & '\n<h4><a name="Special">Special tables</a></h4>\n' & \
                '(tables used by submodules of the rtrdb - '                             & \
                'the CL engine, the DVI, Historian, etc)\n<p>'                           & \
                standard_table  & table_summary_header) of strlist

        foreach t in tables of special_tables
            record (html_summary_for_table () of t & '\n\n') of strlist
        end foreach
            
        record ('</table>\n' & top & '<h4><a name="Apps">Application tables</a></h4>\n' & \
                '(in alphabetical order)\n<p>' & \
                standard_table & table_summary_header) of strlist

        foreach t in tables of Application_tables
            record (html_summary_for_table () of t & '\n\n') of strlist
        end foreach
                    
        record ('</table>\n' & top & '\n<h4><a name="Hierarchy">Table hierarchy</a></h4>\n' & \
                standard_table) of strlist
                    
        foreach t in tables of base_tables
            if depth of t = 0 then
                record ('<tr>' & html_subclass_structure_for_table (max_depth, false, true, "") of t & '</tr>\n') of strlist
            end if
        end foreach
        foreach t in tables of special_tables
            if depth of t = 0 then
                record ('<tr>' & html_subclass_structure_for_table (max_depth, false, true, "") of t & '\n\n') of strlist
            end if
        end foreach
        foreach t in tables of application_tables
            if depth of t = 0 then
                record ('<tr>' & html_subclass_structure_for_table (max_depth, false, true, "") of t & '\n\n') of strlist
            end if
        end foreach
      
        record ('</table>\n' & top & '\n<hr><h3><a name="Domains">Domains</a></h3>\n\n') of strlist
                
        if not exists object 1 of domains then 
            record ('<i>(No domains have been defined in this database.)</i>\n') of strlist
        else
            record (standard_table & table_summary_header) of strlist
            foreach t in domains
                record (html_summary_for_table () of t & '\n\n') of strlist
            end foreach
            record ('\n</table>\n') of strlist
        end if   
        
        record (top & '\n<hr><h3><a name="Views">Views</a></h3>\n\n') of strlist
                
        if not exists object 1 of views then 
            record ('<i>(No views have been defined in this database.)</i>\n') of strlist
        else
            record (standard_table) of strlist
            foreach v in views
                record (html_for_view () of v & '\n\n') of strlist
            end foreach
            record ('</table>\n') of strlist
        end if   
        
        record (top & '\n<hr>\n<h3><a name="Indexes">Indexes</a></h3>\n\n') of strlist
            
        if not exists object 1 of indexes then
             record ('<i>(No additional indexes have been defined in this database.)</i>\n') of strlist
        else
            record (standard_table & '<tr><th>name<th>table<th>columns<th>ordered?<th>unique?\n') of strlist
            foreach i in indexes
                record (html_for_index () of i & '\n\n') of strlist
            end foreach
            record ('\n</table>') of strlist
        end if
       
        record (top & \
                '\n<hr>\n<h3><a name="Table_details">Table Details</a></h3>\n\n' &  \
                'Domains are listed in order of definition, and then'            && \
                'similarly for tables - so derived tables'                       && \
                'will come somewhere after the tables from which the are'        && \
                'derived. Each table description is laid out in a tabular'       && \
                'fashion, with the "banner row" containing a list of'            && \
                'superclasses (if any), then the name of the table. In the'      && \
                'case of derived tables, the description will indicate not'      && \
                'just the columns added in the table definition, but also'       && \
                'the inherited columns.\n<p>'                                       \
               ) of strlist

        if single_table_for_table_details then
            record (standard_table) of strlist
            foreach t in domains
               if not skip_me of t then record (html_for_table () of t & '<tr><td colspan="8">' & top & '</tr>\n') of strlist
            end foreach
            foreach t in tables
               if not skip_me of t then record (html_for_table () of t & '<tr><td colspan="8">' & top & '</tr>\n') of strlist
            end foreach
            record ('\n</table>\n') of strlist
        else
            foreach t in domains
                if not skip_me of t then 
                    record (standard_table & \
                            html_for_table () of t & '</table>\n' & top & '\n\n') of strlist
                end if
            end foreach
            foreach t in tables
                if not skip_me of t then 
                    record (standard_table & \
                            html_for_table () of t & '</table>\n' & top & '\n\n') of strlist
                end if
            end foreach
        end if
        
        record ('\n\n<br><hr>\n<i>File' && stub & 'schema.htm created on'                    && \
                (item (1+The_weekday(starttime)) of 'Sun,Mon,Tue,Wed,Thu,Fri,Sat')           &  \
                ',' && get_DateTimef (starttime, '%02d %03M %04y %02h:%02i:%02s GMT')        && \
                'using $Revision: 1.6 $ of the Polyhedra schema scanner.</i>\n\n'            &  \
                '\n<p><i>PLEASE NOTE:</i><ul>'                                               &  \
                '\n<li><i>Security information not included.</i>'                            &  \
                '\n<li><i>Accuracy not warranted.</i>\n</ul>'                                &  \
                '\n<i>Statistics:</i><ul>\n<li><i>info gather time was' && timetaken (preptime) & '</i>' &  \
                '\n<li><i>html preparation time was' && timetaken (stagetime) & '</i>'       &  \
                '\n<li><i>schema has' && getarraysize (tables) && 'tables,'                  && \
                                      getarraysize (domains) && 'domains,'                   && \
                                      getarraysize (views) && 'views and'                    && \
                                      getarraysize (indexes) && 'indexes.</i></ul>'          &  \
                '<hr>\n</body>\n</html>\n') of strlist

        write_text_to_file (stub & 'schema.htm', strlist, false)
        
        Report ('\tHTML generation took' && timetaken (stagetime) & '\n')
    end print_html 

---------
end class
---------


-------------------------------------------------------------------------------
--                        E n d   o f   f i l e
-------------------------------------------------------------------------------
