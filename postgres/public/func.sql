CREATE OR REPLACE FUNCTION phash_distance(
    hash1 TEXT,
    hash2 TEXT
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    b1 BIT(64);
    b2 BIT(64);
    x  BIT(64);
BEGIN

    b1 := ('x' || hash1)::bit(64);
    b2 := ('x' || hash2)::bit(64);

    x := b1 # b2;

    RETURN length(replace(x::text,'0',''));

END;
$$;