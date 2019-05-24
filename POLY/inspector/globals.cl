-------------------------------------------------------------------------------
--			 P O L Y H E D R A    D E M O
--	 	     Copyright (C) 2005-2014 Enea Software AB
-------------------------------------------------------------------------------
-- 	Filename      : globals.cl
-- 	Description   : some useful global functions, for use in RTRDB, CLC
-- 	Author        : Nigel Day
--
--      CVSID         : $Id: globals.cl,v 1.1 2014/07/23 16:37:28 nigel Exp $
-------------------------------------------------------------------------------
-- NOTE: this is ILLUSTRATIVE CODE, provided on an 'as is' basis to help
-- demonstrate one or more features of the Polyhedra product.
-- It may well need adaption for use in a live installation, and
-- Enea Software AB and its agents and distributors do not warrant this code.
-------------------------------------------------------------------------------
-- this file contains various constants and global functions intended to be of
-- use in a wide variety of applications. It should only contain code that is 
-- executable-independent: that is, it should work with both the RTRDB and CLC
-- executables.
--
-- functions defined here include:
--
--  function Boolean  GetBoolDefault        (string res, boolean def)
--  function integer  GetIntDefault         (string res, integer def)
--  function String   GetDefault            (string res, string def)
--  function string   NumberToDottedIPAddress (string s)
--  function integer  DottedIPAddressToNumber (string s)
--  function string   LookUpHostName        (integer addr)
--  function datetime StringToDateTime      (string d)
--  function string   httpDate              (datetime d)
--  function string   httpNow               ()
--  function string   HowLong               (datetime dt, integer n)
--  function integer  HexStringToNum        (string str)
--  function string   MatchString           (string str, string matchstr)
--  function integer  FindStringInString    (string haystack, string needle)
--  function integer  SwapBytes             (integer n)
--  function integer  SwapBytes16           (integer n, boolean unsigned)
--  function string   Base64Encode          (binary inputstream)
--  function binary   Base64Decode          (string encoded_string)
--  function string   StripExcessWhitespace (string arg)
--  function string   Decimals              (real r, integer n)
--  function string   RightJustify          (string str, integer n)
-------------------------------------------------------------------------------

--------------------
-- useful constants:
--------------------

constant string   asterisk      = "*"
constant binary   EmptyBinary       = HexStringToBinary ("")
constant datetime unix_year_0       = date ("01-JAN-1970")
constant datetime zerointerval      = seconds (0)
constant string   rfc1123_date      = "%02d %03M %04y %02h:%02i:%02s"
constant string   rfc1036_date      = "%02d-%03M-%02Y %02h:%02i:%02s"
constant string   asctime_date      = "%03M-%2d %02h:%02i:%02s %04y"
constant string   constant_crlf     = "\r\n"

constant boolean ForceNumericHostnames  = GetBoolDefault ("ForceNumericHostnames", true)

---------------------------------------------------------------------------
-- some constants that can be used with the CL DEBUG statement to control
-- the volume of output. The idea is to have a line like 
--
-- verbosity = 1
--
-- (without the -- at the front) in a suitable point in your poly.cfg file,
-- and have lines like 
--
-- if verbose then debug ...
--
-- in your CL methods; by setting verbosity to a higher value, more output
-- is produced. 
---------------------------------------------------------------------------

constant string  VerbosityLevels    = \
          "logging,verbose,reallyverbose,extremelyverbose,reporteverything"
constant integer Verbosity          = GetVerbosity ()
constant boolean reporteverything   = ( verbosity >=5 )
constant boolean extremelyverbose   = ( verbosity >=4 )
constant boolean reallyverbose      = ( verbosity >=3 )
constant boolean verbose            = ( verbosity >=2 )
constant boolean logging            = ( verbosity >=1 )

