FUNCTION Maximum_Generic(L, R : ValueType) RETURN ValueType IS

BEGIN 
	IF Compare(L, R) THEN
		RETURN L;
	ELSE
		RETURN R;
	END IF;
END Maximum_Generic;
