000100190313         // **************************************************************************              
000200190313        //  CUSTOMER19 READ BY NATIVE LANGUAGE (ILE RPG)                                            
000300190313        //  CONTACTW19 ROW RETRIEVED WITH EMBEDDED SQL                                              
000400190313        //  DETAIL REPORT LINE INCLUDES INFORMATION FROM CUSTOMER19 AND CONTACTW19                  
000500190313        //  SUMMARRY REPORT INFORMATION RETRIEVED WITH EMBEDDED SQL STATEMENTS                      
000600190314                                                                                                    
000700190313           DCL-F PHNREPORT PRINTER OFLIND(*IN01) ;                                                  
000800190313           DCL-F CUSTOMER19 DISK(*EXT) KEYED USAGE(*INPUT)                                          
000900190314                 RENAME(CUSTOMER19:CUSTR);                                                          
001000190314                      // data structure for host variables from CONTACTW19                          
001100191114           DCL-DS CONTACTW19 EXT END-DS;                                                            
001200190314                     // Standalone fields for indicator variables                                   
001300191114           DCL-S INDLastCDATE BINDEC(4:0);                                                          
001400191114           DCL-S INDNextCDATE BINDEC(4:0);                                                          
001500190314                                                                                                    
001600190314           DCL-S Dummy  Zoned(1);                                                                   
001700190314                                                                                                    
001800190314        //**************************************************************************                
001900190314        //*                        ***   M A I N   R O U T I N E   ***                              
002000190314        //**************************************************************************                
002100190314                                                                                                    
002100             /SET CCSID(*CHAR:*JOBRUNMIX)                                                                 
002100             // SQL COMMUNICATION AREA                                                //SQL               
002100             DCL-DS SQLCA;                                                            //SQL               
002100               SQLCAID CHAR(8) INZ(X'0000000000000000');                              //SQL               
002100                SQLAID CHAR(8) OVERLAY(SQLCAID);                                      //SQL               
002100               SQLCABC INT(10);                                                       //SQL               
002100                SQLABC BINDEC(9) OVERLAY(SQLCABC);                                    //SQL               
002100               SQLCODE INT(10);                                                       //SQL               
002100                SQLCOD BINDEC(9) OVERLAY(SQLCODE);                                    //SQL               
002100               SQLERRML INT(5);                                                       //SQL               
002100                SQLERL BINDEC(4) OVERLAY(SQLERRML);                                   //SQL               
002100               SQLERRMC CHAR(70);                                                     //SQL               
002100                SQLERM CHAR(70) OVERLAY(SQLERRMC);                                    //SQL               
002100               SQLERRP CHAR(8);                                                       //SQL               
002100                SQLERP CHAR(8) OVERLAY(SQLERRP);                                      //SQL               
002100               SQLERR CHAR(24);                                                       //SQL               
002100                SQLER1 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER2 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER3 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER4 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER5 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLER6 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002100                SQLERRD INT(10) DIM(6) OVERLAY(SQLERR);                               //SQL               
002100               SQLWRN CHAR(11);                                                       //SQL               
002100                SQLWN0 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN1 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN2 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN3 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN4 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN5 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN6 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN7 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN8 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWN9 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWNA CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002100                SQLWARN CHAR(1) DIM(11) OVERLAY(SQLWRN);                              //SQL               
002100               SQLSTATE CHAR(5);                                                      //SQL               
002100                SQLSTT CHAR(5) OVERLAY(SQLSTATE);                                     //SQL               
002100             END-DS SQLCA;                                                            //SQL               
002100             DCL-PR SQLROUTE_CALL EXTPGM(SQLROUTE);                                   //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4) OPTIONS(*NOPASS);                                         //SQL               
002100               *N CHAR(1) OPTIONS(*NOPASS);                                           //SQL               
002100             END-PR SQLROUTE_CALL;                                                    //SQL               
002100             DCL-PR SQLOPEN_CALL EXTPGM(SQLOPEN);                                     //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4);                                                          //SQL               
002100             END-PR SQLOPEN_CALL;                                                     //SQL               
002100             DCL-PR SQLCLSE_CALL EXTPGM(SQLCLSE);                                     //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4);                                                          //SQL               
002100             END-PR SQLCLSE_CALL;                                                     //SQL               
002100             DCL-PR SQLCMIT_CALL EXTPGM(SQLCMIT);                                     //SQL               
002100               CA LIKEDS(SQLCA);                                                      //SQL               
002100               *N BINDEC(4);                                                          //SQL               
002100             END-PR SQLCMIT_CALL;                                                     //SQL               
002100             /RESTORE CCSID(*CHAR)                                                                        
002100             DCL-C SQLROUTE CONST('QSYS/QSQROUTE');                                   //SQL               
002100             DCL-C SQLOPEN CONST('QSYS/QSQROUTE');                                    //SQL               
002100             DCL-C SQLCLSE CONST('QSYS/QSQLCLSE');                                    //SQL               
002100             DCL-C SQLCMIT CONST('QSYS/QSQLCMIT');                                    //SQL               
002100             DCL-C SQFRD CONST(2);                                                    //SQL               
002100             DCL-C SQFCRT CONST(8);                                                   //SQL               
002100             DCL-C SQFOVR CONST(16);                                                  //SQL               
002100             DCL-C SQFAPP CONST(32);                                                  //SQL               
004906           D                 DS                                                       SELECT              
004906           D  SQL_00000              1      2B 0 INZ(128)                             length of header    
004906           D  SQL_00001              3      4B 0 INZ(1)                               statement number    
004906           D  SQL_00002              5      8U 0 INZ(0)                               invocation mark     
004906           D  SQL_00003              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
004906           D  SQL_00004             10    128A   CCSID(*JOBRUNMIX)                    end of header       
004906           D  SQL_00005            129    131P 0                                      CSTNUM              
004906           D  SQL_00006            132    139D   DATFMT(*MDY/)                        NEXTCDATE           
004906           D  SQL_00008            140    147D   DATFMT(*MDY/)                        PHNLDC              
004906           D  SQL_00010            148    162A   CCSID(*JOBRUNMIX)                    CSTPHN              
004906           D  SQL_00011            163    189A   VARYING CCSID(*JOBRUNMIX)            PHNCOM              
004906           D  SQL_00012            190    192A   CCSID(*JOBRUNMIX)                    CSTSLN              
004906           D  SQL_00007            193    194B 0                                      INDNEXTCDATE        
004906           D  SQL_00009            195    196B 0                                      INDLASTCDATE        
007602           D                 DS                                                       SELECT              
007602           D  SQL_00013              1      2B 0 INZ(128)                             length of header    
007602           D  SQL_00014              3      4B 0 INZ(2)                               statement number    
007602           D  SQL_00015              5      8U 0 INZ(0)                               invocation mark     
007602           D  SQL_00016              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
007602           D  SQL_00017             10    128A   CCSID(*JOBRUNMIX)                    end of header       
007602           D  SQL_00018            129    131P 0                                      CONTACTT            
007610           D                 DS                                                       SELECT              
007610           D  SQL_00019              1      2B 0 INZ(128)                             length of header    
007610           D  SQL_00020              3      4B 0 INZ(3)                               statement number    
007610           D  SQL_00021              5      8U 0 INZ(0)                               invocation mark     
007610           D  SQL_00022              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
007610           D  SQL_00023             10    128A   CCSID(*JOBRUNMIX)                    end of header       
007610           D  SQL_00024            129    131P 0                                      CUSTOMERT           
009103           D                 DS                                                       SELECT              
009103           D  SQL_00025              1      2B 0 INZ(128)                             length of header    
009103           D  SQL_00026              3      4B 0 INZ(4)                               statement number    
009103           D  SQL_00027              5      8U 0 INZ(0)                               invocation mark     
009103           D  SQL_00028              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
009103           D  SQL_00029             10    128A   CCSID(*JOBRUNMIX)                    end of header       
009103           D  SQL_00030            129    131P 0                                      UNKNOWNT            
010104           D                 DS                                                       SELECT              
010104           D  SQL_00031              1      2B 0 INZ(128)                             length of header    
010104           D  SQL_00032              3      4B 0 INZ(5)                               statement number    
010104           D  SQL_00033              5      8U 0 INZ(0)                               invocation mark     
010104           D  SQL_00034              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
010104           D  SQL_00035             10    128A   CCSID(*JOBRUNMIX)                    end of header       
010104           D  SQL_00036            129    136D   DATFMT(*MDY/)                        OLDESTDATE          
010501           D                 DS                                                       SELECT              
010501           D  SQL_00037              1      2B 0 INZ(128)                             length of header    
010501           D  SQL_00038              3      4B 0 INZ(6)                               statement number    
010501           D  SQL_00039              5      8U 0 INZ(0)                               invocation mark     
010501           D  SQL_00040              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
010501           D  SQL_00041             10    128A   CCSID(*JOBRUNMIX)                    end of header       
010501           D  SQL_00042            129    136D   DATFMT(*MDY/)                        RECENTDATE          
012205           D                 DS                                                       SELECT              
012205           D  SQL_00043              1      2B 0 INZ(128)                             length of header    
012205           D  SQL_00044              3      4B 0 INZ(7)                               statement number    
012205           D  SQL_00045              5      8U 0 INZ(0)                               invocation mark     
012205           D  SQL_00046              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
012205           D  SQL_00047             10    128A   CCSID(*JOBRUNMIX)                    end of header       
012205           D  SQL_00048            129    138A   CCSID(*JOBRUNMIX)                    USER                
012205           D  SQL_00049            139    164Z                                        TIMESTAMP           
012205           D  SQL_00050            165    174A   CCSID(*JOBRUNMIX)                    SERVER              
002200070119                EXSR SummaryInfo;                                                                   
002300190313                WRITE HEADINGS;                                                                     
002400190313                READ CUSTOMER19;                                                                    
002500070119                DOW NOT %EOF;                                                                       
002600070119                    EXSR SQLSelect;                                                                 
002601191114                    IF PHNLDC = OldestDate;                                                         
002602191114                      Flag = '<------';                                                             
002603191114                      ELSE;                                                                         
002604191114                        Flag = ' ';                                                                 
002605191114                    ENDIF;                                                                          
002700190313                    IF *IN01 = *ON;                                                                 
002800190313                       Write HEADINGS;                                                              
002900190313                       *IN01 = *OFF;                                                                
003000070119                    ENDIF;                                                                          
003100190313                    Write DETAIL;                                                                   
003200190313                   READ CUSTOMER19;                                                                 
003300070119                ENDDO;                                                                              
003400190313                Write SUMMARY;                                                                      
003500070119                *INLR = *ON;                                                                        
003600070119                RETURN;                                                                             
003700080923        //**********************************************************************                    
003800080923        //   S Q L S E L E C T   S U B R O U T I N E                                                
003900080923   //   //********************************************************************                      
004000191114                BEGSR    SQLSelect ;                                                                
004100080923   //    // A row from the contacts table that has the same customer number as t                    
004200190313   //    // read from the CUSTOMER19 file is retrieved to find out the last date                    
004300080923   //    // phone number, comments and the salesperson number.                                      
004400080923   //                                                                                               
004500080923   //    //  The call back interval is added to the last date called to determin                    
004600080923   //    //  next date to call.  Since null values may be stored in the last dat                    
004700080923   //    // indicator variables are used.                                                           
004800190314                                                                                                    
004900191114       //*     EXEC SQL                                                                             
004901191114       //*      SELECT PHNLDC + PHNCIT DAYS, PHNLDC,                                                
004902191114       //*              CstPhN, PHNCOM, CstSLN                                                      
004903191114       //*      INTO  :NEXTCDATE :INDNEXTCDATE, :PHNLDC :INDLastCDate,                              
004904191114       //*            :CSTPHN, :PHNCOM, :CSTSLN                                                     
004905191114       //*      FROM   BCI433LIB/CONTACTW19                                                         
004906191114       //*      WHERE CSTNUM = :CSTNUM;                                                             
004906                SQL_00005 = CSTNUM;                                                   //SQL               
004906                SQLER6 = -4;                                                          //SQL 1             
004906                SQLROUTE_CALL(                                                        //SQL               
004906                     SQLCA                                                            //SQL               
004906                   : SQL_00000                                                        //SQL               
004906                );                                                                    //SQL               
004906                IF SQL_00003 = '1';                                                   //SQL               
004906                IF SQL_00007 >= 0;                                                    //SQL               
004906                EVAL NEXTCDATE = SQL_00006;                                           //SQL               
004906                ENDIF;                                                                //SQL               
004906                EVAL INDNEXTCDATE = SQL_00007;                                        //SQL               
004906                IF SQL_00009 >= 0;                                                    //SQL               
004906                EVAL PHNLDC = SQL_00008;                                              //SQL               
004906                ENDIF;                                                                //SQL               
004906                EVAL INDLASTCDATE = SQL_00009;                                        //SQL               
004906                EVAL CSTPHN = SQL_00010;                                              //SQL               
004906                EVAL PHNCOM = SQL_00011;                                              //SQL               
004906                EVAL CSTSLN = SQL_00012;                                              //SQL               
004906                ENDIF;                                                                //SQL               
004907191114                                                                                                    
004908191114            SELECT;                                                                                 
004909191114              WHEN SQLSTATE = '00000';                                                              
004910191114                Dummy = 0;                                                                          
004911191114                WHEN SQLSTATE = '02000';                                                            
004912191114                  CstPhn = 'Not Found';                                                             
004913191114                  NEXTCDATE = D'9999-09-09';                                                        
004914191114                  PhnLDC = D'9999-09-09';                                                           
004915191114                  PhnCom = *All'*';                                                                 
004916191114                  CstSln = *All'*';                                                                 
004917191114                  When %Subst(SQLState :1 :2) = '01';//warning                                      
004918191114                    NEXTCDATE = D'9999-09-09';                                                      
004919191114                    PhnLDC = D'9999-09-09';                                                         
004920191114                    PhnCom = *All'*';                                                               
004921191114                    CstSln = *All'*';                                                               
004922191114                    CstPhn = *All'*';                                                               
004923191114                    OTHER;                 // Success - SQL query                                   
004924191114                      CstPhn = *ALL'*';                                                             
004925191114                      NEXTCDATE = D'9999-09-09';                                                    
004926191114                      PhnLDC =  D'9999-09-09';                                                      
004927191114                      PhnCom = *All'*';                                                             
004928191114                      CstSln = *All'*';                                                             
004929191114            ENDSL;                                                                                  
004930191114                                                                                                    
004931191114           IF IndLastCdate = -1;                                                                    
004932191114             CSTPHN = 'UNKNOWN DATE';                                                               
004933191114             NEXTCDATE = D'9999-09-09';                                                             
004934191114             PHNLDC = D'9999-09-09';                                                                
004935191114             ELSE;                                                                                  
004936191114               IF INDLASTCDATE <> 0;                                                                
004937191114                 CSTPHN = 'DATE PROBLEM';                                                           
004938191114                 NEXTCDATE = D'9999-09-09';                                                         
004939191114                 PHNLDC = D'9999-09-09';                                                            
004940191114               ENDIF;                                                                               
004941191114           ENDIF;                                                                                   
006900080923                         ENDSR ;                                                                    
007000080923        //**********************************************************************                    
007100080923        // S U M M A R Y I N F O   S U B R O U T I N E                                              
007200080923        //**********************************************************************                    
007300080923                         BEGSR  SummaryInfo;                                                        
007400190313        //  D E T E R M I N E   T O T A L S   F O R   CONTACTW19 & CUSTOMER19                       
007500190314                                                                                                    
007600191114       //*            EXEC SQL                                                                      
007601191114       //*       SELECT COUNT(*) INTO :CONTACTT                                                     
007602191114       //*              FROM BCI433LIB/CONTACTW19;                                                  
007602                SQLER6 = -4;                                                          //SQL 2             
007602                SQLROUTE_CALL(                                                        //SQL               
007602                     SQLCA                                                            //SQL               
007602                   : SQL_00013                                                        //SQL               
007602                );                                                                    //SQL               
007602                IF SQL_00016 = '1';                                                   //SQL               
007602                EVAL CONTACTT = SQL_00018;                                            //SQL               
007602                ENDIF;                                                                //SQL               
007603191114                                                                                                    
007604191114              IF (SQLCODE <> 0) OR(SQLWN0 = 'W');                                                   
007605191114                CONTACTT= -99999;                                                                   
007606191114              ENDIF;                                                                                
007607191114                                                                                                    
007608191114       //*       EXEC SQL                                                                           
007609191114       //*         SELECT COUNT(*) INTO :CUSTOMERT                                                  
007610191114       //*           FROM BCI433LIB/CUSTOMER19;                                                     
007610                SQLER6 = -4;                                                          //SQL 3             
007610                SQLROUTE_CALL(                                                        //SQL               
007610                     SQLCA                                                            //SQL               
007610                   : SQL_00019                                                        //SQL               
007610                );                                                                    //SQL               
007610                IF SQL_00022 = '1';                                                   //SQL               
007610                EVAL CUSTOMERT = SQL_00024;                                           //SQL               
007610                ENDIF;                                                                //SQL               
007611191114                                                                                                    
007612191114              IF (SQLCODE <> 0) OR (SQLWN0 = 'W');                                                  
007613191114                CUSTOMERT = -99999;                                                                 
007614191114                                                                                                    
007615191114              ENDIF;                                                                                
007616191114                                                                                                    
008900190314                                                                                                    
009000190314        // D E T E R M I N E   N U M B E R   O F   U N K N O W N   LAST   DATE CALLED               
009100191114       //*            EXEC SQL                                                                      
009101191114       //*       SELECT COUNT(*) INTO :UNKNOWNT                                                     
009102191114       //*              FROM BCI433LIB/CONTACTW19                                                   
009103191114       //*              WHERE CstLastCallDate IS NULL;                                              
009103                SQLER6 = -4;                                                          //SQL 4             
009103                SQLROUTE_CALL(                                                        //SQL               
009103                     SQLCA                                                            //SQL               
009103                   : SQL_00025                                                        //SQL               
009103                );                                                                    //SQL               
009103                IF SQL_00028 = '1';                                                   //SQL               
009103                EVAL UNKNOWNT = SQL_00030;                                            //SQL               
009103                ENDIF;                                                                //SQL               
009104191114                                                                                                    
009105191114              IF NOT (SQLCODE = 0) OR (SQLWN0 = 'W');                                               
009106191114                UNKNOWNT  = -99999;                                                                 
009107191114              ENDIF;                                                                                
010000190314                                                                                                    
010100080923        //  D E T E R M I N E   O L D E S T   &  M O S T   R E C E N T  L A S T                     
010101191114                                                                                                    
010102191114       //* EXEC SQL                                                                                 
010103191114       //*   SELECT MIN(PHNLDC) INTO :OLDESTDATE                                                    
010104191114       //*     FROM BCI433LIB/CONTACTW19;                                                           
010104                SQLER6 = -4;                                                          //SQL 5             
010104                SQLROUTE_CALL(                                                        //SQL               
010104                     SQLCA                                                            //SQL               
010104                   : SQL_00031                                                        //SQL               
010104                );                                                                    //SQL               
010104                IF SQL_00034 = '1';                                                   //SQL               
010104                EVAL OLDESTDATE = SQL_00036;                                          //SQL               
010104                ENDIF;                                                                //SQL               
010200080923                                                                                                    
010300191114                  IF (SQLCODE <> 0) OR(SQLWN0 = 'W') AND (SQLWN2 <> 'W');                           
010302191114                OLDESTDATE  = D'9999-09-09';                                                        
010303191114              ENDIF;                                                                                
010304191114                                                                                                    
010400191114       //*     EXEC SQL                                                                             
010500191114       //*       SELECT MAX(PHNLDC) INTO :RECENTDATE                                                
010501191114       //*         FROM BCI433LIB/CONTACTW19;                                                       
010501                SQLER6 = -4;                                                          //SQL 6             
010501                SQLROUTE_CALL(                                                        //SQL               
010501                     SQLCA                                                            //SQL               
010501                   : SQL_00037                                                        //SQL               
010501                );                                                                    //SQL               
010501                IF SQL_00040 = '1';                                                   //SQL               
010501                EVAL RECENTDATE = SQL_00042;                                          //SQL               
010501                ENDIF;                                                                //SQL               
010502191114                                                                                                    
010503191114                IF (SQLCODE <> 0) OR  (SQLWN0 = 'W') AND                                            
010504191114                    (SQLWN2 <>  'W');                                                               
010600191114                       RECENTDATE = D'9999-09-09';                                                  
010601191114                       ENDIF;                                                                       
012000190314                                                                                                    
012100080923       // D E T E R M I N E   T H E   U S E R   S E R V E R   &   T I M E S T A                     
012200191114       //*                     EXEC SQL                                                             
012201191114       //*        SELECT USER, CURRENT TIMESTAMP, CURRENT SERVER                                    
012202191114       //*            INTO :USER,                                                                   
012203191114       //*                 :TIMEStamp,                                                              
012204191114       //*                 :Server                                                                  
012205191114       //*            FROM SYSIBM/SYSDUMMY1;                                                        
012205                SQLER6 = -4;                                                          //SQL 7             
012205                SQLROUTE_CALL(                                                        //SQL               
012205                     SQLCA                                                            //SQL               
012205                   : SQL_00043                                                        //SQL               
012205                );                                                                    //SQL               
012205                IF SQL_00046 = '1';                                                   //SQL               
012205                EVAL USER = SQL_00048;                                                //SQL               
012205                EVAL TIMESTAMP = SQL_00049;                                           //SQL               
012205                EVAL SERVER = SQL_00050;                                              //SQL               
012205                ENDIF;                                                                //SQL               
012800080923                         ENDSR;                                                                     
