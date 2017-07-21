PL/SQL Developer Test script 3.0
7
declare
  -- Non-scalar parameters require additional processing 
  result dbvestib.pc_anoenem.tab_anoenem;
begin
  -- Call the function
  result := dbvestib.pc_anoenem.f_tbl_anoenem(p_codconc => :p_codconc);
end;
1
p_codconc
1
2013
5
0
