-------------------------------------------------------------------------------
--           P O L Y H E D R A    D E M O
--           Copyright (C) 2005-2014 Enea Software AB
-------------------------------------------------------------------------------
--    Filename      : readme.txt
--    Description   : description of inspect.
--    Author        : Nigel Day
--
--    CVSID         : $Id: readme.txt,v 1.4 2014/07/23 16:37:28 nigel Exp $
-------------------------------------------------------------------------------
-- NOTE: this is ILLUSTRATIVE CODE, provided on an 'as is' basis to help
-- demonstrate one or more features of the Polyhedra product. 
-- It may well need adaption for use in a live installation, and
-- Enea Software AB and its agents and distributors do not warrant this code.
-------------------------------------------------------------------------------

This directory contains code to dump the schema of a Polyhedra-based database,
and also to produce an HTML file that describes the database.

This file describes how to run the application, and some of the limitations.

-------------------
RESTRICTIONS ON USE
-------------------

Feel free to make any changes to inspector.cl to better meet your needs, 
but we assert our rights in the IPR of the original code. We would be grateful 
if you were to feedback such changes to us (via the Polyhedra helpdesk) so they 
can be considered for incorporation into the released version. Please also
supply some documentation, and an acknowledgement that the IPR of such changes
is being passed over to us. Please do not distribute this code or modified
versions of it.

As stated in the header at the start of this document, this code is provided
on an 'as is' basis, and is not covered by any warranty. However, if you do have
questions or problems, you can contact the Polyhedra helpdesk for limited
assistance.

-----------------
RUNNING SEQUENCE:
-----------------

schema dump.
------------

First start the database you want to inspect, in the normal way.  Then, 
to produce a schema dump, switch to this directory, and issue the command:

	clc dumpschema

(This entry point defines the dump_schema resource to true, enabling this 
functionality; alternatively you can use one of the other clc-related entry
points defined in poly.cfg, and use this resource to control whether this 
functionality is to be enabled.)
	
If the database service is not running locally on port 8001 (the default 
for most of the example databases we supply), you will have to alter 
poly.cfg or pass across the service access point via the command line, eg: 

	clc -r data_service=192.168.1.13:8001 schemadump
	
By default, the schema will be written to the file db_schema.sql, but the
db_ prefix can be changes by specifying a 'stub' resource. So to 
create a dump of the 8001 database to poly_schema.sql, issue the command: 

	clc -r stub=poly_ schemadump
	
...  or to dump another database, you can use -r twice, to specify both 
the database and the stub for the output file: 

	clc -r stub=poly_ -r data_service=192.168.1.13:8001 schemadump

Note that the program will omit various special tables, such as those 
automatically created if not present when the database server starts.  To 
stop this behaviour, set the resource skip_tables to, say, N or a dash: 

	clc -r skip_tables=N schemadump

skip_tables can be a comma-separated list of table names, all in lower case.  
As the names of tables are held in lower case in the database and cannot 
start with a dash, N and - will not match any tables.  If one of the 
supplied names ends in an asterisk, the asterisk is treated as a wild card 
- so dvi_* will match (and cause to be skipped) all tables starting dvi_, 
and the pattern * by itself causes all tables to be omitted! If skip_tables 
starts with a plus sign '+' then the names you supply after the + are added 
to the standard line of tables to skip, rather than replacing them.

html output
-----------

This is similar to the above, except you should use the entry point html 
rather than schemadump

name checking.
--------------

This application can also be used to check the names used for tables and 
for table attributes, to check there is no clash with SQL or CL keywords
that might cause problems (now or in the future). It is also possible to 
provide an additional list of words - so, for example, if you have been 
told that a new release of Polyhedra will introduce additional CL or SQL
keywords you can check your existing schema to get a 'heads-up' warning.

This name-checking functionality can be performed by starting the target 
database as defined above, and issuing the following command

   clc checknames

(This entry point defines the check_names resource to true, enabling this 
functionality; alternatively you can use one of the other clc-related entry
points defined in poly.cfg, and use this resource to control whether this 
functionality is to be enabled.)

(the resource 'check_nonreserved_words' can be used to include a check
against all the non-reserved words in SQL 2003; as these words can be
recognised by context they are legal as table names & column names, but
avoiding them may be sensible.)

The results are reported via the CL 'debug' statement, and will be routed 
to stdout rather than to a file.

all three
---------

If you use the entry point 'inspect', as in the command

    clc inspect

Then the application will check the names, and produce both an SQL file and 
an HTML file. Extra resources such as stub, skip_tables etc can be used as
described above (and below).

fine-tuning output
------------------

the resources skip_tables and include_tables control the output that is 
produced. if neither is specified then the built-in an standard tables are
skipped, and output it restricted to information about the user tables.
If include_tables is specified output is restricted to tables that are
mentioned in the comma-separated list; if an item in the list ends with an
asterisk, then that part of the name is treated as a wild card.
If include_tables is not specified, skip_tables can be used to replace
the standard list of tables to skip - or to add to it, if the first
character of the resource is a plus sign.

the stub resource controls the prefix that is added to table names, etc 
in the generated c code; the default is 'db_'. This allows different names
to be associated with different schema.

------------ 
LIMITATIONS:
------------ 

as stated above, this code is unwarranted: as with all the examples, they 
are provided for illustrative purposes only.  Also, in this example, there 
are two known limitations in the generated schema: 

* security.  no attempt is made to record any security information that 
may be in the database.  Polyhedra has a user-based security mechanism 
that is activated by the presence of a 'users' table; each table and view 
will have an owner, and it is possible to grant and revoke access to 
tables, views down to the granularity of a column.  (Also, the security on 
a view does not have to match the security on the underlying tables.) The 
output from this example will include SQL to create the users table if 
present in the database being inspected, but it does not attempt to 
populate this table or to mimic the security permissions.  This demo 
application will produce odd results if security is enabled and the user 
running this application does not have sufficient security privileges to 
read the schema pseudo-tables ('tables', 'attributes', etc).  

* shared and virtual attributes.  Prior to Polyhedra 8.6, information about
the virtual or shared status of table attributes wass not made visible 
through the schema pseudo-tables.  If inspecting a database that is being run 
using an earlier version of Polyhedra, you will need to upgrade to a more 
recent version.

------ FILES: ------ 

inspector.cl  -- the code for the demo  
globals.cl    -- some general-purpose CL constants and global functions
poly.cfg	  -- config file for this demo
readme.txt	  -- this file, describing the demo
tables.sql	  -- example schema that can be used as a test

-------------------------------------------------------------------------------
--                        E n d   o f   f i l e
-------------------------------------------------------------------------------