-----------------------------
function integer GetVerbosity
-----------------------------
    --
    local integer v =  GetIntDefault ("Verbosity", 3)
    if v > 0 then
        debug "Verbosity level for reporting is" && v && \
            "(" & (item v of VerbosityLevels) & ")"
    end if
    return v

----------------
end GetVerbosity
----------------

-------------------------------------------------------------------------------
--  r e a d   r e s o u r c e   v a l u e s ,   w i t h   d e f a u l t s
-------------------------------------------------------------------------------

--------------------------------------------------------
function Boolean GetBoolDefault(string res, Boolean def)
--------------------------------------------------------
-- look for a resource of a given name, and return TRUE
-- if it holds a suitable value; if the resurce cannot
-- be found, return the supplied default value.
--------------------------------------------------------
    local string s
    set s to GetResource(res)
    if s <> "" then
        set s to uppercase(s)
        if s = "YES" or s = "Y" or s = "TRUE" or s = "ON" then 
            return true
        else
            return false
        end if
    else
        return def
    end if
------------------
end GetBoolDefault
------------------

-------------------------------------------------------
function integer GetIntDefault(string res, integer def)
-------------------------------------------------------
-- look for a resource of a given name, and (if found)
-- return its value as an integer. If it can't be found,
-- return the supplied default.
--------------------------------------------------------
    local string s
    set s to GetResource(res)
    if s <> "" then
        return chartonum(s)
    else
        return def
    end if
-----------------
end GetIntDefault
-----------------

--------------------------------------------------------------
function String GetDefault(String Resource, String TheDefault)
--------------------------------------------------------------
--  Generic Handler for allowing the use of resources but 
--  ensuring the definition of a default.
--------------------------------------------------------------
    Local String Temp = ""

    if Resource = "" then
        if TheDefault <> "" then
            return TheDefault
        else
            debug "Resource and Default Null"
            return ""
        end if
    else
        Set Temp to GetResource(Resource)
        if Temp <> "" then
            return Temp
        else
            return TheDefault
        end if
    end if
--------------
end GetDefault
--------------

-------------------------------------------------------------------------------
--  I P   a d d r e s s   t r a n s l a t i o n
-------------------------------------------------------------------------------

----------------------------------------------------
function string NumberToDottedIPAddress (string s)
-----------------------------------------------------
-- given a string holding a number,
-- convert it to the equivalent IP dotted address
-----------------------------------------------------
    local integer n  = CharToNum (s)
    local string  res

    set res to  bitAnd (255, bitShiftRight (n, 24)) & "." & \
            bitAnd (255, bitShiftRight (n, 16)) & "." & \
            bitAnd (255, bitShiftRight (n,  8)) & "." & \
            bitAnd (255, n)
    --debug "NumberToDottedIPAddress (" & s & ") =" && res
    return res
---------------------------
end NumberToDottedIPAddress
---------------------------

---------------------------------------------------
function integer DottedIPAddressToNumber (string s)
---------------------------------------------------
-- given a string holding a IP dotted address,
-- convert it to the equivalent number
---------------------------------------------------
-- NB this code is very lazy, has NO error checking 
-- other than for too many dots.
---------------------------------------------------
    local string  c
    local string  d   = ""
    local integer i   = 1
    local integer j   = 0
    local integer n   = 0
    local integer res = 0

    set s to s & "." -- allow lazy coding

    repeat with i=1 to NumberOfChars (s)
        set c to char i of s
        if c = "." then
            set res to BitOr (res, BitShiftLeft (n, 24-j*8))
            add 1 to j
            if j=4 then exit repeat
            set n to 0
        else
            set n to n * 10 + CharToNum (c)
        end if
    end repeat

    --debug "DottedIPAddressToNumber (" & s & ") =" && res
    return res
---------------------------
end DottedIPAddressToNumber
---------------------------

