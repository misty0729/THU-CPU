NOP
LI R0 0                   
LI R1 0                         
LI R2 0                         
LI R3 0                         
NOP
LI R4 9            
SLL R4 R4 0                     
ADDIU R4 60                     
NOP
SUBU R4 R2 R5        
BEQZ R5 8        
NOP
LI R5 BF
SLL R5 R5 0                     
SW R5 R2 4
SW R5 R1 5
ADDIU R2 1                      
B 7f6                     
NOP
NOP
LI R2 0       
LI R5 BF
SLL R5 R5 0
SW R5 R2 7
NOP
MOVE R0 R1       
LI R5 BF                        
SLL R5 R5 0
LW R5 R1 6
SUBU R0 R1 R5                   
BEQZ R5 f9           
NOP
BEQZ R1 f7           
NOP
LI R5 10                        
SLTU R5 R1 
BTEQZ E                         
NOP
LI R4 4F                        
CMP R3 R4
BTEQZ 2e             
NOP
ADDIU R3 1                      
LI R5 BF                        
SLL R5 R5 0
SW R5 R2 4
SW R5 R1 5
ADDIU R2 1                      
SW R5 R2 7
B 7e6                 
NOP
NOP
LI R5 8            
SUBU R5 R1 R5
BNEZ R5 e        
NOP
LI R4 0                         
CMP R3 R4
BTEQZ dd             
NOP
ADDIU R3 FF                     
LI R5 BF                        
SLL R5 R5 0
ADDIU R2 FF                     
SW R5 R2 4
SW R5 R1 5
SW R5 R2 7
B 7d4                 
NOP
NOP
LI R5 09     
SUBU R5 R1 R5
BNEZ R5 3               
NOP
B 7b4                          
NOP
NOP
LI R5 10             
SUBU R5 R1 R5
BNEZ R5 3              
NOP
B 12                          
NOP
NOP
LI R5 d            
SUBU R5 R1 R5
BNEZ R5 a                    
NOP
LI R4 50                        
SUBU R4 R3 R4
ADDU R2 R4 R2                   
LI R3 0                         
LI R5 BF                        
SLL R5 R5 0
SW R5 R2 7
B 7b8                 
NOP
NOP
B 7b5           
NOP
NOP
JR R7
NOP
