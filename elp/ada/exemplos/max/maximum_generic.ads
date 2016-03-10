GENERIC
TYPE ValueType IS PRIVATE;
WITH FUNCTION Compare(L, R : ValueType) RETURN Boolean;

FUNCTION Maximum_Generic(L, R : ValueType) RETURN ValueType;

