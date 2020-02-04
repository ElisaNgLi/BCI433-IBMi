000100190313       //**************************************************************************                 
000200191105       //* THIS PROGRAM USES A CURSOR TO LOAD A TEMPORARY RESULT TABLE FROM 3                       
000300191105       //* SEPARATE TABLES, ONTARIO, QUEBEC AND MANITOBA. A NUMBER IS PASSED                        
000400191105       //* TO THE PROGRAM TO DETERMINE WHICH RECORDS ARE INLCUDED FROM THE 3 TABLES                 
000600190313       //**************************************************************************                 
000700190313           DCL-F PROVREPORT PRINTER OFLIND(*IN01) ;                                                 
000800190313           DCL-S ProvinceH    Char(10);                                                             
000900191120           DCL-S EndOfFile    IND;             // stand-alone indicator                             
001000190313           DCL-S TotalRecords PACKED(5:0) ;                                                         
001100190315             // LowLimit is passed to the program                                                   
001200191120           DCL-PI MAIN EXTPGM('PROVSQLH');                                                          
001300191120               LOWLIMITIN PACKED(15:5);                                                             
001400191120           END-PI;                                                                                  
001401190315             // All Host Variables available under a single name                                    
001500191120           DCL-DS CustomerRecord; //check firleds of the 3 tables                                   
001505191120                  CUSTID CHAR(6);                                                                   
001506191120                  FULLNAME CHAR(31);                                                                
001507191120                  CITY CHAR(20);                                                                    
001508191120                  PURCHASE PACKED(7:2);                                                             
001509191120                  PDATE DATE;                                                                       
001510191120                  PROVINCE CHAR(10);                                                                
002200190313        End-Ds CustomerRecord;                                                                      
002200             /SET CCSID(*CHAR:*JOBRUNMIX)                                                                 
002200             // SQL COMMUNICATION AREA                                                //SQL               
002200             DCL-DS SQLCA;                                                            //SQL               
002200               SQLCAID CHAR(8) INZ(X'0000000000000000');                              //SQL               
002200                SQLAID CHAR(8) OVERLAY(SQLCAID);                                      //SQL               
002200               SQLCABC INT(10);                                                       //SQL               
002200                SQLABC BINDEC(9) OVERLAY(SQLCABC);                                    //SQL               
002200               SQLCODE INT(10);                                                       //SQL               
002200                SQLCOD BINDEC(9) OVERLAY(SQLCODE);                                    //SQL               
002200               SQLERRML INT(5);                                                       //SQL               
002200                SQLERL BINDEC(4) OVERLAY(SQLERRML);                                   //SQL               
002200               SQLERRMC CHAR(70);                                                     //SQL               
002200                SQLERM CHAR(70) OVERLAY(SQLERRMC);                                    //SQL               
002200               SQLERRP CHAR(8);                                                       //SQL               
002200                SQLERP CHAR(8) OVERLAY(SQLERRP);                                      //SQL               
002200               SQLERR CHAR(24);                                                       //SQL               
002200                SQLER1 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002200                SQLER2 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002200                SQLER3 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002200                SQLER4 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002200                SQLER5 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002200                SQLER6 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
002200                SQLERRD INT(10) DIM(6) OVERLAY(SQLERR);                               //SQL               
002200               SQLWRN CHAR(11);                                                       //SQL               
002200                SQLWN0 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002200                SQLWN1 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002200                SQLWN2 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002200                SQLWN3 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002200                SQLWN4 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002200                SQLWN5 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002200                SQLWN6 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002200                SQLWN7 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002200                SQLWN8 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002200                SQLWN9 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002200                SQLWNA CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
002200                SQLWARN CHAR(1) DIM(11) OVERLAY(SQLWRN);                              //SQL               
002200               SQLSTATE CHAR(5);                                                      //SQL               
002200                SQLSTT CHAR(5) OVERLAY(SQLSTATE);                                     //SQL               
002200             END-DS SQLCA;                                                            //SQL               
002200             DCL-PR SQLROUTE_CALL EXTPGM(SQLROUTE);                                   //SQL               
002200               CA LIKEDS(SQLCA);                                                      //SQL               
002200               *N BINDEC(4) OPTIONS(*NOPASS);                                         //SQL               
002200               *N CHAR(1) OPTIONS(*NOPASS);                                           //SQL               
002200             END-PR SQLROUTE_CALL;                                                    //SQL               
002200             DCL-PR SQLOPEN_CALL EXTPGM(SQLOPEN);                                     //SQL               
002200               CA LIKEDS(SQLCA);                                                      //SQL               
002200               *N BINDEC(4);                                                          //SQL               
002200             END-PR SQLOPEN_CALL;                                                     //SQL               
002200             DCL-PR SQLCLSE_CALL EXTPGM(SQLCLSE);                                     //SQL               
002200               CA LIKEDS(SQLCA);                                                      //SQL               
002200               *N BINDEC(4);                                                          //SQL               
002200             END-PR SQLCLSE_CALL;                                                     //SQL               
002200             DCL-PR SQLCMIT_CALL EXTPGM(SQLCMIT);                                     //SQL               
002200               CA LIKEDS(SQLCA);                                                      //SQL               
002200               *N BINDEC(4);                                                          //SQL               
002200             END-PR SQLCMIT_CALL;                                                     //SQL               
002200             /RESTORE CCSID(*CHAR)                                                                        
002200             DCL-C SQLROUTE CONST('QSYS/QSQROUTE');                                   //SQL               
002200             DCL-C SQLOPEN CONST('QSYS/QSQROUTE');                                    //SQL               
002200             DCL-C SQLCLSE CONST('QSYS/QSQLCLSE');                                    //SQL               
002200             DCL-C SQLCMIT CONST('QSYS/QSQLCMIT');                                    //SQL               
002200             DCL-C SQFRD CONST(2);                                                    //SQL               
002200             DCL-C SQFCRT CONST(8);                                                   //SQL               
002200             DCL-C SQFOVR CONST(16);                                                  //SQL               
002200             DCL-C SQFAPP CONST(32);                                                  //SQL               
009301           D                 DS                                                       OPEN                
009301           D  SQL_00000              1      2B 0 INZ(128)                             length of header    
009301           D  SQL_00001              3      4B 0 INZ(2)                               statement number    
009301           D  SQL_00002              5      8U 0 INZ(0)                               invocation mark     
009301           D  SQL_00003              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
009301           D  SQL_00004             10    128A   CCSID(*JOBRUNMIX)                    end of header       
009301           D  SQL_00005            129    132P 2                                      LOWLIMIT            
009301           D  SQL_00006            133    136P 2                                      LOWLIMIT            
009301           D  SQL_00007            137    140P 2                                      LOWLIMIT            
009804           D                 DS                                                       FETCH               
009804           D  SQL_00008              1      2B 0 INZ(128)                             length of header    
009804           D  SQL_00009              3      4B 0 INZ(3)                               statement number    
009804           D  SQL_00010              5      8U 0 INZ(0)                               invocation mark     
009804           D  SQL_00011              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
009804           D  SQL_00012             10    128A   CCSID(*JOBRUNMIX)                    end of header       
009804           D  SQL_00013            129    134A   CCSID(*JOBRUNMIX)                    CUSTID              
009804           D  SQL_00014            135    165A   CCSID(*JOBRUNMIX)                    FULLNAME            
009804           D  SQL_00015            166    185A   CCSID(*JOBRUNMIX)                    CITY                
009804           D  SQL_00016            186    189P 2                                      PURCHASE            
009804           D  SQL_00017            190    197D   DATFMT(*MDY/)                        PDATE               
009804           D  SQL_00018            198    207A   CCSID(*JOBRUNMIX)                    PROVINCE            
011302           D                 DS                                                       CLOSE               
011302           D  SQL_00019              1      2B 0 INZ(128)                             length of header    
011302           D  SQL_00020              3      4B 0 INZ(4)                               statement number    
011302           D  SQL_00021              5      8U 0 INZ(0)                               invocation mark     
011302           D  SQL_00022              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011302           D  SQL_00023             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011302           D  SQL_00024            128    128A   CCSID(*JOBRUNMIX)                    end of header       
011312           D                 DS                                                       SELECT              
011312           D  SQL_00025              1      2B 0 INZ(128)                             length of header    
011312           D  SQL_00026              3      4B 0 INZ(5)                               statement number    
011312           D  SQL_00027              5      8U 0 INZ(0)                               invocation mark     
011312           D  SQL_00028              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011312           D  SQL_00029             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011312           D  SQL_00030            129    132P 2                                      LOWLIMIT            
011312           D  SQL_00031            133    134P 0                                      ONTTOTAL            
011320           D                 DS                                                       SELECT              
011320           D  SQL_00032              1      2B 0 INZ(128)                             length of header    
011320           D  SQL_00033              3      4B 0 INZ(6)                               statement number    
011320           D  SQL_00034              5      8U 0 INZ(0)                               invocation mark     
011320           D  SQL_00035              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011320           D  SQL_00036             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011320           D  SQL_00037            129    132P 2                                      LOWLIMIT            
011320           D  SQL_00038            133    134P 0                                      QUETOTAL            
011330           D                 DS                                                       SELECT              
011330           D  SQL_00039              1      2B 0 INZ(128)                             length of header    
011330           D  SQL_00040              3      4B 0 INZ(7)                               statement number    
011330           D  SQL_00041              5      8U 0 INZ(0)                               invocation mark     
011330           D  SQL_00042              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
011330           D  SQL_00043             10    127A   CCSID(*JOBRUNMIX)                    end of header       
011330           D  SQL_00044            129    132P 2                                      LOWLIMIT            
011330           D  SQL_00045            133    134P 0                                      MANTOTAL            
002300070123     C/EJECT                                                                                        
002400070123     C**************************************************************************                    
002500070123     C*                        ***   M A I N   R O U T I N E   ***                                  
002600070123     C**************************************************************************                    
002700070118      /FREE                                                                                         
002701191125                LOWLIMIT = LOWLIMITIN;                                                              
002800100309                EXSR PrepareFiles;                                                                  
002900190313                Write Title;                                                                        
003000190313                Write HEADINGS;                                                                     
003100100309                EXSR GetRow;                                                                        
003200190313                Write NewProv;                                                                      
003300070209                ProvinceH = Province;                                                               
003400070202                DOW NOT EndOfFile;                                                                  
003500190313                    IF *IN01 = *ON;                                                                 
003600190313                        Write Title;                                                                
003700190313                        Write HEADINGS;                                                             
003800190313                       *IN01 = *OFF;                                                                
003900070209                    ENDIF;                                                                          
003901190315                    // Province may change                                                          
003902191120                         IF PROVINCEH = PROVINCE;                                                   
003903191120                             WRITE DETAIL;                                                          
003904191120                         ELSE;                                                                      
003905191120                            PROVINCEH = PROVINCE;                                                   
003906191120                            WRITE TOTALS;                                                           
003907191120                            TOTALPURCH = 0;                                                         
003908191120                            WRITE NEWPROV;                                                          
003909191120                            WRITE DETAIL;                                                           
003910191120                            ENDIF;                                                                  
004900190313                    TotalPurch     = TotalPurch     + Purchase;                                     
005000070202                    TotalRecords= TotalRecords + 1;                                                 
005100100309                    EXSR GetRow;                                                                    
005200070119                ENDDO;                                                                              
005300190313                Write Totals;                                                                       
005400070202                EXSR   WRAPUP;                                                                      
005500190313                Write UnderLimit;                                                                   
005600070119                *INLR = *ON;                                                                        
005700070119                RETURN;                                                                             
005800100309        //**********************************************************************                    
005900100309        // O P E N F I L E S   S U B R O U T I N E                                                  
006000100309        //**********************************************************************                    
006100100309         BEGSR  PrepareFiles;                                                                       
006200190315        // S E T   U P   T H E   T E M P O R A R Y   R E S U L T  STRUCTURE                         
006300191120       //*        EXEC SQL                   // DB2 CURSOR: DECLARE|OPEN|FETCH(M TO NEXT) | CLOSE   
006301191120       //*          DECLARE ALLPROVCURSOR CURSOR  // READ SQLCURSOR.DOCX UNDER IROOT -> BCI433NOTES 
006302191120       //*            FOR                                                                           
006303191120       //*            SELECT CUSTID, TRIM(FNAME) || ' ' || LNAME,                                   
006304191120       //*                   CITY, PURCHASE, PDATE,                                                 
006305191120       //*                   'Ontario' as PROVINCE                                                  
006306191120       //*            FROM BCI433LIB/ONTARIO                                                        
006307191120       //*            WHERE PURCHASE > :LowLimit                                                    
006308191120       //*            UNION ALL                                                                     
006310191120       //*            SELECT CUSTID, TRIM(FNAME) || ' ' || TRIM(LNAME),                             
006311191120       //*                   CITY, PURCHASE, PDATE,                                                 
006312191120       //*                   'Quebec' as PROVINCE                                                   
006313191120       //*            FROM BCI433LIB/QUEBEC                                                         
006314191120       //*            WHERE PURCHASE > :LowLimit                                                    
006315191120       //*            UNION ALL                                                                     
006316191120       //*          SELECT CUSTID, TRIM(FNAME) || ' ' || TRIM(LNAME),                               
006317191120       //*                   CITY, PURCHASE, PDATE,                                                 
006318191120       //*                   'Manitoba' as PROVINCE                                                 
006319191120       //*            FROM BCI433LIB/MANITOBA                                                       
006320191120       //*            WHERE PURCHASE > :LowLimit                                                    
006321191120       //*          FOR READ ONLY;                                                                  
008500100309        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D                    
009300191120       //*           EXEC SQL                                                                       
009301191120       //*        OPEN ALLPROVCURSOR;                                                               
009301                SQL_00005 = LOWLIMIT;                                                 //SQL               
009301                SQL_00006 = LOWLIMIT;                                                 //SQL               
009301                SQL_00007 = LOWLIMIT;                                                 //SQL               
009301                SQLER6 = -4;                                                          //SQL               
009301                IF SQL_00002 = 0                                                      //SQL               
009301                OR SQL_00003 <> *LOVAL;                                               //SQL               
009301                SQLROUTE_CALL(                                                        //SQL               
009301                     SQLCA                                                            //SQL               
009301                   : SQL_00000                                                        //SQL               
009301                );                                                                    //SQL               
009301                ELSE;                                                                 //SQL               
009301                SQLOPEN_CALL(                                                         //SQL               
009301                     SQLCA                                                            //SQL               
009301                   : SQL_00000                                                        //SQL               
009301                );                                                                    //SQL               
009301                ENDIF;                                                                //SQL               
009302191120             IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                       
009303191120               EndOfFile = *ON;                                                                     
009304191120             ENDIF;                                                                                 
009400100309            ENDSR;                                                                                  
009500100309        //**********************************************************************                    
009600100309        //   G E T     R O W    S U B R O U T I N E                                                 
009700100309        //**********************************************************************                    
009800100309            BEGSR     GETROW;                                                                       
009801191120       //*       EXEC SQL                                                                           
009802191120       //*        FETCH NEXT                                                                        
009803191120       //*          FROM ALLPROVCURSOR                                                              
009804191120       //*          INTO :CustomerRecord;                                                           
009804                SQLER6 = -4;                                                          //SQL 3             
009804                SQLROUTE_CALL(                                                        //SQL               
009804                     SQLCA                                                            //SQL               
009804                   : SQL_00008                                                        //SQL               
009804                );                                                                    //SQL               
009804                IF SQL_00011 = '1';                                                   //SQL               
009804                EVAL CUSTID = SQL_00013;                                              //SQL               
009804                EVAL FULLNAME = SQL_00014;                                            //SQL               
009804                EVAL CITY = SQL_00015;                                                //SQL               
009804                EVAL PURCHASE = SQL_00016;                                            //SQL               
009804                EVAL PDATE = SQL_00017;                                               //SQL               
009804                EVAL PROVINCE = SQL_00018;                                            //SQL               
009804                ENDIF;                                                                //SQL               
009805191120            IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                        
009806191120              EndOfFile = *ON;                                                                      
009807191120            ENDIF;                                                                                  
010900100309             ENDSR;                                                                                 
011000100309        //**********************************************************************                    
011100100309        // W R A P U P     S U B R O U T I N E                                                      
011200100309        //**********************************************************************                    
011300100309           BEGSR WRAPUP;                                                                            
011301191120       //*      EXEC SQL                                                                            
011302191120       //*        CLOSE ALLPROVCURSOR;                                                              
011302                SQLER6 = 4;                                                           //SQL               
011302                IF SQL_00021 = 0;                                                     //SQL               
011302                SQLROUTE_CALL(                                                        //SQL               
011302                     SQLCA                                                            //SQL               
011302                   : SQL_00019                                                        //SQL               
011302                );                                                                    //SQL               
011302                ELSE;                                                                 //SQL               
011302                SQLCLSE_CALL(                                                         //SQL               
011302                     SQLCA                                                            //SQL               
011302                   : SQL_00019                                                        //SQL               
011302                );                                                                    //SQL               
011302                ENDIF;                                                                //SQL               
011303191120                                                                                                    
011304191120             IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                       
011305191120               ENDOFFILE = *ON;                                                                     
011307191120             ENDIF;                                                                                 
011308191120                                                                                                    
011309191120       //*      EXEC SQL                                                                            
011310191120       //*        SELECT COUNT(*) INTO :OntTotal                                                    
011311191120       //*          FROM BCI433LIB/ONTARIO                                                          
011312191120       //*        WHERE PURCHASE <= :LOWLIMIT;                                                      
011312                SQL_00030 = LOWLIMIT;                                                 //SQL               
011312                SQLER6 = -4;                                                          //SQL 5             
011312                SQLROUTE_CALL(                                                        //SQL               
011312                     SQLCA                                                            //SQL               
011312                   : SQL_00025                                                        //SQL               
011312                );                                                                    //SQL               
011312                IF SQL_00028 = '1';                                                   //SQL               
011312                EVAL ONTTOTAL = SQL_00031;                                            //SQL               
011312                ENDIF;                                                                //SQL               
011313191120                                                                                                    
011314191120             IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                       
011315191120               OntTotal = -999;                                                                     
011316191120             ENDIF;                                                                                 
011317191120       //*      EXEC SQL                                                                            
011318191120       //*        SELECT COUNT(*) INTO :QUETOTAL                                                    
011319191120       //*          FROM BCI433LIB/QUEBEC                                                           
011320191120       //*          WHERE PURCHASE <= :LowLimit;                                                    
011320                SQL_00037 = LOWLIMIT;                                                 //SQL               
011320                SQLER6 = -4;                                                          //SQL 6             
011320                SQLROUTE_CALL(                                                        //SQL               
011320                     SQLCA                                                            //SQL               
011320                   : SQL_00032                                                        //SQL               
011320                );                                                                    //SQL               
011320                IF SQL_00035 = '1';                                                   //SQL               
011320                EVAL QUETOTAL = SQL_00038;                                            //SQL               
011320                ENDIF;                                                                //SQL               
011321191120                                                                                                    
011322191120             IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                       
011323191120               QueTotal = -999;                                                                     
011324191120             ENDIF;                                                                                 
011325191120                                                                                                    
011326191120                                                                                                    
011327191120       //*      EXEC SQL                                                                            
011328191120       //*        SELECT COUNT(*) INTO :MANTOTAL                                                    
011329191120       //*          FROM BCI433LIB/MANITOBA                                                         
011330191120       //*          WHERE PURCHASE <= :LowLimit;                                                    
011330                SQL_00044 = LOWLIMIT;                                                 //SQL               
011330                SQLER6 = -4;                                                          //SQL 7             
011330                SQLROUTE_CALL(                                                        //SQL               
011330                     SQLCA                                                            //SQL               
011330                   : SQL_00039                                                        //SQL               
011330                );                                                                    //SQL               
011330                IF SQL_00042 = '1';                                                   //SQL               
011330                EVAL MANTOTAL = SQL_00045;                                            //SQL               
011330                ENDIF;                                                                //SQL               
011331191120                                                                                                    
011332191120             IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                       
011333191120               ManTotal = -999;                                                                     
011334191120             ENDIF;                                                                                 
014600100309          ENDSR;                                                                                    
014601190315                                                                                                    