---------------------------------------------
function string LookUpHostName (integer addr)
---------------------------------------------
-- find the host name; uses the poly.cfg-rable
-- constant ForceNumericHostnames to decide
-- whether to do a GetHostName (which blocks
-- the process, possibly for some time).
---------------------------------------------
    local string hn = ""
    if not ForceNumericHostnames then set hn to GetHostName (addr)
    if hn = "" then
        set hn to NumberToDottedIPAddress (addr)
        if hn="127.0.0.1" then set hn to "localhost"
    end if
    return hn
------------------
end LookUpHostName
------------------

-------------------------------------------------------------------------------
--  D a t e T i m e   f u n c t i o n s
-------------------------------------------------------------------------------

---------------------------------------------
function datetime StringToDateTime (string d)
---------------------------------------------
-- given a string the - one hopes - has a
-- representation of a date, try translating
-- it. Allow RFC 1123, RFC 1036 or C asctime
-- formats (ignoring the day name field in
-- each case).
---------------------------------------------

    local datetime dt = datetime (d)
    if IsvalidDateTime (dt) then return dt

    -- we will have to try a bit harder to translate the supplied arg.

    --debug "StringToDateTime (" & d & ")"

    if NumberOfItems (d) > 1 then 
        set d to item 2 of d
        if char 1 of d = " " then set d to char 2 to 999 of d
    end if

    set dt to datetime (d)
    if IsvalidDateTime (dt) then return dt

    set dt to datetimef (d, rfc1123_date)
    if IsvalidDateTime (dt) then return dt

    set dt to datetimef (d, rfc1036_date)
    if IsvalidDateTime (dt) then return dt

    set dt to datetimef (d, rfc1036_date)
    if IsvalidDateTime (dt) then return dt

    return seconds (0)
--------------------
end StringToDateTime
--------------------

--------------------------------------
function string httpDate (datetime d)
--------------------------------------
-- convert a datetime to the canonical
-- http format, for example...
--  Tue, 29 Apr 97 10:14:05 GMT
--------------------------------------
    return (item (1+The_weekday(d)) of "Sun,Mon,Tue,Wed,Thu,Fri,Sat") & \
        "," && get_DateTimef (d, "%02d %03M %04y %02h:%02i:%02s GMT")
------------
end httpDate
------------

----------------------------------------
function string httpNow
----------------------------------------
-- convert the datetime to the canonical
-- http format, for example...
--  Tue, 29 Apr 97 10:14:05 GMT
----------------------------------------
    return httpDate (now ())
-----------
end httpNow
-----------

------------------------------------------------
function string HowLong (datetime dt, integer n)
------------------------------------------------
-- return a string indicating how long ago was
-- the supplied datetime; if n is non-zero, the
-- result also indicates how many operations per
-- second were done if n is the number of ops.
-- useful in code doing timing tests!
------------------------------------------------
    local real   secs = to_microseconds (now()-dt) / 1000000
    local string str  = Decimals (secs, 3) && "seconds"

    if n > 0 then
        set str to str && \
            "(" & truncate (n / secs) && "ops per sec," && \
            Decimals (secs / n, 6) && "secs per op)"
    end if
    return str
-----------
end HowLong
-----------


-----------------------------------------------------------
function integer calculate_rate (datetime diff, integer ct)
-----------------------------------------------------------
-- return a rate, given an interval and the number of
-- operations in that interval
-----------------------------------------------------------
    local real interval = to_seconds (diff) + the_microsecond (diff) / 1000000
    return truncate (ct / interval)
------------------
end calculate_rate
------------------

-------------------------------------------------------------------------------
--  i n t e g e r   a n d   s t r i n g   m a n i p u l a t i o n
-------------------------------------------------------------------------------

