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
006300191120               EXEC SQL                   // DB2 CURSOR: DECLARE|OPEN|FETCH(MOVE TO NEXT) | CLOSE
006301191120                 DECLARE ALLPROVCURSOR CURSOR  // READ SQLCURSOR.DOCX UNDER IFS-ROOT -> BCI433NOTES
006302191120                   FOR
006303191120                   SELECT CUSTID, TRIM(FNAME) || ' ' || LNAME,
006304191120                          CITY, PURCHASE, PDATE,
006305191120                          'Ontario' as PROVINCE
006306191120                   FROM BCI433LIB/ONTARIO
006307191120                   WHERE PURCHASE > :LowLimit
006308191120                   UNION ALL
006310191120                   SELECT CUSTID, TRIM(FNAME) || ' ' || TRIM(LNAME),
006311191120                          CITY, PURCHASE, PDATE,
006312191120                          'Quebec' as PROVINCE
006313191120                   FROM BCI433LIB/QUEBEC
006314191120                   WHERE PURCHASE > :LowLimit
006315191120                   UNION ALL
006316191120                 SELECT CUSTID, TRIM(FNAME) || ' ' || TRIM(LNAME),
006317191120                          CITY, PURCHASE, PDATE,
006318191120                          'Manitoba' as PROVINCE
006319191120                   FROM BCI433LIB/MANITOBA
006320191120                   WHERE PURCHASE > :LowLimit
006321191120                 FOR READ ONLY;
008500100309        // A   T E M P O R A R Y   R E S U L T   T A B L E   I S   C R E A T E D
009300191120                  EXEC SQL
009301191120               OPEN ALLPROVCURSOR;
009302191120             IF SQLCODE <> 0 OR SQLWN0 = 'W';
009303191120               EndOfFile = *ON;
009304191120             ENDIF;
009400100309            ENDSR;
009500100309        //**********************************************************************
009600100309        //   G E T     R O W    S U B R O U T I N E
009700100309        //**********************************************************************
009800100309            BEGSR     GETROW;
009801191120              EXEC SQL
009802191120               FETCH NEXT
009803191120                 FROM ALLPROVCURSOR
009804191120                 INTO :CustomerRecord;
009805191120            IF SQLCODE <> 0 OR SQLWN0 = 'W';
009806191120              EndOfFile = *ON;
009807191120            ENDIF;
010900100309             ENDSR;
011000100309        //**********************************************************************
011100100309        // W R A P U P     S U B R O U T I N E
011200100309        //**********************************************************************
011300100309           BEGSR WRAPUP;
011301191120             EXEC SQL
011302191120               CLOSE ALLPROVCURSOR;
011303191120
011304191120             IF SQLCODE <> 0 OR SQLWN0 = 'W';
011305191120               ENDOFFILE = *ON;
011307191120             ENDIF;
011308191120
011309191120             EXEC SQL
011310191120               SELECT COUNT(*) INTO :OntTotal
011311191120                 FROM BCI433LIB/ONTARIO
011312191120               WHERE PURCHASE <= :LOWLIMIT;
011313191120
011314191120             IF SQLCODE <> 0 OR SQLWN0 = 'W';
011315191120               OntTotal = -999;
011316191120             ENDIF;
011317191120             EXEC SQL
011318191120               SELECT COUNT(*) INTO :QUETOTAL
011319191120                 FROM BCI433LIB/QUEBEC
011320191120                 WHERE PURCHASE <= :LowLimit;
011321191120
011322191120             IF SQLCODE <> 0 OR SQLWN0 = 'W';
011323191120               QueTotal = -999;
011324191120             ENDIF;
011325191120
011326191120
011327191120             EXEC SQL
011328191120               SELECT COUNT(*) INTO :MANTOTAL
011329191120                 FROM BCI433LIB/MANITOBA
011330191120                 WHERE PURCHASE <= :LowLimit;
011331191120
011332191120             IF SQLCODE <> 0 OR SQLWN0 = 'W';
011333191120               ManTotal = -999;
011334191120             ENDIF;
014600100309          ENDSR;
014601190315
