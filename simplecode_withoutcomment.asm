INIT: LI R0 0                   
LI R1 0                         
LI R2 0                         
LI R3 0                         
CLEARSCREEN: LI R4 9            
SLL R4 R4 0                     
ADDIU R4 60                     
CLEARCHAR: SUBU R4 R2 R5        
BEQZ R5 SETCURSORLEFTTOP        
NOP
LI R5 BF
SLL R5 R5 0                     
SW R5 R1 5
SW R5 R2 4
ADDIU R2 1                      
B CLEARCHAR                     
NOP
SETCURSORLEFTTOP: LI R2 0       
LI R5 BF
SLL R5 R5 0
SW R5 R2 7
GETCURRENTKEY: MOVE R0 R1       
LI R5 BF                        
SLL R5 R5 0
LW R5 R1 6
SUBU R0 R1 R5                   
BEQZ R5 GETCURRENTKEY           
NOP
BEQZ R1 GETCURRENTKEY           
NOP
LI R5 8                        
SLTU R1 R5
BTEQZ E                         
NOP
LI R4 4F                        
CMP R3 R4
BTEQZG ETCURRENTKEY             
NOP
ADDIU R3 1                      
LI R5 BF                        
SLL R5 R5 0
SW R5 R1 5
SW R5 R2 4
ADDIU R2 1                      
SW R5 R2 7
B GETCURRENTKEY                 
NOP
JUDGEBKSP: LI R5 8            
SUBU R5 R1 R5
BNEZ R5 JUDGECLEARSCREEN        
NOP
LI R4 0                         
CMP R3 R4
BTEQZ GETCURRENTKEY             
NOP
ADDIU R3 FF                     
LI R5 BF                        
SLL R5 R5 0
ADDIU R2 FF                     
SW R5 R2 7
SW R5 R1 5 
SW R5 R2 4
B GETCURRENTKEY                 
NOP
JUDGEEXIT: LI R5 10             
SUBU R5 R1 R5
BNEZ R5 JUDGEENTER              
NOP
B QUIT                          
NOP
JUDGEENTER: LI R5 d            
SUBU R5 R1 R5
BNEZ R5 NEXT                    
NOP
LI R4 50                        
SUBU R4 R3 R4
ADDU R2 R4 R2                   
LI R3 0                         
LI R5 BF                        
SLL R5 R5 0
SW R5 R2 7
B GETCURRENTKEY                 
NOP
NEXT: B GETCURRENTKEY           
NOP
QUIT: JR R7
NOP
