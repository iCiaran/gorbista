       IDENTIFICATION DIVISION.
       PROGRAM-ID. GORBISTA.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PROGRAM-FILE ASSIGN TO DYNAMIC PROGRAM-PATH
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD PROGRAM-FILE.
       01 INSTRUCTION-RECORD.
         03 OPCODE-RECORD      PIC X(1).
         03 OPERAND-RECORD     PIC 9(3).
         
       WORKING-STORAGE SECTION.
       01 GORBISTA.
         03 PC                 PIC 9(3).
         03 X                  PIC 9(3).
         03 RAM                PIC 9(3) OCCURS 256 TIMES.
         03 INSTRUCTION                 OCCURS 256 TIMES.
           05 OPCODE           PIC X(1).
           05 OPERAND          PIC 9(3).
       01 PROGRAM-PATH         PIC X(200).
       01 ARG-COUNT            PIC 9(3).
       01 ERROR-STRING         PIC X(100). 
       01 EOF                  PIC X(1).
       01 FILE-LINE            PIC 9(3).

       PROCEDURE DIVISION.
           PERFORM LOAD-PROGRAM THRU LOAD-PROGRAM-FN.

       EXIT-PROGRAM.
           IF ERROR-STRING NOT = SPACES
             DISPLAY 
               "Error in " ERROR-STRING
             END-DISPLAY
           END-IF.
           STOP RUN.

       LOAD-PROGRAM.
      *-------------*
           ACCEPT ARG-COUNT 
             FROM ARGUMENT-NUMBER
           END-ACCEPT.
           IF ARG-COUNT NOT = 1
             STRING "LOAD-PROGRAM | Wrong number of arguments: " 
               ARG-COUNT
               INTO ERROR-STRING
             END-STRING
             GO EXIT-PROGRAM
           END-IF.

           ACCEPT PROGRAM-PATH 
             FROM ARGUMENT-VALUE
           END-ACCEPT.

           MOVE 1   TO FILE-LINE.
           MOVE "N" TO EOF.
           OPEN INPUT PROGRAM-FILE.
           PERFORM UNTIL EOF = "Y"
             READ PROGRAM-FILE INTO INSTRUCTION (FILE-LINE)
               AT END 
                 MOVE "Y" TO EOF
               NOT AT END
                 DISPLAY "Loaded: " INSTRUCTION (FILE-LINE) END-DISPLAY
                 ADD 1 TO FILE-LINE 
                   GIVING FILE-LINE
                 END-ADD
             END-READ
           END-PERFORM.
           CLOSE PROGRAM-FILE.
       LOAD-PROGRAM-FN.
      *----------------*
           EXIT.

