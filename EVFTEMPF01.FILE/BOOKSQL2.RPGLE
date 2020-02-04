000001191204       DCL-F BOOKRPT2 PRINTER OFLIND(*IN01);                                                        
000002191204       DCL-S GENREH CHAR(20);                                                                       
000003191204       DCL-S ENDOFFILE IND;                                                                         
000004191204                                                                                                    
000007191205       DCL-DS AUDIBLEBKSREC;                                                                        
000008191205         GENRE CHAR(20);                                                                            
000009191205         BOOKID ZONED(7:0);                                                                         
000010191205         BOOK CHAR(50);                                                                             
000011191205         DURATION TIME;                                                                             
000012191205         AUTHOR CHAR(30);                                                                           
000013191205         PRICE PACKED(5:2);                                                                         
000015191205       END-DS;                                                                                      
000016191204                                                                                                    
000016             /SET CCSID(*CHAR:*JOBRUNMIX)                                                                 
000016             // SQL COMMUNICATION AREA                                                //SQL               
000016             DCL-DS SQLCA;                                                            //SQL               
000016               SQLCAID CHAR(8) INZ(X'0000000000000000');                              //SQL               
000016                SQLAID CHAR(8) OVERLAY(SQLCAID);                                      //SQL               
000016               SQLCABC INT(10);                                                       //SQL               
000016                SQLABC BINDEC(9) OVERLAY(SQLCABC);                                    //SQL               
000016               SQLCODE INT(10);                                                       //SQL               
000016                SQLCOD BINDEC(9) OVERLAY(SQLCODE);                                    //SQL               
000016               SQLERRML INT(5);                                                       //SQL               
000016                SQLERL BINDEC(4) OVERLAY(SQLERRML);                                   //SQL               
000016               SQLERRMC CHAR(70);                                                     //SQL               
000016                SQLERM CHAR(70) OVERLAY(SQLERRMC);                                    //SQL               
000016               SQLERRP CHAR(8);                                                       //SQL               
000016                SQLERP CHAR(8) OVERLAY(SQLERRP);                                      //SQL               
000016               SQLERR CHAR(24);                                                       //SQL               
000016                SQLER1 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000016                SQLER2 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000016                SQLER3 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000016                SQLER4 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000016                SQLER5 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000016                SQLER6 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000016                SQLERRD INT(10) DIM(6) OVERLAY(SQLERR);                               //SQL               
000016               SQLWRN CHAR(11);                                                       //SQL               
000016                SQLWN0 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000016                SQLWN1 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000016                SQLWN2 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000016                SQLWN3 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000016                SQLWN4 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000016                SQLWN5 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000016                SQLWN6 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000016                SQLWN7 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000016                SQLWN8 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000016                SQLWN9 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000016                SQLWNA CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000016                SQLWARN CHAR(1) DIM(11) OVERLAY(SQLWRN);                              //SQL               
000016               SQLSTATE CHAR(5);                                                      //SQL               
000016                SQLSTT CHAR(5) OVERLAY(SQLSTATE);                                     //SQL               
000016             END-DS SQLCA;                                                            //SQL               
000016             DCL-PR SQLROUTE_CALL EXTPGM(SQLROUTE);                                   //SQL               
000016               CA LIKEDS(SQLCA);                                                      //SQL               
000016               *N BINDEC(4) OPTIONS(*NOPASS);                                         //SQL               
000016               *N CHAR(1) OPTIONS(*NOPASS);                                           //SQL               
000016             END-PR SQLROUTE_CALL;                                                    //SQL               
000016             DCL-PR SQLOPEN_CALL EXTPGM(SQLOPEN);                                     //SQL               
000016               CA LIKEDS(SQLCA);                                                      //SQL               
000016               *N BINDEC(4);                                                          //SQL               
000016             END-PR SQLOPEN_CALL;                                                     //SQL               
000016             DCL-PR SQLCLSE_CALL EXTPGM(SQLCLSE);                                     //SQL               
000016               CA LIKEDS(SQLCA);                                                      //SQL               
000016               *N BINDEC(4);                                                          //SQL               
000016             END-PR SQLCLSE_CALL;                                                     //SQL               
000016             DCL-PR SQLCMIT_CALL EXTPGM(SQLCMIT);                                     //SQL               
000016               CA LIKEDS(SQLCA);                                                      //SQL               
000016               *N BINDEC(4);                                                          //SQL               
000016             END-PR SQLCMIT_CALL;                                                     //SQL               
000016             /RESTORE CCSID(*CHAR)                                                                        
000016             DCL-C SQLROUTE CONST('QSYS/QSQROUTE');                                   //SQL               
000016             DCL-C SQLOPEN CONST('QSYS/QSQROUTE');                                    //SQL               
000016             DCL-C SQLCLSE CONST('QSYS/QSQLCLSE');                                    //SQL               
000016             DCL-C SQLCMIT CONST('QSYS/QSQLCMIT');                                    //SQL               
000016             DCL-C SQFRD CONST(2);                                                    //SQL               
000016             DCL-C SQFCRT CONST(8);                                                   //SQL               
000016             DCL-C SQFOVR CONST(16);                                                  //SQL               
000016             DCL-C SQFAPP CONST(32);                                                  //SQL               
000029           D                 DS                                                       SELECT              
000029           D  SQL_00000              1      2B 0 INZ(128)                             length of header    
000029           D  SQL_00001              3      4B 0 INZ(2)                               statement number    
000029           D  SQL_00002              5      8U 0 INZ(0)                               invocation mark     
000029           D  SQL_00003              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000029           D  SQL_00004             10    128A   CCSID(*JOBRUNMIX)                    end of header       
000029           D  SQL_00005            129    138A   CCSID(*JOBRUNMIX)                    SYSTEMNAME          
000029           D  SQL_00006            139    146D   DATFMT(*MDY/)                        REPORTDATE          
000094           D                 DS                                                       OPEN                
000094           D  SQL_00007              1      2B 0 INZ(128)                             length of header    
000094           D  SQL_00008              3      4B 0 INZ(3)                               statement number    
000094           D  SQL_00009              5      8U 0 INZ(0)                               invocation mark     
000094           D  SQL_00010              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000094           D  SQL_00011             10    127A   CCSID(*JOBRUNMIX)                    end of header       
000094           D  SQL_00012            128    128A   CCSID(*JOBRUNMIX)                    end of header       
000115           D                 DS                                                       FETCH               
000115           D  SQL_00013              1      2B 0 INZ(128)                             length of header    
000115           D  SQL_00014              3      4B 0 INZ(4)                               statement number    
000115           D  SQL_00015              5      8U 0 INZ(0)                               invocation mark     
000115           D  SQL_00016              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000115           D  SQL_00017             10    127A   CCSID(*JOBRUNMIX)                    end of header       
000115           D  SQL_00018            129    148A   CCSID(*JOBRUNMIX)                    GENRE               
000115           D  SQL_00019            149    155S 0                                      BOOKID              
000115           D  SQL_00020            156    205A   CCSID(*JOBRUNMIX)                    BOOK                
000115           D  SQL_00021            206    213T   TIMFMT(*HMS:)                        DURATION            
000115           D  SQL_00022            214    243A   CCSID(*JOBRUNMIX)                    AUTHOR              
000115           D  SQL_00023            244    246P 2                                      PRICE               
000129           D                 DS                                                       CLOSE               
000129           D  SQL_00024              1      2B 0 INZ(128)                             length of header    
000129           D  SQL_00025              3      4B 0 INZ(5)                               statement number    
000129           D  SQL_00026              5      8U 0 INZ(0)                               invocation mark     
000129           D  SQL_00027              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000129           D  SQL_00028             10    127A   CCSID(*JOBRUNMIX)                    end of header       
000129           D  SQL_00029            128    128A   CCSID(*JOBRUNMIX)                    end of header       
000019191204     C/EJECT                                                                                        
000020191204     C**************************************************************************                    
000021191204     C*                        ***   M A I N   R O U T I N E   ***                                  
000022191204     C**************************************************************************                    
000023191204      /FREE                                                                                         
000024191204       // DET E R M I N E   T H E  U S E R   S E R V E R   &   T I M E S T A M P                    
000026191205       //*                 EXEC SQL                                                                 
000027191205       //*                   SELECT CURRENT SERVER, CURRENT DATE                                    
000028191205       //*                     INTO :SYSTEMNAME, :REPORTDATE                                        
000029191205       //*                     FROM SYSIBM/SYSDUMMY1;                                               
000029                SQLER6 = -4;                                                          //SQL 2             
000029                SQLROUTE_CALL(                                                        //SQL               
000029                     SQLCA                                                            //SQL               
000029                   : SQL_00000                                                        //SQL               
000029                );                                                                    //SQL               
000029                IF SQL_00003 = '1';                                                   //SQL               
000029                EVAL SYSTEMNAME = SQL_00005;                                          //SQL               
000029                EVAL REPORTDATE = SQL_00006;                                          //SQL               
000029                ENDIF;                                                                //SQL               
000030191204        EXSR PREPAREFILES;                                                                          
000031191204        WRITE TITLE;                                                                                
000032191204        WRITE COLHDG;                                                                               
000033191204        EXSR GETROW;                                                                                
000034191204        // ENTER THE MISSING COD AFTER THIS LINE                                                    
000035191204                                                                                                    
000036191204       WRITE GENREREC;                                                                              
000037191204       GENREH = GENRE;                                                                              
000038191204       DOW NOT ENDOFFILE;                                                                           
000039191204         IF *IN01 = *ON;                                                                            
000040191204           WRITE TITLE;                                                                             
000041191204           WRITE COLHDG;                                                                            
000042191204           *IN01 =*OFF;                                                                             
000043191204         ENDIF;                                                                                     
000044191204         IF GENREH = GENRE;                                                                         
000045191204           WRITE DETAIL;                                                                            
000048191204         ELSE;                                                                                      
000049191204           GENREH = GENRE;                                                                          
000050191204           WRITE TOTALS;                                                                            
000051191204           TOTALPRICE = 0;                                                                          
000052191204           TOTALBOOKS = 0;                                                                          
000053191204           WRITE GENREREC;                                                                          
000054191204           WRITE DETAIL;                                                                            
000055191204         ENDIF;                                                                                     
000056191205         TOTALBOOKS = TOTALBOOKS + 1;                                                               
000057191205         TOTALPRICE = TOTALPRICE + PRICE;                                                           
000058191204         EXSR GETROW;                                                                               
000059191204       ENDDO;                                                                                       
000060191204       WRITE TOTALS;                                                                                
000061191204       EXSR WRAPUP;                                                                                 
000062191204       // WRTIE UNDERLIMIT;                                                                         
000063191204                                                                                                    
000064191204       *INLR = *ON;                                                                                 
000065191204       RETURN;                                                                                      
000066191205       //**********************************************************************                     
000067191205        // O P E N F I L E S     S U B R O U T I N E                                                
000068191205        //**********************************************************************                    
000069191204                                                                                                    
000070191204       //OPENFIELS SUBROUTINE                                                                       
000071191204       BEGSR PREPAREFILES;                                                                          
000072191204         // SET UP THE TEMPRORARY RESULT STRUCTURE                                                  
000073191204       //*  EXEC SQL                                                                                
000074191204       //*    DECLARE BESTGENRECURSOR CURSOR                                                        
000075191205       //*      FOR                                                                                 
000076191205       //*        (SELECT GENRE, BOOKID, BOOK, DURATION, AUTHOR, PRICE                              
000077191205       //*        FROM BCI433LIB/AUDIBLEBKS                                                         
000078191205       //*        WHERE GENRE = 'Sci Fi/Fantasy' ORDER BY DURATION)                                 
000079191205       //*      UNION ALL                                                                           
000080191205       //*       (SELECT GENRE, BOOKID, BOOK, DURATION, AUTHOR, PRICE                               
000081191205       //*        FROM BCI433LIB/AUDIBLEBKS                                                         
000082191205       //*        WHERE GENRE = 'Thriller/Mystery' ORDER BY DURATION)                               
000083191205       //*      FOR READ ONLY;                                                                      
000091191204                                                                                                    
000092191204         // A TEMPORARY RESULT TABLE IS CREATED                                                     
000093191204       //*  EXEC SQL                                                                                
000094191204       //*    OPEN BESTGENRECURSOR;                                                                 
000094                SQLER6 = -4;                                                          //SQL               
000094                IF SQL_00009 = 0                                                      //SQL               
000094                OR SQL_00010 <> *LOVAL;                                               //SQL               
000094                SQLROUTE_CALL(                                                        //SQL               
000094                     SQLCA                                                            //SQL               
000094                   : SQL_00007                                                        //SQL               
000094                );                                                                    //SQL               
000094                ELSE;                                                                 //SQL               
000094                SQLOPEN_CALL(                                                         //SQL               
000094                     SQLCA                                                            //SQL               
000094                   : SQL_00007                                                        //SQL               
000094                );                                                                    //SQL               
000094                ENDIF;                                                                //SQL               
000095191204         IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                           
000096191204           ENDOFFILE = *ON;                                                                         
000097191204         ENDIF;                                                                                     
000103191204       ENDSR;                                                                                       
000104191205                                                                                                    
000105191205                                                                                                    
000106191205       //**********************************************************************                     
000107191205        // G E T  R O W             S U B R O U T I N E                                             
000108191205        //**********************************************************************                    
000109191204                                                                                                    
000110191204       // GET ROW SUBROUTINE                                                                        
000111191204       BEGSR GETROW;                                                                                
000112191204       //*  EXEC SQL                                                                                
000113191204       //*    FETCH NEXT                                                                            
000114191204       //*      FROM BESTGENRECURSOR                                                                
000115191205       //*    INTO :AUDIBLEBKSREC;                                                                  
000115                SQLER6 = -4;                                                          //SQL 4             
000115                SQLROUTE_CALL(                                                        //SQL               
000115                     SQLCA                                                            //SQL               
000115                   : SQL_00013                                                        //SQL               
000115                );                                                                    //SQL               
000115                IF SQL_00016 = '1';                                                   //SQL               
000115                EVAL GENRE = SQL_00018;                                               //SQL               
000115                EVAL BOOKID = SQL_00019;                                              //SQL               
000115                EVAL BOOK = SQL_00020;                                                //SQL               
000115                EVAL DURATION = SQL_00021;                                            //SQL               
000115                EVAL AUTHOR = SQL_00022;                                              //SQL               
000115                EVAL PRICE = SQL_00023;                                               //SQL               
000115                ENDIF;                                                                //SQL               
000116191204         IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                           
000117191204           ENDOFFILE = *ON;                                                                         
000118191204         ENDIF;                                                                                     
000119191204       ENDSR;                                                                                       
000120191204                                                                                                    
000121191205       //**********************************************************************                     
000122191205        // W R A P  U P          S U B R O U T I N E                                                
000123191205        //**********************************************************************                    
000124191205                                                                                                    
000125191204                                                                                                    
000126191204       // WRAP UP SUBROUTINE                                                                        
000127191204       BEGSR WRAPUP;                                                                                
000128191204       //*  EXEC SQL                                                                                
000129191204       //*    CLOSE BESTGENRECURSOR;                                                                
000129                SQLER6 = 5;                                                           //SQL               
000129                IF SQL_00026 = 0;                                                     //SQL               
000129                SQLROUTE_CALL(                                                        //SQL               
000129                     SQLCA                                                            //SQL               
000129                   : SQL_00024                                                        //SQL               
000129                );                                                                    //SQL               
000129                ELSE;                                                                 //SQL               
000129                SQLCLSE_CALL(                                                         //SQL               
000129                     SQLCA                                                            //SQL               
000129                   : SQL_00024                                                        //SQL               
000129                );                                                                    //SQL               
000129                ENDIF;                                                                //SQL               
000130191204         IF SQLCODE <> 0 OR SQLWN0 = 'W';                                                           
000131191204           ENDOFFILE = *ON;                                                                         
000132191204         ENDIF;                                                                                     
000133191205                                                                                                    
000152191204       ENDSR;                                                                                       
000153191204                                                                                                    