--------------------------------------------
function integer HexStringToNum (string str)
--------------------------------------------
-- given a hex char string, yield the
-- corresponding number; assume it will fit.
--------------------------------------------
    local integer n = 0
    local integer i
    local integer j
    local string  hexdigit

    repeat with i=1 to NumberOfChars (str)
        set hexdigit to lowercase (char i of str)
        if HexDigit = "a" then
            set j to 10
        else if HexDigit = "b" then
            set j to 11
        else if HexDigit = "c" then
            set j to 12
        else if HexDigit = "d" then
            set j to 13
        else if HexDigit = "e" then
            set j to 14
        else if HexDigit = "f" then
            set j to 15
        else
            set j to CharToNum (HexDigit)
        end if
        set n to n * 16 + j
    end repeat

    return n
------------------
end HexStringToNum
------------------

---------------------------------------------------------
function string MatchString (string str, string matchstr)
---------------------------------------------------------
-- check if string str matches matchstr, where the latter
-- may contain an asterisk. If a match, return the 
-- 'wild bit'; if no match, return the asterisk string.
---------------------------------------------------------
    local integer m = NumberOfChars (str)
    local integer n = NumberOfChars (matchstr)
    local integer i = 0
    local integer j = n
    local integer k

    if m < n-1 then return asterisk -- str not long enough.

    if asterisk in matchstr then
        if n=1 then return true
        -- find the asterisk...
        while i+1 < j
            set k to (i+1+j) div 2
            if asterisk in char (i+1) to k of matchstr then
                set j to k
            else
                set i to k
            end if 
        end while
        if i>0 then
            if char 1 to i of str <> char 1 to i of matchstr then
                return asterisk
            end if
        end if
        if j+1 < n then
            if char (j+1+m-n) to m of str <> char (j+1) to n of matchstr then
                return asterisk
            end if
        end if
        if m=n-1 then
            return ""
        else
            return char j to (j+m-n) of str
        end if
    else
        if str=matchstr then
            return ""
        else
            return asterisk
        end if
    end if
---------------
end MatchString
---------------

--------------------------------------------------------------------
function integer FindStringInString (string haystack, string needle)
--------------------------------------------------------------------
-- find the first occurence of one string inside the other,
-- returning the position of the first character (or zero, if not
-- found).
--------------------------------------------------------------------
    local binary h = SetStrInBinary (EmptyBinary, 0, haystack, false)
    local binary n = SetStrInBinary (EmptyBinary, 0, needle, false)

    -- early versions of the FindBinInBinary function returned an
    -- erroneous result if the needle was bigger than the haystack.
    if NumberOfChars (haystack) < NumberOfChars (needle) then return 0

    return 1 + FindBinInBinary (h, n)
----------------------
end FindStringInString
----------------------

--------------------------------------
function integer SwapBytes (integer n)
--------------------------------------
-- given a 32-bit integer, return the
-- value obtained by swapping byte 1 
-- with byte 4 and byte 2 with byte 3
-- (eg, correct an endianism problem).
--------------------------------------
    return BitOr ( BitShiftLeft (n, 24)         \
             , BitShiftLeft (BitAnd (65280, n), 8)  \
             , BitAnd (65280, BitShiftRight (n, 8)) \
             , BitShiftRight (n, 24)            \
             )
-------------
end SwapBytes
-------------

----------------------------------------------------------
function integer SwapBytes16 (integer n, boolean unsigned)
----------------------------------------------------------
-- given a 16-bit integer, return the value obtained by
-- swapping the bottom two bytes, ignoring the other bytes
-- and extending the sign if unsigned is false.
----------------------------------------------------------
    local integer res =                     \
        BitOr( BitShiftLeft (BitAnd (255, n), 8)    \
             , BitAnd (255, BitShiftRight (n, 8))   \
             )
    if unsigned then
        return res
    else
        return BitAnd (-1, res)
    end if
---------------
end SwapBytes16
---------------

constant string Base64Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

