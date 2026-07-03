--DROP FUNCTION CASCADE mifuncion();
--\df mif*
CREATE OR REPLACE FUNCTION mifuncion(dato int)
RETURNS decimal
AS $$

BEGIN

    RETURN ROUND(dato/2.0,4);

END;
$$ LANGUAGE plpgsql;