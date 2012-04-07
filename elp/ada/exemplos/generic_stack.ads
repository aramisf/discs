package Generic_Stack is

   -- Gen_Stack stands for Generic Stack!
   generic
     type Gen_Stack is private;
     type Gen_Elem is private;

   -- Tamanho maximo da pilha:
   Max_Size: constant Integer := 100;

   -- Declarando os procedimentos:
   procedure Push(S: in out Gen_Stack; E: Gen_Elem );
   procedure Pop(S: in out Gen_Stack; E: Gen_Elem);
   function Top(S: Gen_Stack) return Gen_Elem;
   function Empty(S: Gen_Stack) return Boolean;
   function Full(S: Gen_Stack) return Boolean;
   procedure Clean(S: in out Gen_Stack);

   private

      type Stack_Generic_Type is array(1..Max_Size) of Gen_Elem;
      type Gen_Stack is record
         Size: Integer := 0;
         Data: Stack_Generic_Type;
      end record;

end Generic_Stack;