-------------------------------------------------
function string Base64Encode (binary inputstream)
-------------------------------------------------
-- given a binary input stream, return a 
-- corresponding text string using Base64
-- encoding.
-------------------------------------------------

    local binary stream
    local string encoded_output
    local string encoded_char
    local integer no_of_24bitchunks
    local integer byte_number
    local integer remainder
    local integer code_value = 0    
    local integer bit_index = 0
    local integer i
    local integer no_of_6bitchunks
    local integer padding_line

    set stream to inputstream
    set byte_number to NumberOfBytes(inputstream)
    set padding_line to byte_number * 8
    set no_of_24bitchunks to (byte_number div 3)
    set remainder to (byte_number mod 3)

    --Perform padding
    if remainder=1 then

       set stream to setStrInBinary(stream,   \
             (byte_number + 2),       \
             "rubbish",           \
             false)                    
       add 1 to no_of_24bitchunks
    
    else if remainder=2 then

       set stream to setStrInBinary(stream, \
             (byte_number + 1), \
             "rubbish",     \
             false)                    
       add 1 to no_of_24bitchunks       
    end if

    set no_of_6bitchunks to no_of_24bitchunks * 4 

    repeat while no_of_6bitchunks>0
            
       set code_value to 0
            
       if bit_index >= padding_line then

          set encoded_output to encoded_output & "="
            
       else

          set i to 5
          repeat while i>=0
        if getBitInBinary(stream, bit_index) then
           set code_value to code_value + (2^i)
        end if
        add 1 to bit_index
        subtract 1 from i
          end repeat
          set encoded_char to char (code_value+1) of Base64Alphabet
          set encoded_output to encoded_output & encoded_char           
       end if

       subtract 1 from no_of_6bitchunks
    end repeat
        
    return encoded_output

----------------            
end Base64Encode
----------------

----------------------------------------------------
function binary Base64Decode (string encoded_string)
----------------------------------------------------
-- given a Base64 encoded text string, return
-- a corresponding decoded binary stream.
----------------------------------------------------

    local integer char_index
    local integer character_value
    local integer bit_index = 0
    local integer i
    local string  encoded_char
    local integer encoded_number
    local binary  decoded_stream


    set char_index to 1
    
    set encoded_char to char (char_index) of encoded_string

    repeat while encoded_char <> "="
        
       set character_value to 0
       repeat while char (character_value+1) of Base64Alphabet <> encoded_char
          add 1 to character_value
          if character_value>62 then
        debug ""
        debug "\n\nError: Encoded character does not exist in the Base64 Alphabet.\n"
        debug ""
        exit repeat 
          end if
       end repeat
    
       if character_value>62 then
          exit repeat 
       end if

       set i to 5

       -- The following section, responsible for translating individual
       -- Base64 encoded characters into 6-bit binary numbers, is not
       -- efficient enough when a large amount of data needs to be decoded.
       -- Some re-engineering will be required to make it run faster.

       repeat while i>=0
          if (2^i) <= character_value then
             set decoded_stream to setBitInBinary(decoded_stream, bit_index, true)
         subtract (2^i) from character_value
          else
         set decoded_stream to setBitInBinary(decoded_stream, bit_index, false)
          end if    
          add 1 to bit_index
          subtract 1 from i
       end repeat

       add 1 to char_index
       set encoded_char to char (char_index) of encoded_string
    end repeat
        
    return decoded_stream

----------------    
end Base64Decode
----------------

--------------------------------------------------
function string StripExcessWhitespace (string arg)
--------------------------------------------------
-- strips away excessive white spaces at the 
-- beginning and at the end of a given string 
--------------------------------------------------

    local integer   char_count
    local string    stripped_arg

    set stripped_arg to arg

    repeat while ((char 1 of stripped_arg = '\n') or \
              (char 1 of stripped_arg = '\t') or \
                  (char 1 of stripped_arg = '\r'))

       set stripped_arg to char 2 to 999 of stripped_arg

    end repeat  

    set char_count to numberofchars(stripped_arg)

    repeat while ((char char_count of stripped_arg = '\n') or \
              (char char_count of stripped_arg = '\t') or \
                  (char char_count of stripped_arg = '\r'))

       set stripped_arg to char 1 to (char_count-1) of stripped_arg
       set char_count to numberofchars(stripped_arg)

    end repeat  
    
    return stripped_arg

