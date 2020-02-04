000100191127       CTL-OPT NOMAIN DATFMT(*USA);
000101191127       /COPY LAB10ZFUN,DAYPROTOS
000102191127       //DCL-S DAYNAME CHAR(9);
000103191127       DCL-PROC DAYNUMNAME EXPORT;
000104191127         DCL-PI *N CHAR(9);
000105191127           DAYIN PACKED(1)  // ACCEPTS VALID INPUTS (1-7) ONLY
000106191127         END-PI;
000107191127         DCL-DS DAYDATA;
000108191127           *N CHAR(9) INZ('Monday');
000109191127           *N CHAR(9) INC('Tuesday');
000110191127           *N CHAR(9) INC('Wednesday');
000111191127           *N CHAR(9) INC('Thursday');
000112191127           *N CHAR(9) INC('Friday');
000113191127           *N CHAR(9) INC('Saturday');
000114191127           *N CHAR(9) INC('Sunday');
000115191127           DAYARRAY CHAR(9) DIM(7) POS(1); // 7-elem array. POS(Starting-position)
000116191127         END-DS;
000117191127         RETURN DAYARRAY(DAYIN);
000118191127           SELECT;
000119191127             WHEN NUMBER = 1;
000120191127               DAYNAME = 'Monday';
000121191127               WHEN NUMBER = 2;
000122191127                 DAYNAME = 'Tuesday';
000123191127                 WHEN NUMBER = 3;
000124191127                   DAYNAME = 'Wednesday';
000125191127                   WHEN NUMBER = 4;
000126191127                     DAYNAME = 'Thursday';
000127191127                     WHEN NUMBER = 5;
000128191127                       DAYNAME = 'Friday';
000129191127                       WHEN NUMBER = 6;
000130191127                         DAYNAME = 'Saturday';
000131191127                         WHEN NUMBER = 7'
000132191127                           DAYNAME = 'Sunday';
000133191127                           OTHER;
000134191127                             DAYNAME = 'Unknown';
000135191127           ENDSL;
000136191127           RETURN DAYNAME;
000137191127       END-PROC;
