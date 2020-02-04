000100190927       DCL-F INSUREDSP WORKSTN;
000101191005       DCL-S BASERATE PACKED(4:2);
000103191003
000104190927          EXSR CLEAR;
000105190927          EXFMT GETDATA;
000106190927          DOW NOT(*IN03);
000107190927             IF GENDER = '';
000108190927               *IN97 = *ON;         // BLANK GENDER
000109190927               EXFMT GETDATA;
000110190927               *IN97 = *OFF;
000111190927               ITER;              // GO TO ENDDO FOR NEXT LOOP ITERATION
000112190927             ELSEIF SMOKER = '';
000113190927               *IN98 = *ON;
000114190927               EXFMT GETDATA;
000115190927               *IN98 = *OFF;
000116190927               ITER;
000117190927               ELSE;
000118190927                  EXSR GETQUOTE;
000119190927                  *IN60 = *ON;
000120190927                  WRITE GETDATA;
000121190927                  EXFMT INSQUOTE;
000122190927                  *IN60 = *OFF;
000123190927           ENDIF;
000124190927
000125190927            IF *IN03 = *OFF;
000126190927              EXSR CLEAR;
000127190927              EXFMT GETDATA;
000128190927            ENDIF;
000129190927        ENDDO;
000130190927        *INLR = *ON;
000131190927        RETURN;
000132190927
000133190927       BEGSR GETQUOTE;
000134191005         MPREMIUM = 0;
000135191003         CoverAmt = 0;
000136191003
000137191003         if birthdate >= %date();
000138191007           *IN99 = *ON;
000139191005             comment = 'Age out of Coverage Range';
000140191007
000141191003         else;
000142191003           Age = %DIFF (%date():birthdate:*years);
000143191003           if Age >= 75 OR Age < 18;
000144191007             *IN99 = *ON;
000145191003              comment = 'Age out of Coverage Range';
000146191007
000147191003           else;
000148191003            CoverAmt = Coverage * 25000;
000149191007            *IN99 = *OFF;
000150191003
000151191003            if Gender = 'M';
000152191003              if Smoker = 'N';
000153191003                select;
000154191003                  when Age < 30;
000155191003                    BaseRate = 7.83;
000156191003                  when Age < 45;
000157191003                    BaseRate = 15.20;
000158191003                  when Age < 60;
000159191003                    BaseRate = 26.58;
000160191003                  when Age < 75;
000161191003                    BaseRate = 38.06;
000162191003                ENDSL; // end of select for Male NON-Smokers
000163191003               else; // (if Smoker = 'Y')
000164191003                 select;
000165191003                  when Age < 30;
000166191003                    BaseRate = 13.34;
000167191003                  when Age < 45;
000168191003                    BaseRate = 21.19;
000169191003                  when Age < 60;
000170191003                    BaseRate = 32.75;
000171191003                  when Age < 75;
000172191003                    BaseRate = 50.73;
000173191003                ENDSL; // end of select for Male Smokers
000174191003              ENDIF; // end of Smoker = 'N' if statement for Males
000175191003              else; // (if Gender = 'F')
000176191003                if Smoker = 'N';
000177191003                select;
000178191003                  when Age < 30;
000179191003                    BaseRate = 5.53;
000180191003                  when Age < 45;
000181191003                    BaseRate = 8.86;
000182191003                  when Age < 60;
000183191003                    BaseRate = 19.00;
000184191003                  when Age < 75;
000185191003                    BaseRate = 31.38;
000186191003                ENDSL; // end of select for Female NON-Smokers
000187191003               else; // (if Smoker = 'Y')
000188191003                 select;
000189191003                  when Age < 30;
000190191003                    BaseRate = 9.28;
000191191003                  when Age < 45;
000192191003                    BaseRate = 15.38;
000193191003                  when Age < 60;
000194191003                    BaseRate = 27.44;
000195191003                  when Age < 75;
000196191003                    BaseRate = 42.63;
000197191003                ENDSL; // end of select for Female Smokers
000198191003              ENDIF; // end of Smoker = 'N' if statement for Females
000199191003            ENDIF; // end of Gender = 'M' if statement
000200191003
000201191003            MPREMIUM =  BaseRate * Coverage;
000202191003
000203191003           endif; // end of coverage validation based on age (age >= 18 AND age < 75)
000204191003         ENDIF; // end of date validation (age > 0)
000205191003       ENDSR;
000206190927
000207190927       BEGSR CLEAR;
000208190927             GENDER = '';
000209190927             BIRTHDATE = %DATE();
000210190927             COVERAGE = 1;
000211190927             SMOKER = '';
000212190927             COMMENT = '';
000213190927       ENDSR;
000214190927
