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
004900191114            EXEC SQL
004901191114             SELECT PHNLDC + PHNCIT DAYS, PHNLDC,
004902191114                     CstPhN, PHNCOM, CstSLN
004903191114             INTO  :NEXTCDATE :INDNEXTCDATE, :PHNLDC :INDLastCDate,
004904191114                   :CSTPHN, :PHNCOM, :CSTSLN
004905191114             FROM   BCI433LIB/CONTACTW19
004906191114             WHERE CSTNUM = :CSTNUM;
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
004931191120           IF IndLastCdate = -1;                // indicators
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
007600191114                   EXEC SQL
007601191114              SELECT COUNT(*) INTO :CONTACTT
007602191114                     FROM BCI433LIB/CONTACTW19;
007603191114
007604191114              IF (SQLCODE <> 0) OR(SQLWN0 = 'W');
007605191114                CONTACTT= -99999;
007606191114              ENDIF;
007607191114
007608191114              EXEC SQL
007609191114                SELECT COUNT(*) INTO :CUSTOMERT
007610191114                  FROM BCI433LIB/CUSTOMER19;
007611191114
007612191114              IF (SQLCODE <> 0) OR (SQLWN0 = 'W');
007613191114                CUSTOMERT = -99999;
007614191114
007615191114              ENDIF;
007616191114
008900190314
009000190314        // D E T E R M I N E   N U M B E R   O F   U N K N O W N   LAST   DATE CALLED
009100191114                   EXEC SQL
009101191114              SELECT COUNT(*) INTO :UNKNOWNT
009102191114                     FROM BCI433LIB/CONTACTW19
009103191114                     WHERE CstLastCallDate IS NULL;
009104191114
009105191114              IF NOT (SQLCODE = 0) OR (SQLWN0 = 'W');
009106191114                UNKNOWNT  = -99999;
009107191114              ENDIF;
010000190314
010100080923        //  D E T E R M I N E   O L D E S T   &  M O S T   R E C E N T  L A S T
010101191114
010102191114        EXEC SQL
010103191114          SELECT MIN(PHNLDC) INTO :OLDESTDATE
010104191114            FROM BCI433LIB/CONTACTW19;
010200080923
010300191114                  IF (SQLCODE <> 0) OR(SQLWN0 = 'W') AND (SQLWN2 <> 'W');
010302191114                OLDESTDATE  = D'9999-09-09';
010303191114              ENDIF;
010304191114
010400191114            EXEC SQL
010500191114              SELECT MAX(PHNLDC) INTO :RECENTDATE
010501191114                FROM BCI433LIB/CONTACTW19;
010502191114
010503191114                IF (SQLCODE <> 0) OR  (SQLWN0 = 'W') AND
010504191114                    (SQLWN2 <>  'W');
010600191114                       RECENTDATE = D'9999-09-09';
010601191114                       ENDIF;
012000190314
012100080923       // D E T E R M I N E   T H E   U S E R   S E R V E R   &   T I M E S T A
012200191114                            EXEC SQL
012201191114               SELECT USER, CURRENT TIMESTAMP, CURRENT SERVER
012202191114                   INTO :USER,
012203191114                        :TIMEStamp,
012204191114                        :Server
012205191114                   FROM SYSIBM/SYSDUMMY1;
012800080923                         ENDSR;
