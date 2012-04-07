-- Programa cliente:

with Gnat.Io; use Gnat.Io;
with Generic_Stack; use G_Stack;

procedure Stack_User is
   -- Pilha:
   S: Gen_Stack;
   Exciting: Generic;

begin
   -- S.Size := 5; -> tipo privado, logo nao eh permitido

   -- Le numeros inteiros e empilha:
   loop
      Put("> ");
      Get(Exciting);
      exit when Exciting = '0';
      Push(S, Exciting);
   end loop;

   -- Desempilha e imprime
   while not Empty(S) loop
      Pop(S, Exciting);
      Put(Exciting);
      exit when Empty(S);
      Put(" ");
   end loop;
   New_Line;
end Stack_User;
