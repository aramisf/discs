package body Generic_Stack is

   procedure Push(S: in out Gen_Stack; E: Gen_Elem) is
   begin
      if S.Size < Max_Size then
         S.Size := S.Size + 1;
         S.Data(S.Size) := E;
      end if;
   end Push;


   procedure Pop(S: in out Gen_Stack; E: out Gen_Elem) is
   begin
      if S.Size > 0 then
         E := S.Data(S.Size);
         S.Size := S.Size - 1;
      end if;
   end Pop;


   function Top(S: Gen_Stack) return Gen_Elem is
   begin
      if S.Size > 0 then
         return S.Data(S.Size);
      else
         return 0;
      end if;
   end Top;


   function Empty(S: Gen_Stack) return Boolean is
   begin
      return S.Size = 0;
   end Empty;


   function Full(S: Gen_Stack) return Boolean is
   begin
      return S.Size = Max_Size;
   end Full;


   procedure Clean(S: in out Gen_Stack) is
   begin
      S.Size := 0;
   end Clean;
end Generic_Stack;
