ALTER TABLE video_iframes
ADD COLUMN phash_bit bit(64);

UPDATE video_iframes
SET phash_bit = ('x' || phash)::bit(64);