-------------------------
end StripExcessWhitespace
-------------------------

--------------------------------------------
function string Decimals (real r, integer n)
--------------------------------------------
-- return a string representing the given
-- real to n decimal places.
--------------------------------------------
    local integer whole
    local integer scale
    local integer fraction
    local string  zeros    = "0000000000" -- ten zeros, initially
    local string  trailing = ""

    -- cope with -ve numbers!
    if r < 0 then return "-" & Decimals (-r, n)

    -- cope with unexpected values for n
    if n <=0 then

        return round (r)

    else if n >10 then

        -- we are going via an integer to deal with the fractional
        -- part, so ensure that we dont try to store something too
        -- big in it; reduce n to be at most 10, and put the right
        -- number of zeros in 'trailing' to right-pad the number.

        set trailing to zeros
        -- keep doubling up until it is at least long enough...
        while NumberOfChars (trailing) < n-10
            set trailing to trailing & trailing
        end while
        -- ... and then throw away the surplus.
        set trailing to char 1 to (n-10) of trailing
        set n to 10

    end if

    set whole    to truncate (r)
    set scale    to 10^n
    set fraction to round ((r - whole) * scale)

    if fraction >= scale then

        -- once rounded to n digits, the fraction might overflow;
        -- for example, we want to represent Decimals (1.999, 2) by
        -- the string "2.00", not "1.00" or "1.100"!

        add 1 to whole
        set fraction to 0

    end if

    set zeros to char 1 to (n - NumberOfChars(fraction)) of zeros
    return whole & "." & zeros & fraction & trailing
------------
end Decimals
------------

----------------------------------------------------------------
function string LeftPad (string str, integer n, string padding)
----------------------------------------------------------------
-- return a string left-padded with enough of the supplied
-- string to ensure its length is at least n characters.
----------------------------------------------------------------
    local integer len    = NumberOfChars (str)

    subtract len from n
    if n <= 0 then return str

    while NumberOfChars (padding) < n
        set padding to padding & padding
    end while
    return (char 1 to n of padding) & str 
-----------
end LeftPad
-----------

----------------------------------------------------
function string LeadingZeros (string str, integer n)
----------------------------------------------------
-- return a string left-padded with zeros to ensure
-- its length is at least n characters.
----------------------------------------------------
    return LeftPad (str, n, "0000000000") 
----------------
end LeadingZeros
----------------

----------------------------------------------------
function string RightJustify (string str, integer n)
----------------------------------------------------
-- return a string left-padded with spaces to ensure
-- its length is at least n characters.
----------------------------------------------------
    return LeftPad (str, n, "          ")
----------------
end RightJustify
----------------

----------------------------------------------------
function string Centred (string str, integer n)
----------------------------------------------------
-- return a string padded with spaces to ensure its
-- its length is at least n characters, and the text
-- is centred (if it fits)
----------------------------------------------------
    local string  spaces = "                   "
    local integer len    = NumberOfChars (str)

    subtract len from n
    if n <= 0 then return str

    while NumberOfChars (spaces) < n
        set spaces to spaces & spaces
    end while
    return (char 1 to (n div 2) of spaces) & str & (char 1 to (n - n div 2) of spaces)
-----------
end Centred
-----------

-------------------------------------
function integer rnd (integer modulo)
-------------------------------------
-- return an integer between 1 and
-- <modulo>, inclusive.
-------------------------------------
-- note: on Windows, random() returns
-- a 16-bit value, so not that random!
-------------------------------------
    return 1 + (random () mod modulo)
-------
end rnd
-------

-------------------------------------------------------------------------------
--                        E n d   o f   f i l e
-------------------------------------------------------------------------------

