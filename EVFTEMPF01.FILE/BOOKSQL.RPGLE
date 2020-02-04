000100191204      //********************************************************************************            
000101191203       //  BkCustomer READ BY NATIVE LANGUAGE (ILE RPG)                                             
000102191203       //  Book ROW RETRIEVED WITH EMBEDDED SQL                                                     
000103191203       //  DETAIL REPORT LINE INCLUDES INFORMATION FROM BkCustomer and AudibleBks                   
000104191203       //  SUMMARRY REPORT INFORMATION RETRIEVED WITH EMBEDDED SQL STATEMENTS                       
000105191203       //********************************************************************************           
000108191203       //Files                                                                                      
000109191204       DCL-F BKCUSTOMER DISK(*EXT) KEYED USAGE(*INPUT)                                              
000110191203       RENAME(BKCUSTOMER:BKCUSTR);                                                                  
000111191204       DCL-F BOOKRPT PRINTER OFLIND(*IN01);                                                         
000112191203                                                                                                    
000113191203       //PASSED PARAMETER                                                                           
000114191204       DCL-PI MAIN EXTPGM('BOOKSQL');                                                               
000115191203         REPRTTITLE CHAR(15);                                                                       
000116191203       END-PI;                                                                                      
000117191203                                                                                                    
000118191203                                                                                                    
000119191203       //GET FIELDS FRM THE TABLE ACCESSED WITH EMBEDDED SQL                                        
000120191203       DCL-DS AUDIBLEBKS EXT END-DS;                                                                
000121191203                                                                                                    
000122191203       //V A R I A B L E S (FOR UNKNOWN VALUES AND DUMMY)                                           
000123191203       DCL-S INDGENRE BINDEC(4:0);                                                                  
000124191203       DCL-S DUMMY ZONED(1:0);                                                                      
000125191203                                                                                                    
000126191204                                                                                                    
000127191204       //**********************************************************************                     
000128191204       //                     ***   M A I N   R O U T I N E   ***                                   
000129191204       //**********************************************************************                     
000130191204                                                                                                    
000130             /SET CCSID(*CHAR:*JOBRUNMIX)                                                                 
000130             // SQL COMMUNICATION AREA                                                //SQL               
000130             DCL-DS SQLCA;                                                            //SQL               
000130               SQLCAID CHAR(8) INZ(X'0000000000000000');                              //SQL               
000130                SQLAID CHAR(8) OVERLAY(SQLCAID);                                      //SQL               
000130               SQLCABC INT(10);                                                       //SQL               
000130                SQLABC BINDEC(9) OVERLAY(SQLCABC);                                    //SQL               
000130               SQLCODE INT(10);                                                       //SQL               
000130                SQLCOD BINDEC(9) OVERLAY(SQLCODE);                                    //SQL               
000130               SQLERRML INT(5);                                                       //SQL               
000130                SQLERL BINDEC(4) OVERLAY(SQLERRML);                                   //SQL               
000130               SQLERRMC CHAR(70);                                                     //SQL               
000130                SQLERM CHAR(70) OVERLAY(SQLERRMC);                                    //SQL               
000130               SQLERRP CHAR(8);                                                       //SQL               
000130                SQLERP CHAR(8) OVERLAY(SQLERRP);                                      //SQL               
000130               SQLERR CHAR(24);                                                       //SQL               
000130                SQLER1 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000130                SQLER2 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000130                SQLER3 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000130                SQLER4 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000130                SQLER5 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000130                SQLER6 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL               
000130                SQLERRD INT(10) DIM(6) OVERLAY(SQLERR);                               //SQL               
000130               SQLWRN CHAR(11);                                                       //SQL               
000130                SQLWN0 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000130                SQLWN1 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000130                SQLWN2 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000130                SQLWN3 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000130                SQLWN4 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000130                SQLWN5 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000130                SQLWN6 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000130                SQLWN7 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000130                SQLWN8 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000130                SQLWN9 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000130                SQLWNA CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL               
000130                SQLWARN CHAR(1) DIM(11) OVERLAY(SQLWRN);                              //SQL               
000130               SQLSTATE CHAR(5);                                                      //SQL               
000130                SQLSTT CHAR(5) OVERLAY(SQLSTATE);                                     //SQL               
000130             END-DS SQLCA;                                                            //SQL               
000130             DCL-PR SQLROUTE_CALL EXTPGM(SQLROUTE);                                   //SQL               
000130               CA LIKEDS(SQLCA);                                                      //SQL               
000130               *N BINDEC(4) OPTIONS(*NOPASS);                                         //SQL               
000130               *N CHAR(1) OPTIONS(*NOPASS);                                           //SQL               
000130             END-PR SQLROUTE_CALL;                                                    //SQL               
000130             DCL-PR SQLOPEN_CALL EXTPGM(SQLOPEN);                                     //SQL               
000130               CA LIKEDS(SQLCA);                                                      //SQL               
000130               *N BINDEC(4);                                                          //SQL               
000130             END-PR SQLOPEN_CALL;                                                     //SQL               
000130             DCL-PR SQLCLSE_CALL EXTPGM(SQLCLSE);                                     //SQL               
000130               CA LIKEDS(SQLCA);                                                      //SQL               
000130               *N BINDEC(4);                                                          //SQL               
000130             END-PR SQLCLSE_CALL;                                                     //SQL               
000130             DCL-PR SQLCMIT_CALL EXTPGM(SQLCMIT);                                     //SQL               
000130               CA LIKEDS(SQLCA);                                                      //SQL               
000130               *N BINDEC(4);                                                          //SQL               
000130             END-PR SQLCMIT_CALL;                                                     //SQL               
000130             /RESTORE CCSID(*CHAR)                                                                        
000130             DCL-C SQLROUTE CONST('QSYS/QSQROUTE');                                   //SQL               
000130             DCL-C SQLOPEN CONST('QSYS/QSQROUTE');                                    //SQL               
000130             DCL-C SQLCLSE CONST('QSYS/QSQLCLSE');                                    //SQL               
000130             DCL-C SQLCMIT CONST('QSYS/QSQLCMIT');                                    //SQL               
000130             DCL-C SQFRD CONST(2);                                                    //SQL               
000130             DCL-C SQFCRT CONST(8);                                                   //SQL               
000130             DCL-C SQFOVR CONST(16);                                                  //SQL               
000130             DCL-C SQFAPP CONST(32);                                                  //SQL               
000208           D                 DS                                                       SELECT              
000208           D  SQL_00000              1      2B 0 INZ(128)                             length of header    
000208           D  SQL_00001              3      4B 0 INZ(1)                               statement number    
000208           D  SQL_00002              5      8U 0 INZ(0)                               invocation mark     
000208           D  SQL_00003              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000208           D  SQL_00004             10    128A   CCSID(*JOBRUNMIX)                    end of header       
000208           D  SQL_00005            129    132P 0                                      BOOKPUR#            
000208           D  SQL_00006            133    182A   CCSID(*JOBRUNMIX)                    BOOK                
000208           D  SQL_00007            183    202A   CCSID(*JOBRUNMIX)                    GENRE               
000208           D  SQL_00009            203    205P 2                                      PRICE               
000208           D  SQL_00008            206    207B 0                                      INDGENRE            
000247           D                 DS                                                       SELECT              
000247           D  SQL_00010              1      2B 0 INZ(128)                             length of header    
000247           D  SQL_00011              3      4B 0 INZ(2)                               statement number    
000247           D  SQL_00012              5      8U 0 INZ(0)                               invocation mark     
000247           D  SQL_00013              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000247           D  SQL_00014             10    128A   CCSID(*JOBRUNMIX)                    end of header       
000247           D  SQL_00015            129    130P 0                                      TOTQTY              
000257           D                 DS                                                       SELECT              
000257           D  SQL_00016              1      2B 0 INZ(128)                             length of header    
000257           D  SQL_00017              3      4B 0 INZ(3)                               statement number    
000257           D  SQL_00018              5      8U 0 INZ(0)                               invocation mark     
000257           D  SQL_00019              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000257           D  SQL_00020             10    128A   CCSID(*JOBRUNMIX)                    end of header       
000257           D  SQL_00021            129    130P 0                                      MOSTBOOKS           
000267           D                 DS                                                       SELECT              
000267           D  SQL_00022              1      2B 0 INZ(128)                             length of header    
000267           D  SQL_00023              3      4B 0 INZ(4)                               statement number    
000267           D  SQL_00024              5      8U 0 INZ(0)                               invocation mark     
000267           D  SQL_00025              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000267           D  SQL_00026             10    128A   CCSID(*JOBRUNMIX)                    end of header       
000267           D  SQL_00027            129    130P 0                                      BKCUSTTOT           
000277           D                 DS                                                       SELECT              
000277           D  SQL_00028              1      2B 0 INZ(128)                             length of header    
000277           D  SQL_00029              3      4B 0 INZ(5)                               statement number    
000277           D  SQL_00030              5      8U 0 INZ(0)                               invocation mark     
000277           D  SQL_00031              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay        
000277           D  SQL_00032             10    128A   CCSID(*JOBRUNMIX)                    end of header       
000277           D  SQL_00033            129    138A   CCSID(*JOBRUNMIX)                    SYSTEMNAME          
000277           D  SQL_00034            139    146D   DATFMT(*MDY/)                        REPORTDATE          
000131191203            EXSR SUMMARYINFO;                                                                       
000132191203            //REPRTTITLE = REPRTTITLEIN;                                                            
000133191203            WRITE TITLE;                                                                            
000134191203            WRITE COLHDG;                                                                           
000135191203            READ  BKCUSTOMER;                                                                       
000136191203            DOW NOT %EOF;                                                                           
000137191203              EXSR SQLSELECT;                                                                       
000138191203                                                                                                    
000139191204       //EVAL(H) DISPRICE = PRICE * (1- DISCOUNT);                                                  
000140191204      // EVAL(H) EXPRICE = DISPRICE * QTY;                                                          
000141191203                                                                                                    
000142191203              IF *IN01 = *ON;                                                                       
000143191203                WRITE TITLE;                                                                        
000144191203                WRITE COLHDG;                                                                       
000145191203                *IN01 = *OFF;                                                                       
000146191203              ENDIF;                                                                                
000147191203              WRITE DETAIL;                                                                         
000148191203              READ BKCUSTOMER;                                                                      
000149191203            ENDDO;                                                                                  
000150191203           //RITE SUMMARY;                                                                          
000151191204           WRITE BCI433;                                                                            
000152191203            *INLR = *ON;                                                                            
000153191203            RETURN;                                                                                 
000156191203      //**********************************************************************                      
000157191203      // S Q L S E L E C T   S U B R O U T I N E                                                    
000158191203      //**********************************************************************                      
000159191203      //A ROW FROM THE AUDIBLEBKS TABLE THAT HAS THE SAME BOOK NUMBER AS THE                        
000160191203      // ONE READ FROM THE BKCUSTOMER FILES IS RETRIEVED TO FIND OUT BOOK INFORMATION               
000161191203      // ALLOW FOR NULL VALUES BEING STORED IN THE GENRE COLUMN                                     
000162191203        BEGSR SQLSELECT;                                                                            
000163191204       //   EXEC SQL                                                                                
000164191204       //     SELECT BOOK, GENRE, PRICE                                                             
000165191204       //       INTO :BOOK, :GENRE, :INDGENRE, :PRICE //HAS NULL VALUE FOR :GENRE                   
000166191204       //     FROM BCI433LIB/AUDIBLEBKS                                                             
000167191204       //     WHERE  BOOKID = :BOOKPUR#;                                                            
000168191204       //   SELECT; //HOLDING RECOCORD-LEVEL ERRORS                                                 
000169191204       //     WHEN SQLSTATE = '00000';//SUCCESS                                                     
000170191204       //       DUMMY = 0;                                                                          
000171191204       //       WHEN SQLSTATE = '02000';  // RECORD NOT FOUND FOR THE BOOKID                        
000172191204       //         BOOK='Not Found';                                                                 
000173191204       //         PRICE = -999.99;                                                                  
000174191204       //         GENRE = *ALL'*';                                                                  
000175191204       //         //SOMEDATE = D'9999-09-09';                                                       
000176191204       //        WHEN %SUBST(SQLSTATE :1 :2) = '01';                                                
000177191204       //     // BOOK = *ALL'*';                                                                    
000178191204       //     BOOK = 'Warning';                                                                     
000179191204       //        PRICE = -999.99;                                                                   
000180191204       //        GENRE = *ALL'*';                                                                   
000181191204       //      OTHER;                                                                               
000182191204       //    //  BOOK = *ALL'*';                                                                    
000183191204       //    BOOK = 'Error';                                                                        
000184191204       //        PRICE = -999.99;                                                                   
000185191204       //        GENRE = *ALL'*';                                                                   
000186191204       //  ENDSL;                                                                                   
000187191204       //                                                                                           
000188191204       //  IF INDGENRE = -1; // HANDLING FIELD-LEVEL ERRORS, E.G NULL VALUE, DATA FIELD             
000189191204       //    GENRE = 'UNKNOWN GENRE';                                                               
000190191204       //  ELSE;             // OTHER ERROR, E.G WRONG DATA FORMAT                                  
000191191204       //    IF INDGENRE <> 0;                                                                      
000192191204       //      GENRE = 'GENRE TEXT PROBLEM';                                                        
000193191204       //    ENDIF;                                                                                 
000194191204       //  ENDIF;                                                                                   
000195191204       //      SELECT;                                                                              
000196191204       //      WHEN DISCOUNT <> 0;                                                                  
000197191204       //        EVAL(H) DISPRICE = PRICE - (PRICE * DISCOUNT);                                     
000198191204       //       OTHER;                                                                              
000199191204       //          DISPRICE = PRICE;                                                                
000200191204       //    ENDSL;                                                                                 
000201191204       //                                                                                           
000202191204       //    EXPRICE = DISPRICE * QTY;                                                              
000203191204       //*  EXEC SQL                                                                                
000204191204       //*  SELECT BOOK, GENRE, PRICE                                                               
000205191204       //*                                                                                          
000206191204       //*    INTO :BOOK, :GENRE :INDGENRE, :PRICE                                                  
000207191204       //*    FROM BCI433LIB/AUDIBLEBKS                                                             
000208191204       //*    WHERE BOOKID = :BOOKPUR#;                                                             
000208                SQL_00005 = BOOKPUR#;                                                 //SQL               
000208                SQLER6 = -4;                                                          //SQL 1             
000208                SQLROUTE_CALL(                                                        //SQL               
000208                     SQLCA                                                            //SQL               
000208                   : SQL_00000                                                        //SQL               
000208                );                                                                    //SQL               
000208                IF SQL_00003 = '1';                                                   //SQL               
000208                EVAL BOOK = SQL_00006;                                                //SQL               
000208                EVAL GENRE = SQL_00007;                                               //SQL               
000208                EVAL INDGENRE = SQL_00008;                                            //SQL               
000208                EVAL PRICE = SQL_00009;                                               //SQL               
000208                ENDIF;                                                                //SQL               
000209191204                                                                                                    
000210191204           SELECT;                                                                                  
000211191204             WHEN SQLSTATE = '00000';                                                               
000212191204               DUMMY = 0;                                                                           
000213191204             WHEN SQLSTATE = '02000';                                                               
000214191204               BOOK  = 'NOT FOUND';                                                                 
000215191204             WHEN %SUBST(SQLSTATE :1 :2) = '01';                                                    
000216191204               BOOK = 'WARNING';                                                                    
000217191204             OTHER;                                                                                 
000218191204               BOOK = 'ERROR';                                                                      
000219191204           ENDSL;                                                                                   
000220191204                                                                                                    
000221191204           IF INDGENRE = -1;                                                                        
000222191204             GENRE = 'UNKNOWN GENRE';                                                               
000223191204           ENDIF;                                                                                   
000224191204                                                                                                    
000225191204           SELECT;                                                                                  
000226191204             WHEN DISCOUNT <> 0;                                                                    
000227191204               EVAL(H) DISPRICE = PRICE - (PRICE * DISCOUNT);                                       
000228191204              OTHER;                                                                                
000229191204                 DISPRICE = PRICE;                                                                  
000230191204           ENDSL;                                                                                   
000231191204                                                                                                    
000232191204           EXPRICE = DISPRICE * QTY;                                                                
000233191204                                                                                                    
000234191204                                                                                                    
000235191203        ENDSR;                                                                                      
000236191203                                                                                                    
000237191203       //**********************************************************************                     
000238191203        // S U M M A R Y I N F O    S U B R O U T I N E                                             
000239191203        //**********************************************************************                    
000240191203                                                                                                    
000241191203          BEGSR SUMMARYINFO;                                                                        
000242191203            // D E T E R M I N E  T O T A L S  F O R   BKCUSTOMER                                   
000243191203       //*        EXEC SQL                                                                          
000244191203       //*          SELECT SUM(QTY)                                                                 
000245191203       //*            INTO :TOTQTY                                                                  
000246191203       //*            FROM BCI433LIB/BKCUSTOMER AS A, BCI433LIB/AUDIBLEBKS AS B                     
000247191203       //*            WHERE A.BOOKPUR# = B.BOOKID;                                                  
000247                SQLER6 = -4;                                                          //SQL 2             
000247                SQLROUTE_CALL(                                                        //SQL               
000247                     SQLCA                                                            //SQL               
000247                   : SQL_00010                                                        //SQL               
000247                );                                                                    //SQL               
000247                IF SQL_00013 = '1';                                                   //SQL               
000247                EVAL TOTQTY = SQL_00015;                                              //SQL               
000247                ENDIF;                                                                //SQL               
000248191203                                                                                                    
000249191204               IF SQLCODE <> 0 OR SQLWN0= 'N';                                                      
000250191203                 TOTQTY = -999;                                                                     
000251191203               ENDIF;                                                                               
000252191203                                                                                                    
000253191203            // D E T E R M I N E   HIGHEST QUANTITY CUSTOMER PURCHASE                               
000254191203       //*           EXEC SQL                                                                       
000255191203       //*             SELECT MAX(QTY)                                                              
000256191203       //*               INTO :MOSTBOOKS                                                            
000257191203       //*               FROM BCI433LIB/BKCUSTOMER;                                                 
000257                SQLER6 = -4;                                                          //SQL 3             
000257                SQLROUTE_CALL(                                                        //SQL               
000257                     SQLCA                                                            //SQL               
000257                   : SQL_00016                                                        //SQL               
000257                );                                                                    //SQL               
000257                IF SQL_00019 = '1';                                                   //SQL               
000257                EVAL MOSTBOOKS = SQL_00021;                                           //SQL               
000257                ENDIF;                                                                //SQL               
000258191203                                                                                                    
000259191203                      IF SQLCODE <> 0 OR SQLWN0 = 'W';                                              
000260191203                      MOSTBOOKS = -999;                                                             
000261191203                      ENDIF;                                                                        
000262191203                                                                                                    
000263191203            // D E T E R M I N E   TOTAL QUANTITY BOOKS PURCHASED FOR ALL CUSTOMERS                 
000264191203       //*               EXEC SQL                                                                   
000265191203       //*                 SELECT COUNT(*)                                                          
000266191203       //*                   INTO :BKCUSTTOT                                                        
000267191203       //*                   FROM BCI433LIB/BKCUSTOMER;                                             
000267                SQLER6 = -4;                                                          //SQL 4             
000267                SQLROUTE_CALL(                                                        //SQL               
000267                     SQLCA                                                            //SQL               
000267                   : SQL_00022                                                        //SQL               
000267                );                                                                    //SQL               
000267                IF SQL_00025 = '1';                                                   //SQL               
000267                EVAL BKCUSTTOT = SQL_00027;                                           //SQL               
000267                ENDIF;                                                                //SQL               
000268191203                                                                                                    
000269191203                      IF SQLCODE <> 0 OR SQLWN0 = 'W';                                              
000270191203                        BKCUSTTOT = -999;                                                           
000271191203                      ENDIF;                                                                        
000272191203                                                                                                    
000273191203            // D E T E R M I N E   T H E   U S E R   S E R V E R   &   T I M E S T A M P            
000274191203       //*                 EXEC SQL                                                                 
000275191203       //*                   SELECT CURRENT SERVER, CURRENT DATE                                    
000276191203       //*                     INTO :SYSTEMNAME, :REPORTDATE                                        
000277191203       //*                     FROM SYSIBM/SYSDUMMY1;                                               
000277                SQLER6 = -4;                                                          //SQL 5             
000277                SQLROUTE_CALL(                                                        //SQL               
000277                     SQLCA                                                            //SQL               
000277                   : SQL_00028                                                        //SQL               
000277                );                                                                    //SQL               
000277                IF SQL_00031 = '1';                                                   //SQL               
000277                EVAL SYSTEMNAME = SQL_00033;                                          //SQL               
000277                EVAL REPORTDATE = SQL_00034;                                          //SQL               
000277                ENDIF;                                                                //SQL               
000278191203          ENDSR;                                                                                    
000279191203                                                                                                    
