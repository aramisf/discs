WITH Ada.Text_IO;
WITH Ada.Float_Text_IO;
WITH Ada.Integer_Text_IO;
WITH Maximum_Generic;

PROCEDURE Test_Maximum_Generic IS

--Instancia uma funcao de maximo para Float usando >  
FUNCTION Maximum IS
NEW Maximum_Generic (ValueType=>Float, Compare=> ">");

--Instancia uma funcao de maximo para Float usando <  
FUNCTION Minimum IS
NEW Maximum_Generic (ValueType=>Float, Compare=> "<");

--Instancia uma funcao de maximo para Integer usando >  
FUNCTION Maximum IS
NEW Maximum_Generic (ValueType=>Integer, Compare=> ">");

--Instancia uma funcao de maximo para Float usando >  
FUNCTION Minimum IS
NEW Maximum_Generic (ValueType=>Integer, Compare=> "<");



--cria um tipo carro
type Car is record
	Modelo 		: String (1 .. 7);
	NumeroLugares 	: Positive range 1 .. 10;
	Cor 			: String  (1 .. 5);
	HPs 			: Float range 0.0 .. 2_000.0;
end record;


--cria uma funcao que compara 2 carros pela potencia
Function CarCompareHP(A, B : Car) return Boolean is
begin
	if A.HPs > B.HPs then
		return true;
	else
		return false;
	end if;
end CarCompareHP;


--cria uma funcao que compara 2 carros pelo numero de lugares
Function CarCompareLugares(A, B : Car) return Boolean is
begin
	if A.NumeroLugares > B.NumeroLugares then
		return true;
	else
		return false;
	end if;
end CarCompareLugares;




-- Instancia um Maximo entre carros usando a funcao que compara Potencia
FUNCTION MaxCarsHP IS
NEW Maximum_Generic (ValueType=>Car, Compare=> CarCompareHP);

-- Instancia um Maximo entre carros usando a funcao que compara Numero de lugares
FUNCTION MaxCarsLugares IS
NEW Maximum_Generic (ValueType=>Car, Compare=> CarCompareLugares);


--Declara 2 carros
Peugeot: Car := ("Peugeot", 4, "Prata", 65.0);
Porsche : Car := ("Porsche", 2, "Preto", 640.0);


BEGIN 
	Ada.Text_IO.Put("Maximo entre -3 e 7: ");
	Ada.Text_IO.New_Line;
	Ada.Integer_Text_IO.Put(Item => Maximum(-3, 7), Width=>1);
	Ada.Text_IO.New_Line;
	Ada.Text_IO.New_Line;

	Ada.Text_IO.Put("Minimo entre -3 e 7: ");
	Ada.Text_IO.New_Line;
	Ada.Integer_Text_IO.Put(Item => Minimum(-3, 7), Width=>1);
	Ada.Text_IO.New_Line(Spacing => 2);

	Ada.Text_IO.Put("Maximo entre -3.29 e 7.84: ");
	Ada.Text_IO.New_Line;
	Ada.Float_Text_IO.Put
	(Item => Maximum(-3.29, 7.84), Fore=>1, Aft=>2, Exp=>0);
	Ada.Text_IO.New_Line;
	Ada.Text_IO.New_Line;

	Ada.Text_IO.Put("Minimo entre -3.29 e 7.84: ");
	Ada.Text_IO.New_Line;
	Ada.Float_Text_IO.Put
	(Item => Minimum(-3.29, 7.84), Fore=>1, Aft=>2, Exp=>0);
	Ada.Text_IO.New_Line(Spacing => 2);
	Ada.Text_IO.New_Line;

	Ada.Text_IO.Put_Line("Maximo entre Peugeot e Porsche, usando comparador de Potencia: ");
	Ada.Text_IO.Put_Line(MaxCarsHP(Peugeot,Porsche).modelo);	
	Ada.Text_IO.New_Line;

	Ada.Text_IO.Put_Line("Maximo entre Peugeot e Porsche, usando comparador de Numero de lugares: ");
	Ada.Text_IO.Put_Line(MaxCarsLugares(Peugeot,Porsche).modelo);	
	Ada.Text_IO.New_Line;


END Test_Maximum_Generic;
